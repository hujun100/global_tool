from skimage import io
from skimage import transform as trans
import os
import numpy as np
import cv2
import time
import threading
from multiprocessing import Process
import matplotlib.pyplot as plt

def read_5pt(pts_file):
    with open(pts_file, 'rt') as f:
        all_line = f.readlines()
    pts = np.zeros((5, 2), dtype=np.float32)
    bbox = np.zeros(5, dtype=np.float32)
    for i in range(5):
        all_line[i] = all_line[i].rstrip('\n')
        pts[i, :] = [float(data) for data in all_line[i].split(' ')]
    bbox[:] = [float(data) for data in all_line[5].split(' ')]
    return pts, bbox


def centerloss_align_single(img, pts_file):
    src = np.array([
        [30.2946, 51.6963],
        [65.5318, 51.5014],
        [48.0252, 71.7366],
        [33.5493, 92.3655],
        [62.7299, 92.2041]], dtype=np.float32)
    pts, bbox = read_5pt(pts_file)
    tform = trans.SimilarityTransform()
    tform.estimate(pts, src)
    M = tform.params[0:2, :]
    warped = cv2.warpAffine(img, M, (96, 112), borderValue=0.0)
    return warped


def align_megaface_distractor(thread_size, thread_id):
    data_list_file = '/home/brl/Megaface/distractor_1m.txt'
    des_dir = '/media/brl/30AA83A3AA836466/alignedFlick3pt/'
    source_dir = '/media/brl/30AA83A3AA836466/FlickrFinal2/'
    data_list_file = '/home/brl/BRL/image/gal.txt'
    des_dir = '/home/brl/BRL/image/aligned_gallery/'
    source_dir = '/home/brl/BRL/image/gallery_wrapper/'
    with open(data_list_file, 'rt') as f:
        all_list = f.readlines()
    filesize_per_thread = int(len(all_list) / thread_size)
    thread_list = all_list[thread_id*filesize_per_thread:(thread_id+1) * filesize_per_thread]
    if thread_id == thread_size - 1:
        thread_list = all_list[thread_id*filesize_per_thread::]

    for idx, img_name in enumerate(thread_list):
        if idx % 100 == 0:
            print(idx)
        img_name = img_name.rstrip('\n')
        img_file = source_dir + img_name
        img = io.imread(img_file)
        pts_file = img_file + '.5pt'

        des_sub_dir = des_dir + '/'.join(img_name.split('/')[0:-1])
        if not os.path.exists(des_sub_dir):
            os.makedirs(des_sub_dir)

        des_file = des_dir + img_name
        if os.path.exists(pts_file):
            align_img = centerloss_align_single(img, pts_file)
            io.imsave(des_file, align_img)
        else:
            img = trans.resze(img, (112, 96))
            io.imsave(des_file, img)

if __name__ == '__main__':
    #pts, bbox = read_5pt('/home/brl/BRL/image/gallery_wrapper/gallery/100002.jpg.5pt')
    #img = io.imread('/home/brl/BRL/image/gallery_wrapper/gallery/100002.jpg')
    #align_img = centerloss_align_single(img, '/home/brl/BRL/image/gallery_wrapper/gallery/100002.jpg.5pt')
    #io.imshow(align_img)
    #plt.show()
    ###multi thread
    #begin = time.time()
    #thread_num = 4
    #thread_list = []
    #for i in range(thread_num):
    #    t = threading.Thread(target=align_megaface_distractor, args=(thread_num, i))
    #    thread_list.append(t)
    #    t.start()
    #for idx, t in enumerate(thread_list):
    #    t.join()
    #end = time.time()
    begin = time.time()
    thread_num = 16
    thread_list = []
    for i in range(thread_num):
        t = Process(target=align_megaface_distractor, args=(thread_num, i))
        thread_list.append(t)
        t.start()
    for idx, t in enumerate(thread_list):
        t.join()
    end = time.time()
    print(end-begin)
    print('end')
