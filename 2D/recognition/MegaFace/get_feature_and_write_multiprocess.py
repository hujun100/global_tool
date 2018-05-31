import cv2
import numpy as np
import matio
import time
from multiprocessing import Process

def preprocess_img_centerloss(img):
    #img = cv2.resize(img,(112,96))
    img=np.float32(img)
    img=(img-127.5)/128.0
    img = np.transpose(img,[2,0,1])
    return img

def get_feature_centerloss(net,img):
    net.blobs['data'].data[0,:]=img
    net.forward()
    feature1=net.blobs['fc5'].data.transpose()
    net.blobs['data'].data[0,:]=img[:,:,::-1]
    net.forward()
    feature2=net.blobs['fc5'].data.transpose()
    feature = np.concatenate((feature1,feature2))
    return feature/np.linalg.norm(feature)


caffe_root = '/home/brl/github/caffe-ms'
import os
import sys
sys.path.insert(0,caffe_root+os.path.sep+'python')

import caffe
caffe.set_device(0)
caffe.set_mode_gpu()
def save_feature_mat(output_root_dir, img_root_dir, ffp, net, thread_size, thread_id):
    with open(ffp,'rt') as f:
        all_list = f.readlines()
    totalTime = time.time()
    begin_time = time.time()

    filesize_per_thread = int(len(all_list) / thread_size)
    thread_list = all_list[thread_id*filesize_per_thread:(thread_id+1) * filesize_per_thread]
    if thread_id == thread_size - 1:
        thread_list = all_list[thread_id*filesize_per_thread::]

    for idx, iterm in enumerate(thread_list):
        iterm=iterm.strip('\r\n')
        img_file = img_root_dir+iterm
        print(img_file)
        img = np.zeros([112,96,3])
        img = cv2.imread(img_file)
        #print('idx:%d  iterm:%s'%(idx, img_root_dir + iterm))

        img = preprocess_img_centerloss(img)
        feature = get_feature_centerloss(net,img)  
        #feature_copy = np.concatenate((feature, np.zeros([3072,1], dtype=np.float32))).copy()    
        feature_copy = feature.copy()       
        output_file = output_root_dir+iterm+'.bin'
        output_dir = output_root_dir + '/'.join(iterm.split('/')[0:-1])
        if os.path.exists(output_dir) is False:
            os.makedirs(output_dir)
        #output_dir = output_root_dir + iterm.split('/')[0]+ os.path.sep + iterm.split('/')[1]
        #if os.path.exists(output_dir) is False:
        #    os.mkdir(output_dir)
        #print(feature.shape)
        matio.save_mat(output_file,feature_copy)
        if idx % 1000 == 0:
            print('idx:%d;process 1000 images time:%f;used time:%f min)'%(idx, time.time()-begin_time, (time.time()-totalTime)/60))
            begin_time = time.time()
            
if  __name__ == '__main__':
    prototxt='/home/brl/Megaface/norm_s30_m0.35/test.prototxt'
    caffemodel='/home/brl/Megaface/norm_s30_m0.35/face_train_test_iter_30000.caffemodel';
    net=caffe.Net(prototxt,caffemodel,caffe.TEST)

    #ffp = '/home/brl/Megaface/facescrub.txt'
    #img_root_dir = '/home/brl/finalFacescrub/'
    #output_root_dir = '/home/brl/Megaface/feature/facescrub/'
    #save_feature_mat(output_root_dir, img_root_dir, ffp, net, 1)

    ffp = '/home/brl/Megaface/distractor_1m.txt'
    img_root_dir = '/home/brl/Megaface/alignedFlick/' 
    output_root_dir = '/home/brl/Megaface/feature/distractor/' 
    
    begin = time.time()
    thread_num = 1
    thread_list = []
    for i in range(thread_num):
        t = Process(target=save_feature_mat, args=(output_root_dir, img_root_dir, ffp, net, thread_num, i))
        thread_list.append(t)
        t.start()
    for idx, t in enumerate(thread_list):
        t.join()
    end = time.time()
    print(end-begin)


