import sys
sys.path.insert(0,'/home/scw4750/face-alignment/face_alignment')
sys.path.insert(0,'/home/scw4750/face-alignment')
import h5py

import face_alignment
import numpy as np
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt
from skimage import io

fa = face_alignment.FaceAlignment(face_alignment.LandmarksType._3D, enable_cuda=True, flip_input=False)

input = io.imread('../test/assets/aflw-test.jpg')
for i in range(1, 26):
    list_name = '/home/scw4750/face-alignment/examples/data/' + 'webface_list' + str(i) + '.txt'
    preds_name, preds_lm, preds_bbox = fa.process_folder_hujun(list_name, all_faces=False)
    preds_bbox_np = np.zeros([len(preds_bbox), 4])
    for idx, iterm in enumerate(preds_bbox):
        preds_bbox_np[idx, 0] = iterm.rect.left()
        preds_bbox_np[idx, 1] = iterm.rect.top()
        preds_bbox_np[idx, 2] = iterm.rect.width()
        preds_bbox_np[idx, 3] = iterm.rect.height()
    preds_lm_np = np.zeros([len(preds_bbox), 68, 3])
    for i_l in range(len(preds_lm)):
        iterm = preds_lm[i_l][0]
        preds_lm_np[i_l,:,:] = iterm
    print(len(preds_lm))
    print(len(preds_bbox))
    file=h5py.File('/home/scw4750/face-alignment/examples/data/name_lm_bbox' + str(i) + '_3d.h5','w')
    file.create_dataset('names',data=preds_name)
    file.create_dataset('landmarks',data=preds_lm_np)
    file.create_dataset('bboxes',data=preds_bbox_np)
    file.close()
print('end')
