import os
import shutil,os
path = '/home/idealsee/face_train_data_needed/celebrity_asia_byMS'
count = 0
all_folders = os.listdir(path)
all_folders.sort()
for file in all_folders:
    if os.path.isdir(os.path.join(path,file))==True:
            newname=str(count).zfill(6)
            count = count + 1
            shutil.move(os.path.join(path,file),os.path.join(path,newname))
