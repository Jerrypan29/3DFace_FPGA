import os
os.environ["PYOPENGL_PLATFORM"] = "egl"
import cv2
from src.facescape_fitter import facescape_fitter
from src.utility import show_img_arr
from src.renderer import render_orthcam
import time

start = time.time()
fs_fitter = facescape_fitter(fs_file = "./bilinear_model_v1.6/facescape_bm_v1.6_847_50_52_id_front_new.npz", 
                             kp2d_backend = 'dlib') 

loading_time = time.time()
print("loading time:",loading_time-start)

src_img = cv2.imread("./test_data/chan.jpg")  

print("reading img file start")

kp2d = fs_fitter.detect_kp2d(src_img) # extract 2D key points


extrat2D_time = time.time()
print("extrat2D time:",extrat2D_time-loading_time)

mesh, a = fs_fitter.fit_kp2d(kp2d) # fit model

basemodel_time = time.time()
print("basemodel time:",basemodel_time-extrat2D_time)

print("program mesh ended")
