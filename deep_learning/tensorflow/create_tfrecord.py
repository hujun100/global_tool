import os
import argparse
import tensorflow as tf
from PIL import Image
import cv2
from cv2 import cv
def _int64_feature(value):
  return tf.train.Feature(int64_list=tf.train.Int64List(value=[value]))

def _bytes_feature(value):
  return tf.train.Feature(bytes_list=tf.train.BytesList(value=[value]))

parser=argparse.ArgumentParser(description="create tfrecord")
parser.add_argument('--img_dir', dest='img_dir', required=True, help='image dir')
parser.add_argument('--img_list', dest='img_list', required=True, help='txt containing image name and label')
parser.add_argument('--output', dest='output', required=True, help='the tfrecord file')
args = parser.parse_args()


img_dir=args.img_dir
name_label_txt=args.img_list
out_file=args.output
#img_dir='/home/scw4750/github/IJCB2017/liangjie_micc/7_gallery/brl_alignment'
#name_label_txt='name_label.txt'
#out_file='train.tfrecords'

with open(name_label_txt,'rt') as f:
    all_lines=f.readlines()

writer=tf.python_io.TFRecordWriter(out_file)
for i in range(len(all_lines)):
    tline=all_lines[i]
    img_name=tline.split(' ')[0]
    label=tline.split(' ')[1]
    label=int(label)
    img_path=img_dir+os.path.sep+img_name
    img=cv2.imread(img_path)
    img=cv2.resize(img,(224,224))
    img_raw=img.tobytes()
    example=tf.train.Example(features=tf.train.Features(feature={
        'label':_int64_feature(label),
        'img_raw':_bytes_feature(img_raw)
        }))
    writer.write(example.SerializeToString())

writer.close()


