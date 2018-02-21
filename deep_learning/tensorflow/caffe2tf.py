#!/usr/bin/env python
##big notices:
##big notices:
##big notices:
##big notices:
##big notices:
##big notices:
##big notices:
##big notices:
##big notices:
##big notices:
##big notices:
##big notices:
##big notices:
##big notices:
##big notices:  this code is just for vgg face and you should change some code even you want to use it for vgg face. So read code carefully
## Uncomment this if necessary
caffe_root = '/home/scw4750/github/caffe/python'
import sys
sys.path.append(caffe_root)
import caffe
from google.protobuf import text_format
from caffe.proto import caffe_pb2
import argparse
import pickle

def format_convolution(layer):
  fmt = "{0} = tf.nn.bias_add(tf.nn.conv2d({1}, self.weights['{0}'],strides=[1,1,1,1], padding='SAME'),self.biases['{0}'],name='{0}')"
  param = layer.convolution_param
  return fmt.format(layer.top[0],
                    layer.bottom[0])

def format_relu(layer):
  return "{0} = tf.nn.relu({1},name='{0}')".format(layer.top[0], layer.bottom[0])

def format_pooling(layer):
  param = layer.pooling_param
  pool = 'tf.nn.max_pool' if param.pool == layer.pooling_param.MAX else 'layers.avg_pool'
  return "{0} = {1}({2},ksize=(1,{3},{3},1),strides=(1,{4},{4},1),padding='SAME')".format(layer.top[0],
                                           pool,
                                           layer.bottom[0],
                                           param.kernel_size,
                                           param.stride)

def format_fc(layer):
  fmt = "{0} = tf.nn.bias_add(tf.nn.conv2d({1}, self.weights['{0}'],strides=[1,1,1,1], padding='VALID'),self.biases['{0}'],name='{0}')"
  param = layer.convolution_param
  return fmt.format(layer.top[0],
                    layer.bottom[0])

def format_dropout(layer):
  param=layer.dropout_param
  return "{0}=tf.nn.dropout({1},{2})".format(layer.top[0],layer.bottom[0],1-param.dropout_ratio)

def format_network(net_pb, init_dict=None):
  src = ''
  for lid, layer in enumerate(net_pb.layer):
    if layer.type == 'Convolution':
      src += format_convolution(layer)
    elif layer.type == 'ReLU':
      src += format_relu(layer)
    elif layer.type == 'Pooling':
      src += format_pooling(layer)
    elif layer.type == 'InnerProduct':
      src += format_fc(layer)
    elif layer.type == 'Dropout':
      src += format_dropout(layer)
    else:
      raise ValueError('Unknown layer type: %s' % layer.type)
    src += '\n'

  for lid, layer in enumerate(net_pb.layers):
    if layer.type == 4:
      src += format_convolution(layer)
    elif layer.type == 18:
      src += format_relu(layer)
    elif layer.type == 17:
      src += format_pooling(layer)
    elif layer.type == 14:
      src += format_fc(layer)
    elif layer.type == 6:
      src += format_dropout(layer)
    elif layer.type == 20:
      continue
    else:
      raise ValueError('Unknown layer type: %s' % layer.type)
    src += '\n'

  return src


def convert_weights(weights):
  if len(weights.shape)==4:
    return weights.transpose((2,3,1,0))
  if len(weights.shape)==2:
    return weights.transpose((1,0))
  return weights

parser = argparse.ArgumentParser(description='Very simplistic converter of caffe models')
parser.add_argument('--model', dest='model_path', required=True, help='path to .prototxt')
parser.add_argument('--weights', dest='weights_path', required=True, help='path to .caffemodel')
parser.add_argument('--src', dest='src_path', required=True, help='path to save the resulting source code')
parser.add_argument('--pkl', dest='pkl_path', required=True, help='path to save the pickled parameters')

args = parser.parse_args()

## saving the weights in a dict
net = caffe.Net(args.model_path, caffe.TRAIN, weights=args.weights_path)
#parameters = { name : [ convert_weights(blob.data) for blob in blobs ]
#               for name, blobs in net.params.iteritems() }
#pickle.dump(parameters, open(args.pkl_path, 'wb'))

## saving the generated python code
net_pb = caffe_pb2.NetParameter()
net_pb = text_format.Parse(open(args.model_path).read(), net_pb)

src = format_network(net_pb)
with open(args.src_path, 'w') as f:
  f.writelines(src)




