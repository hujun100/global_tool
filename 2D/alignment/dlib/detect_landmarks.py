import dlib
import cv2
from cv2 import cv
import h5py
import numpy as np
import os
def detect_bbox_landmarks_single(predictor, img_dir, img_file):

    detector = dlib.get_frontal_face_detector()
    image_path=os.path.join(img_dir,img_file)
    #image_path=image_path[0:len(image_path)-1]
    dlib_img=cv2.imread(image_path)
    dets = detector(dlib_img, 1)
    if len(dets) == 0:
        print '> Could not detect the face, skipping the image...' + image_path
        raise AssertionError('can not detect face')
    if len(dets) > 1:
        print "> Process only the first detected face!"
    detected_face = dets[0]
    bbox=[detected_face.left(),detected_face.top(),detected_face.right(),detected_face.bottom()]

    #cv2.rectangle(dlib_img, (detected_face.left(),detected_face.top()), \
    #  (detected_face.right(),detected_face.bottom()), (0,0,255),2)
    

    shape = predictor(dlib_img, detected_face)
    nLM = shape.num_parts
    
    landmarks=np.zeros([68,2],dtype=np.float32)
    for i in range(0,nLM):
        landmarks[i,0]=shape.part(i).x
        landmarks[i,1]=shape.part(i).y
    return bbox,landmarks

def detect_bbox_landmarks(img_dir,txt_file):
    predictor_path = "dlib_model/shape_predictor_68_face_landmarks.dat"
    predictor = dlib.shape_predictor(predictor_path)
    with open(txt_file,'rt') as f:
        all_lines=f.readlines()
    all_lines=[i.strip('\n') for i in all_lines]
    all_name=[]
    all_bbox=[]
    all_landmarks=[]
    for i in range(len(all_lines)):
        print(i)
        try:
            bbox,landmarks=detect_bbox_landmarks_single(predictor, img_dir,all_lines[i])
        except AssertionError:
            continue
        all_name.append(all_lines[i])
        all_bbox.append(bbox)
        all_landmarks.append(landmarks)
        #print('length of file name:%d' % (len(all_lines[i])))
    return all_name,all_bbox,all_landmarks

def show_img(dlib_img, nLM, landmarks):
    for i in range(nLM):
        cv2.circle(dlib_img, (landmarks[i,0], landmarks[i,1], 5, (255,0,0)))
    cv2.imshow('img',dlib_img)
    cv2.waitKey(0)

if __name__=='__main__':
    img_dir='/home/scw4750/dataset_preprocessing/frgc/frgc_2D_imgs'
    txt_file='/home/scw4750/dataset_preprocessing/frgc/frgc_2D_imgs/frgc.txt'
    name,bbox,landmarks=detect_bbox_landmarks(img_dir,txt_file)
    if os.path.exists('landmarks.h5'):
       os.remove('landmarks.h5')
    file=h5py.File('landmarks.h5')
    file.create_dataset('name',data=name)
    file.create_dataset('bbox',data=bbox)
    file.create_dataset('landmarks',data=landmarks)
    file.close()
