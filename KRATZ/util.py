"""
util.py
Author: Gabriel Schwartz (gbs25@drexel.edu)
License: See LICENSE.
"""

import sys
import numpy as np
from scipy.misc import *
import cv2

KEY_OFFSET = 0x100000

def grab_image_region(image, window_name="Region Grabber"):
    def callback(event, x, y, ignored, data):
        if event == cv2.EVENT_LBUTTONDOWN:
            data[0][0] = [x,y]
            data[2] = True
        elif event == cv2.EVENT_LBUTTONUP:
            data[0][1] = [x,y]
            data[2] = False
        elif event == cv2.EVENT_MOUSEMOVE and data[2]:
            img = data[1].copy()
            cv2.rectangle(img, tuple(data[0][0]), (x, y), (255,255,0))
            cv2.imshow(window_name, img[:,:,::-1])

    roi = [[0,0],[0,0]]
    data = [roi, image, False]

    cv2.namedWindow(window_name)
    cv2.setMouseCallback(window_name, callback, data)
    #cv2.startWindowThread()
    cv2.imshow(window_name, image[:,:,::-1])

    key = None
    while key != '\n' and key != '\r' and key != 'q':
        key = cv2.waitKey(33)
        key = chr(key) if key >= 0 and key <= 255 else None

    cv2.destroyAllWindows()
    cv2.waitKey(1); cv2.waitKey(1); cv2.waitKey(1)

    if key == 'q':
        return None
    else:
        start, end = roi
        return image[start[1]:end[1], start[0]:end[0]]

def imresize_float(image, scale):
    min, max = image.min(), image.max()
    uint = (255. * ((image - min) / (max - min))).astype(np.uint8)

    res = imresize(uint, scale, "nearest") / 255.
    return res * (max - min) + min

def grid_diff(grid):
        top = grid[:-1] - grid[1:]
        right = grid[:, :-1] - grid[:, 1:]
        bot = grid[1:] - grid[:-1]
        left = grid[:, 1:] - grid[:, :-1]

        return (top, right, bot, left)
