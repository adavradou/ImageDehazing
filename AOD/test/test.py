import os
import numpy as np
import caffe
import sys
sys.path.append('/usr/lib/python3/dist-packages/caffe')

from pylab import *
import re
import random
import time
import copy
import matplotlib.pyplot as plt
import cv2
import scipy
import shutil
import csv
from PIL import Image
import datetime

def EditFcnProto(templateFile, height, width):
    with open(templateFile, 'r') as ft:
        template = ft.read()
        #print(templateFile)
        outFile = '/home/agapi/Documents/Other_approaches/03_AOD-Net-master/test/DeployT.prototxt'
        with open(outFile, 'w') as fd:
            fd.write(template.format(height=height,width=width))

def test():
    #caffe.set_mode_gpu()
    #caffe.set_device(0)
    caffe.set_mode_cpu();

   
   # hazy_images = np.array(ast.literal_eval(open('/home/agapi/Documents/Other_approaches/hazy_data.txt').read()))
    #clear_images = np.array(ast.literal_eval(open('/home/agapi/Documents/Other_approaches/clear_data.txt').read()))    
 
    hazy_images = np.loadtxt('/home/agapi/Documents/Other_approaches/hazy_data.txt', dtype="str", comments="#", delimiter=" ", unpack=False)
    clear_images = np.loadtxt('/home/agapi/Documents/Other_approaches/clear_data.txt', dtype="str", comments="#", delimiter=" ", unpack=False)   
    imagename_hazy = str(hazy_images)
    npstore_hazy = caffe.io.load_image('/home/agapi/Documents/Other_approaches/Hazy_Images_NTIRE2018/{0}'.format(imagename_hazy)) 
##    npstore_hazy = caffe.io.load_image('/home/agapi/server/Haze-Datasets/RESIDE_2018/RESIDE_Beta/OTS/hazy_org/34/{0}'.format(imagename_hazy))
    
    imagename_clear = str(clear_images)
    npstore_clear = caffe.io.load_image('/home/agapi/Documents/Other_approaches/Clear_Images_NTIRE2018/{0}'.format(imagename_clear))
##    npstore_clear = caffe.io.load_image('/home/agapi/server/Haze-Datasets/RESIDE_2018/RESIDE_Beta/OTS/clear/{0}'.format(imagename_clear))


    height = npstore_hazy.shape[0]
    width = npstore_hazy.shape[1]

    #HARDCORED LOCATIONS...
    templateFile = '/home/agapi/Documents/Other_approaches/03_AOD-Net-master/test/test_template.prototxt'
    EditFcnProto(templateFile, height, width)

    model='/home/agapi/Documents/Other_approaches/03_AOD-Net-master/AOD_Net.caffemodel';
        

    net = caffe.Net('/home/agapi/Documents/Other_approaches/03_AOD-Net-master/test/DeployT.prototxt', model, caffe.TEST);
    batchdata = []
    data = npstore_hazy
    data = data.transpose((2, 0, 1))
    batchdata.append(data)
    net.blobs['data'].data[...] = batchdata;  

    net.forward();

    data = net.blobs['sum'].data[0];
    data = data.transpose((1, 2, 0));
    data = data[:, :, ::-1]

    savepath = ('/home/agapi/Documents/Other_approaches/03_AOD-Net-master/data/result/AOD_' + imagename_hazy)

    cv2.imwrite(savepath, data * 255.0,[cv2.IMWRITE_JPEG_QUALITY, 100])

def main():
    test()
       
if __name__ == '__main__':
    main()


