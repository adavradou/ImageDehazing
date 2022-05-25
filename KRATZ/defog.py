#!/usr/bin/env python

#
#defog.py
#Author: Gabriel Schwartz (gbs25@drexel.edu)
#License: See LICENSE.
#

##import numpy as np
import ast, numpy as np
np.seterr(all="ignore")

from scipy.misc import imread, imsave

from cmdline import make_arg_parser, GRAB_WIN_NAME

gamma = 2.0

args = make_arg_parser().parse_args()


#hazy_images = np.array(ast.literal_eval(open('hazy_data.txt').read()))
#clear_images = np.array(ast.literal_eval(open('clear_data.txt').read()))

hazy_images = np.loadtxt('/home/agapi/Documents/Other_approaches/hazy_data.txt', dtype="str", comments="#", delimiter=" ", unpack=False)
clear_images = np.loadtxt('/home/agapi/Documents/Other_approaches/clear_data.txt', dtype="str", comments="#", delimiter=" ", unpack=False)

    
imagename_hazy = str(hazy_images)
image = imread(r'/home/agapi/server/Haze-Datasets/NITRE_2018/Indoor-Hazy/hazy/{0}'.format(imagename_hazy))                
##image = imread(r'/home/agapi/server/Haze-Datasets/RESIDE_2018/RESIDE_Beta/OTS/hazy_org/34/{0}'.format(imagename_hazy))                
##image = imread(r'/home/agapi/Documents/Other_approaches/data/Hazy/{0}'.format(imagename_hazy))
##    image = imread(imagename_hazy)

if args.albedo_output is None:
    args.albedo_output = imagename_hazy + "_albedo.png"
if args.depth_output is None:
    args.depth_output = imagename_hazy + "_depth.png"

if args.airlight:
    airlight = np.array(args.airlight)
elif args.airlight_rect:
    X,Y,W,H = args.airlight_rect
    try:
        airlight_region = image[Y:Y+H, X:X+W]
        airlight = airlight_region.mean(0).mean(0)
        if args.verbose:
            print("Airlight:", airlight)
    except IndexError:
        print("Invalid airlight region given.")
        exit(1)
else:
    print(GRAB_WIN_NAME)
    from util import grab_image_region
    airlight_region = grab_image_region(image, GRAB_WIN_NAME)
    if airlight_region is None:
        print("Airlight selection canceled.")
        exit(1)
    airlight = airlight_region.mean(0).mean(0)
    if args.verbose:
        print("Airlight:", airlight)

from fmrf import FMRF
if args.save_initial_depth:
    from fmrf import compute_initial_depth
    I_n = image / airlight; I_n /= I_n.max()
    d = compute_initial_depth(I_n)
    imsave("initial_depth.png", 1-(d/d.max()))

fmrf = FMRF(args.apw, args.dpw, args.dpt)

if args.multiscale:
    scales = [0.5, 1.0]
    final_albedo, final_depth = fmrf.factorize_multiscale(
            image, airlight, scales,
            n_outer_iterations = args.n_outer_iterations,
            n_inner_iterations = args.n_inner_iterations,
            verbose = args.verbose)
else:
    final_albedo, final_depth = fmrf.factorize(image, airlight,
            n_outer_iterations = args.n_outer_iterations,
            n_inner_iterations = args.n_inner_iterations,
            verbose = args.verbose)

final_depth /= final_depth.max()
final_albedo = np.power(final_albedo, 1/gamma)

if args.verbose:
    print("Saving albedo to %s..." % args.albedo_output)
    ##imsave(args.albedo_output, (final_albedo * 255.).astype(np.uint8))
imsave(r'/home/agapi/Documents/Other_approaches/13_2009_Kratz_Factorizing_Scene_Albedo/result/ ' + imagename_hazy + '_albedo.jpg', (final_albedo * 255.).astype(np.uint8))

##if args.verbose:
##    print("Saving depth to %s..." % args.depth_output)
##imsave(args.depth_output, 1-(final_depth/final_depth.max()))
