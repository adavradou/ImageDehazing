"""
cmdline.py
Author: Gabriel Schwartz (gbs25@drexel.edu)
License: See LICENSE.
"""
import argparse

GRAB_WIN_NAME = "Select a region containing only fog pixels and press Enter, or Q to cancel."
DEPTH_PRIOR_TYPES = ("laplace", "gaussian")

defaults = {
    "albedo_output"         : "final_albedo.png",
    "depth_output"          : "final_depth.png",
    "n_outer_iterations"    : 3,
    "n_inner_iterations"    : 20,
    "prior_C_weight"        : 2e-6,
    "prior_D_weight"        : 1,
    "depth_prior_type"      : "laplace",
}


def make_arg_parser():

    parser = argparse.ArgumentParser(description="""Removes fog from an image
            by factoring the image into albedo and depth layers.""")

##    parser.add_argument("image", type=str, help="Filename of the image to defog.")

    parser.add_argument("--albedo-output", type=str, dest="albedo_output",
            help="Filename for the albedo layer image output.")

    parser.add_argument("--depth-output", type=str, dest="depth_output",
            help="Filename for the depth layer image output.")

    parser.add_argument("--no", metavar="N_OUTER_ITERATIONS", type=int,
            default=defaults["n_outer_iterations"], dest="n_outer_iterations",
            help="""Number of iterations of alternating minimization to
            perform. Each alternation iteration performs 2*N_INNER_ITERATIONS
            steps.""")

    parser.add_argument("--ni", metavar="N_INNER_ITERATIONS", type=int,
            default=defaults["n_inner_iterations"], dest="n_inner_iterations",
            help="""Number of iterations allowed for optimization for each of
            the albedo/depth layers.""")

    group = parser.add_mutually_exclusive_group()
    group.add_argument("--airlight", metavar=("R", "G", "B"),
            type=float, nargs=3, dest="airlight",
            help="""Use the given floating point [0-1] RGB value as the airlight
            color.""")
    group.add_argument("--airlight-rect", metavar=("X", "Y", "W", "H"),
            type=int, nargs=4, dest="airlight_rect",
            help="""Specify the airlight as the mean RGB color within the given
            rectangular image region. If neither this option nor --airlight are
            provided, you will be prompted to select a region of
            airlight-colored image pixels.""")

    parser.add_argument("--apw", metavar="ALBEDO_PRIOR_WEIGHT", type=float,
            default=defaults["prior_C_weight"], dest="apw")

    parser.add_argument("--dpw", metavar="DEPTH_PRIOR_WEIGHT", type=float,
            default=defaults["prior_D_weight"], dest="dpw")

    parser.add_argument("--dpt", metavar="DEPTH_PRIOR", type=str,
            choices=DEPTH_PRIOR_TYPES, dest="dpt", default=DEPTH_PRIOR_TYPES[0],
            help="Depth prior type. Choices are: " + ", ".join(DEPTH_PRIOR_TYPES) + ".")

    parser.add_argument("-ms", action="store_true", dest="multiscale",
            help="Enable multi-scale coarse-to-fine optimization.")

    parser.add_argument("-id", action="store_true", dest="save_initial_depth",
            help="""Save the initial depth estimate to "initial_depth.png".""")

    parser.add_argument("-v", action="store_true", dest="verbose",
            help="Enable verbose optimization progress display.")

    return parser
