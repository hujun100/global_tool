import requests
from bs4 import BeautifulSoup
import os,cv2
import traceback
import threading
from time import ctime, sleep
import time

root='/home/scw4750/vgg-face-dataset/vgg_face_dataset/files/'
output='/home/scw4750/vgg-face-dataset/vgg_face_dataset/dataset/'
failed_file = '/home/scw4750/vgg-face-dataset/vgg_face_dataset/failed.txt'
if os.path.exists(failed_file):
   failed=open(failed_file,'a')
else:
   failed=open(failed_file,'w')
'''def download(url, filename):
    if os.path.exists(filename):
        print('file exists!')
        return
    try:
        r=requests.get(url,stream=True,timeout=30)
        r.raise_for_status()
        with open(filename,'wb') as f:
            for chunk in r.iter_content(chunk_size=1024):
                if chunk:
                    f.write(chunk)
                    f.flush()
        return filename
    except KeyboardInterrupt:
        if os.path.exists(filename):
            os.remove(filename)
        raise KeyboardInterrupt
    except Exception:
        traceback.print_exc() if os.path.exists(filename):
            os.remove(filename)'''
failed_count=0
all_count = 0
begin_time = time.time()
def crawl_with_multithread(root,size_thread,id_thread,thread_lock):
    global failed_count, all_count
    for parent,dirNames,fileNames in os.walk(root):
        fileNames.sort()
        filesize_per_thread=len(fileNames)/size_thread
        fileNames =  fileNames[id_thread*filesize_per_thread:(id_thread+1)*filesize_per_thread]
        for fileName in fileNames:
            dirName=fileName.split('.txt')[0]
            print dirName
            if os.path.exists(output + dirName) is not True:
                os.mkdir(output+dirName)
            fin=open(root+fileName,'r')
            lines=fin.readlines()
            for line in lines:
                with thread_lock:
                    all_count = all_count + 1
                    if all_count % 100 == 0:
                        now_time = time.time()
                        speed = all_count/(now_time - begin_time)
                        print('\n\n\n\n speed(num/s): %f \n\n\n\n' % speed)
                segments=line.split()
                url=segments[1]
                num=segments[0]
                imgName=output+dirName+'/'+num+'.jpg'
                if os.path.exists(imgName):
                   continue
                else:
                    try:
                        r = requests.get(url, stream=True, timeout=30)
                        r.raise_for_status()
                        with open(imgName, 'wb') as f:
                            for chunk in r.iter_content(chunk_size=1024):
                                if chunk:
                                    f.write(chunk)
                                    f.flush()
                        print imgName
                        import cv2
                        img = cv2.imread(imgName)
                        img.shape
                    except Exception:
                        if os.path.exists(imgName):
                           os.remove(imgName)
                        with thread_lock:
                            failed_count = failed_count + 1
                        print('the failed count:%d  all_count: %d  failed/(failed+success): %f' % (failed_count,all_count,float(failed_count)/all_count))
                        failed.write(dirName+' '+num+'\n')
                        failed.flush()
        
lock = threading.Lock()
num_thread = 32
for i in range(num_thread):
    t = threading.Thread(target = crawl_with_multithread, args=(root,num_thread,i,lock))
    t.start()
#failed.close()

