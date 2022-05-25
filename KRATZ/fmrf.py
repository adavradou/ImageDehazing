"""
fmrf.py
Author: Gabriel Schwartz (gbs25@drexel.edu)
License: See LICENSE.
"""
import os
import numpy as np

from scipy.misc import imresize
from scipy.optimize import fmin_l_bfgs_b

from epd import fit_epd
from util import grid_diff, imresize_float

try:
    import theano
    import theano.tensor as tt

    floatX = theano.config.floatX
    powfun = tt.pow
    sgnfun = tt.sgn
    lib = tt

    USING_THEANO=True
except ImportError:
    powfun = np.power
    sgnfun = np.sign
    lib = np

    USING_THEANO=False

def call_with_eps_check(values, func, eps = 1e-8, default = 0):
    return lib.where(abs(values) > eps, func(values), default)

def make_grid_grad(t, r, b, l, x):
    grad = lib.zeros_like(x)
    if USING_THEANO:
        grad = tt.inc_subtensor(grad[:-1], t)
        grad = tt.inc_subtensor(grad[:, :-1], r)
        grad = tt.inc_subtensor(grad[1:], b)
        grad = tt.inc_subtensor(grad[:, 1:], l)

        # Account for less neighbors on edge pixels.
        grad = tt.set_subtensor(grad[0, :], grad[0, :] * 4./3.)
        grad = tt.set_subtensor(grad[:, 0], grad[:, 0] * 4./3.)
        grad = tt.set_subtensor(grad[-1, :], grad[-1, :] * 4./3.)
        grad = tt.set_subtensor(grad[:, -1], grad[:, -1] * 4./3.)
    else:
        grad[:-1] = t
        grad[:, :-1] += r
        grad[1:] += b
        grad[:, 1:] += l

        # Account for less neighbors on edge pixels.
        grad[0, :] *= 4./3.
        grad[:, 0] *= 4./3.
        grad[-1, :] *= 4./3.
        grad[:, -1] *= 4./3.

    return grad

def compute_initial_depth(I_n):
    i_tilde = np.log(1 - I_n)
    D = -i_tilde.max(2)

    D[np.isinf(D)] = D[np.isfinite(D)].max()
    D[np.isnan(D)] = D[np.isfinite(D)].max()

    return np.clip(D, 1e-3, np.inf)

