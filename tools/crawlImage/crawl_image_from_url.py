import requests
from bs4 import BeautifulSoup
import os,cv2
import traceback

root='G:/VGG-FACE/files/'
output='G:/VGG-FACE/dataset/'
failed=open('G:/VGG-FACE/test.txt','w')
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
        traceback.print_exc()
        if os.path.exists(filename):
            os.remove(filename)'''

for parent,dirNames,fileNames in os.walk(root):
    for fileName in fileNames:
        dirName=fileName.split('.txt')[0]
        print dirName
        if os.path.exists(output + dirName):
            print(dirName + ' already exists!')
        else:
            os.mkdir(output+dirName)
        fin=open(root+fileName,'r')
        lines=fin.readlines()
        for line in lines:
            segments=line.split()
            url=segments[1]
            num=segments[0]
            imgName=output+dirName+'/'+num+'.jpg'
            # download(url,output+dirName+'/'+num+'.jpg')

            try:
                r = requests.get(url, stream=True, timeout=30)
                r.raise_for_status()
                with open(imgName, 'wb') as f:
                    for chunk in r.iter_content(chunk_size=1024):
                        if chunk:
                            f.write(chunk)
                            f.flush()
                print imgName
            # except KeyboardInterrupt:
            #     if os.path.exists(imgName):
            #         os.remove(imgName)
            #     raise KeyboardInterrupt
            except Exception:
                traceback.print_exc()
                if os.path.exists(imgName):
                    os.remove(imgName)
                failed.write(dirName+' '+num+'\n')
failed.close()