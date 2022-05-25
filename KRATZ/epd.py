"""
epd.py
Author: Gabriel Schwartz (gbs25@drexel.edu)
License: See LICENSE.
"""
import sys
import numpy as np
from scipy.misc import *
from scipy.optimize import curve_fit

import cv2

def epd(x, power, scale):
    return np.exp(-np.power(abs(x), power) / scale)

def fit_epd(img):
    chrom = np.nan_to_num(img / img.sum(2)[:,:,np.newaxis])
    dx = cv2.Sobel(chrom, cv2.CV_64F, 1, 0) / 8
    dy = cv2.Sobel(chrom, cv2.CV_64F, 0, 1) / 8

    x = np.vstack([dx.reshape(-1, 3), dy.reshape(-1, 3)])

    power = np.zeros((3,), np.float64)
    scale = np.zeros((3,), np.float64)

    for chan in range(3):
        hist, b = np.histogram(x[:,chan], bins = 128, range = (-.25, 0.25))
        bw = abs(b[0]-b[1])/2.
        hist = hist / float(hist.sum())

        xdata = (b[:-1] + bw)
        power[chan], scale[chan] = curve_fit(epd, xdata, hist, [0.25, 0.25])[0]

    return power, scale