class FMRF:
    def __init__(self, albedo_prior_weight, depth_prior_weight,
            depth_prior_type = "laplace"):

        self.albedo_prior_weight = albedo_prior_weight
        self.depth_prior_weight = depth_prior_weight
        self.depth_prior_type = depth_prior_type

        self.E = lambda I, A, D, apow, ascale: (self.likelihood(I, A, D) + \
                self.albedo_prior_weight * self.albedo_prior(A, apow, ascale) + \
                self.depth_prior_weight * self.depth_prior(D)) / lib.prod(D.shape)

        self.dE_A = lambda I, A, D, apow, ascale: (self.likelihood_grad_A(I, A, D) + \
                self.albedo_prior_weight * self.albedo_prior_grad(A, apow, ascale)) / \
                 lib.prod(D.shape)

        self.dE_D = lambda I, A, D: (self.likelihood_grad_D(I, A, D) + \
                self.depth_prior_weight * self.depth_prior_grad(D)) / lib.prod(D.shape)

        self.E_and_dE_A = lambda I, A, D, apow, ascale: (self.E(I,A,D,apow,ascale), self.dE_A(I,A,D,apow,ascale))
        self.E_and_dE_D = lambda I, A, D, apow, ascale: (self.E(I,A,D,apow,ascale), self.dE_D(I,A,D))

        if USING_THEANO:
            I = tt.tensor3("I")
            A = tt.tensor3("A")
            D = tt.matrix("D")
            apow = tt.specify_shape(tt.vector("albedo_power"), (3,))
            ascale = tt.specify_shape(tt.vector("albedo_scale"), (3,))

            sym_E = self.E(I, A, D, apow, ascale)
            sym_dE_A = self.dE_A(I, A, D, apow, ascale)
            sym_dE_D = self.dE_D(I, A, D)

            self.E_and_dE_A = theano.function([I, A, D, apow, ascale],
                    [sym_E, sym_dE_A],
                    allow_input_downcast=True, name = "E_and_dE_A")

            self.E_and_dE_D = theano.function([I, A, D, apow, ascale],
                    [sym_E, sym_dE_D],
                    allow_input_downcast=True, name = "E_and_dE_D")

    def likelihood(self, image, albedo, depth):
        I = image
        D = -depth[:, :, np.newaxis]

        I_est = albedo * lib.exp(D) + (1 - lib.exp(D))
        diff = I_est - I

        return (diff ** 2).sum()

    def likelihood_grad_A(self, image, albedo, depth):
        I = image
        D = -depth[:, :, np.newaxis]

        I_est = albedo * lib.exp(D) + (1 - lib.exp(D))
        diff = I_est - I

        return 2. * lib.exp(D) * diff

    def likelihood_grad_D(self, image, albedo, depth):
        I = image
        D = -depth[:, :, np.newaxis]

        I_est = albedo * lib.exp(D) + (1 - lib.exp(D))
        diff = I_est - I

        return (-2. * (albedo - 1) * lib.exp(D) * diff).sum(axis=2)

    def albedo_prior(self, albedo, power, scale):
        color_sum = albedo.sum(axis = 2)[:, :, np.newaxis]
        chromaticity = lib.where(color_sum > 1e-8,
                                 albedo / color_sum,
                                 0)

        cost_func = lambda x : (powfun(abs(x), power) / scale).sum()

        return sum([cost_func(d) for d in grid_diff(chromaticity)])

    def albedo_prior_grad(self, albedo, power, scale):
        color_sum = albedo.sum(axis = 2)[:, :, np.newaxis]
        chromaticity = lib.where(color_sum > 1e-8,
                                 albedo / color_sum,
                                 0)

        grad_func = lambda x : sgnfun(x) * power * powfun(abs(x), power-1) / scale
        checked_grad = lambda d : call_with_eps_check(d, grad_func)

        return make_grid_grad(*[checked_grad(d) for d in grid_diff(chromaticity)], x=albedo)


    def depth_prior(self, depth):
        if self.depth_prior_type == "gaussian":
            cost_func = lambda x : (x**2).sum()
        elif self.depth_prior_type == "laplace":
            cost_func = lambda x : abs(x).sum()
        else:
            raise RuntimeError("Unknown depth prior type: %s" % self.depth_prior_type)

        return sum([cost_func(d) for d in grid_diff(depth)])

    def depth_prior_grad(self, depth):
        if self.depth_prior_type == "gaussian":
            grad_func = lambda x : 2 * x
        elif self.depth_prior_type == "laplace":
            grad_func = lambda x : sgnfun(x)
        else:
            raise RuntimeError("Unknown depth prior type: %s" % self.depth_prior_type)

        return make_grid_grad(*[grad_func(d) for d in grid_diff(depth)], x=depth)

    def factorize(self, image, airlight,
            initial_albedo = None, initial_depth = None,
            n_outer_iterations = 3, n_inner_iterations = 10,
            verbose = False):

        apow, ascale = fit_epd(image)

        I_n = image / airlight
        I_n /= I_n.max()

        A = initial_albedo if initial_albedo is not None else airlight*np.ones_like(image)
        D = initial_depth if initial_depth is not None else compute_initial_depth(I_n)

        for outer_i in range(n_outer_iterations):
            A, D = self.optimize(I_n, apow, ascale, A, D, "A", n_inner_iterations, verbose)
            A, D = self.optimize(I_n, apow, ascale, A, D, "D", n_inner_iterations, verbose)

        return A, D

    def factorize_multiscale(self, orig_image, airlight, scales,
            n_outer_iterations = 3, n_inner_iterations = 10,
            verbose = False):

        prev_d = None
        scales = list(sorted(scales))
        for i in range(len(scales)):
            scale = scales[i]
            image = imresize_float(orig_image, scale)

            if prev_d is not None:
                prev_d = imresize_float(prev_d, image.shape[:2])

            A, D = self.factorize(image, airlight, None, prev_d,
                    n_outer_iterations, n_inner_iterations, verbose)
            prev_d = D

        return A, D

    def optimize(self, I_n, apow, ascale, initial_albedo, initial_depth, partial_type, iters, verbose):
        if partial_type not in ["A", "D"]:
            raise RuntimeError("Invalid partial derivative type '%s'." % partial_type)

        npix = np.prod(initial_depth.shape)

        def f_and_g(x):
            g = np.zeros_like(x)
            a = x[:3*npix].reshape(I_n.shape)
            d = x[3*npix:].reshape(initial_depth.shape)

            if partial_type == "A":
                f, pg = self.E_and_dE_A(I_n, a, d, apow, ascale)
                g[:3*npix] = pg.reshape(-1)
            else:
                f, pg = self.E_and_dE_D(I_n, a, d, apow, ascale)
                g[3*npix:] = pg.reshape(-1)

            return f, g

        x_0 = np.zeros((4 * npix,), np.float64)
        x_0[:3*npix] = initial_albedo.reshape(-1)
        x_0[3*npix:] = initial_depth.reshape(-1)

        x_opt = fmin_l_bfgs_b(f_and_g, x_0,
                bounds  = (
                    [(1e-3, 1)] * 3 * npix +
                    [(1e-3, None)] * npix),
                pgtol = 1e-8,
                maxfun = iters,
                disp = 1 if verbose else 0,
                m = 16)[0]

        try:
            os.remove("iterate.dat")
        except:
            pass

        final_albedo = x_opt[:3*npix].reshape(I_n.shape)
        final_depth = x_opt[3*npix:].reshape(initial_depth.shape)

        return final_albedo, final_depth
