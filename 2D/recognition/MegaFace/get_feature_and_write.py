import cv2
import numpy as np
import matio
import time
def preprocess_img_vgg(img):
    img = cv2.resize(img,(224,224))
    img=np.float32(img)
    img[:,:,0] = img[:,:,0] - 93.5940
    img[:,:,1] = img[:,:,1] - 104.7624
    img[:,:,2] = img[:,:,2] - 129.1863
    img = np.transpose(img,[2,0,1])
    return img

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

def get_feature_vgg(net,img):
    net.blobs['data'].data[0,:]=img
    net.forward()
    feature=net.blobs['fc7'].data.transpose()
    return feature/np.linalg.norm(feature)


caffe_root = '/home/brl/github/caffe-ms'
import os
import sys
sys.path.insert(0,caffe_root+os.path.sep+'python')

import caffe
caffe.set_device(0)
caffe.set_mode_gpu()
### type == 0 means getting feature by vgg
### type == 1 means getting feature by sphereface
def save_feature_mat(output_root_dir, img_root_dir, ffp, net, type=1):
    with open(ffp,'rt') as f:
        all_lines = f.readlines()
    totalTime = time.time()
    begin_time = time.time()
    for idx in range(0, len(all_lines)):
        iterm=all_lines[idx]
        iterm=iterm.strip('\r\n')
        img_file = img_root_dir+iterm
        img = np.zeros([112,112,3])
        img[:,8:104,:] = cv2.imread(img_file)
        #print('idx:%d  iterm:%s'%(idx, img_root_dir + iterm))
        if type == 0:
            img = preprocess_img_vgg(img)
            feature = get_feature_vgg(net,img)
        else:
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
    prototxt='/home/brl/Megaface/caffe-r34-amf/model.prototxt'
    caffemodel='/home/brl/Megaface/caffe-r34-amf/model.caffemodel';
    net=caffe.Net(prototxt,caffemodel,caffe.TEST)

    prototxt='/home/brl/Megaface/norm_s30_m0.35/test.prototxt'
    caffemodel='/home/brl/Megaface/norm_s30_m0.35/face_train_test_iter_30000.caffemodel';
    net=caffe.Net(prototxt,caffemodel,caffe.TEST)

    ffp = '/home/brl/megaface_help/facescrub.txt'
    img_root_dir = '/home/brl/megaface_help/finalFacescrub/'
    output_root_dir = '/home/brl/Megaface/feature/facescrub/'
    save_feature_mat(output_root_dir, img_root_dir, ffp, net, 1)

    #ffp = '/home/brl/Megaface/distractor_1m.txt'
    #img_root_dir = '/home/brl/Megaface/alignedFlick/' 
    #output_root_dir = '/home/brl/Megaface/feature/distractor/' 
    #save_feature_mat(output_root_dir, img_root_dir, ffp, net, 1)


