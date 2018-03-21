caffe_root = '/home/idealsee/github/caffe-sphereface-mod2/python' # change your pycaffe root here
import sys
sys.path.append(caffe_root)

import caffe
import numpy as np

model = '/home/idealsee/clean_data/snapshot/v1/sphereface_model_iter_30000.caffemodel'   #change your .caffemodel file here
proto = '/home/idealsee/clean_data/train_file_v1/sphereface_deploy.prototxt'   #change your .prototxt file here

faceNet = caffe.Net(proto,model,caffe.TEST)

fc6_1 = faceNet.params['fc6_1'][0].data  # classification weights of MS
fc6_2 = faceNet.params['fc6_2'][0].data  # classification weights of VGG2

out = np.dot(fc6_2,fc6_1.T)   

f = open('./vgg_asia_reduplicton_id.txt','w')

for i in range(out.shape[0]):
    if (i % 1000 == 0):
        print(i)
    for j in range(out.shape[1]):
        if (out[i,j]>0.5): #0.5 is threshold
            print(str(i)+' '+str(j)+' '+ str(out[i,j]))
            f.write(str(i)+' '+str(j)+' '+ str(out[i,j]) + '\n')

f.close()



