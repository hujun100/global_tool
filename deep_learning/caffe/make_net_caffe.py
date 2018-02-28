from __future__ import print_function
import sys
sys.path.insert(0, '/home/brl/github/caffe-ms/python')
from caffe import layers as L, params as P, to_proto
from caffe.proto import caffe_pb2
import caffe

# The initialization used
xavier_constant = dict(type='xavier')
gaussian_constant = dict(type='gaussian', std=0.01)
msra_constant = dict(type='msra')

class Spherenet(object):
    def __init__(self):
        pass

    def conv_prelu(self, bottom, num_out, kernel_size=3, stride=1, pad=1, is_bias=False,
        wf=gaussian_constant, in_place=False):

        if is_bias:
            learn_param = [dict(lr_mult=1, decay_mult=1), dict(lr_mult=2, decay_mult=0)]
        else:
            learn_param = [dict(lr_mult=1, decay_mult=1), dict(lr_mult=0, decay_mult=0)]
        conv = L.Convolution(bottom,
                             kernel_size=kernel_size,
                             stride=stride,
                             num_output=num_out,
                             pad=pad,
                             param=learn_param,
                             weight_filler=wf,
                             bias_filler=dict(type='constant', value=0),
                             in_place=in_place,
                             engine=1)
        prelu = L.PReLU(conv, in_place=True)
        return prelu

    def conv(self, bottom, num_out, kernel_size=3, stride=1, pad=1, is_bias=False,
        wf=gaussian_constant, in_place=False):

        if is_bias:
            learn_param = [dict(lr_mult=1, decay_mult=1), dict(lr_mult=2, decay_mult=0)]
        else:
            learn_param = [dict(lr_mult=1, decay_mult=1), dict(lr_mult=0, decay_mult=0)]
        conv = L.Convolution(bottom,
                             kernel_size=kernel_size,
                             stride=stride,
                             num_output=num_out,
                             pad=pad,
                             param=learn_param,
                             weight_filler=wf,
                             bias_filler=dict(type='constant', value=0),
                             in_place=in_place,
                             engine=1)
        return conv



    def add_block_1x1_3x3_1x1(self, bottom, num_output):
        layer1 = self.conv_prelu(bottom, num_output, kernel_size = 1, pad=0)
        layer2 = self.conv_prelu(layer1, num_output)
        layer3 = self.conv_prelu(layer2, num_output * 4, kernel_size = 1, pad=0)
        output = L.Eltwise(bottom, layer3, eltwise_param=dict(operation=1))
        return output

    def add_block_1x1_3x3_1x1_bn(self, bottom, num_output):
        model = self.conv(bottom, num_output, kernel_size = 1, pad=0)
        model = L.BatchNorm(model, use_global_stats=False, in_place=True)
        model = L.Scale(model, bias_term=True, in_place=True)
        model = L.PReLU(model, in_place=True)
        model = self.conv(model, num_output)
        model = L.BatchNorm(model, use_global_stats=False, in_place=True)
        model = L.Scale(model, bias_term=True, in_place=True)
        model = L.PReLU(model, in_place=True)
        model = self.conv(model, num_output * 4, kernel_size = 1, pad=0)
        model = L.BatchNorm(model, use_global_stats=False, in_place=True)
        model = L.Scale(model, bias_term=True, in_place=True)
        model = L.PReLU(model, in_place=True)
        output = L.Eltwise(bottom, model, eltwise_param=dict(operation=1))
        return output

    def add_block(self, bottom, num_output):
        layer1 = self.conv_prelu(bottom, num_output)
        layer2 = self.conv_prelu(layer1, num_output)
        output = L.Eltwise(bottom, layer2, eltwise_param=dict(operation=1))
        return output

    def add_block_se(self, bottom, num_output):
        layer1 = self.conv_prelu(bottom, num_output)
        layer2 = self.conv_prelu(layer1, num_output)
        pool = L.Pooling(layer2, pool=1, global_pooling=True)
        conv3 = self.conv(pool, num_output/16, kernel_size=1, stride=1, pad=0)
        pr3 = L.PReLU(conv3, in_place=True)
        conv4 = self.conv(pr3, num_output, kernel_size=1, stride=1, pad=0)
        prob = L.Sigmoid(conv4, in_place=True)
        output = L.Axpy(prob, layer2, bottom)
        return output
    
    def add_block_bn_c_bn(self, bottom, num_output):
        bn1 = L.BatchNorm(bottom, use_global_stats=False, in_place=False)
        bn1 = L.Scale(bn1, bias_term=True)
        conv1 = self.conv(bn1, num_output)
        bn2 = L.BatchNorm(conv1, use_global_stats=False, in_place=False)
        bn2 = L.Scale(bn2, bias_term=True)
        pr2 = L.PReLU(bn2, in_place=True)
        conv2 = self.conv(pr2, num_output)
        bn3 = L.BatchNorm(conv2, use_global_stats=False, in_place=False)
        bn3 = L.Scale(bn3, bias_term=True)
        output = L.Eltwise(bottom, bn3, eltwise_param=dict(operation=1))
        return output    

    def add_block_bn_c_bn_se(self, bottom, num_output):
        bn1 = L.BatchNorm(bottom, use_global_stats=False, in_place=False)
        bn1 = L.Scale(bn1, bias_term=True, in_place=True)
        conv1 = self.conv(bn1, num_output)
        bn2 = L.BatchNorm(conv1, use_global_stats=False, in_place=True)
        bn2 = L.Scale(bn2, bias_term=True, in_place=True)
        pr2 = L.PReLU(bn2, in_place=True)
        conv2 = self.conv(pr2, num_output)
        bn3 = L.BatchNorm(conv2, use_global_stats=False, in_place=True)
        bn3 = L.Scale(bn3, bias_term=True, in_place=True)
        
        pool = L.Pooling(bn3, pool=1, global_pooling=True)
        conv3 = self.conv(pool, num_output/16, kernel_size=1, stride=1, pad=0)
        pr3 = L.PReLU(conv3, in_place=True)
        conv4 = self.conv(pr3, num_output, kernel_size=1, stride=1, pad=0)
        prob = L.Sigmoid(conv4, in_place=True)
        output = L.Axpy(prob, bn3, bottom)
        return output  

    def add_block_3x3_3x3_3x3(self, bottom, num_output):
        layer1 = self.conv_prelu(bottom, num_output)
        layer2 = self.conv_prelu(layer1, num_output)
        layer3 = self.conv_prelu(layer2, num_output)
        output = L.Eltwise(bottom, layer3, eltwise_param=dict(operation=1))
        return output

    def add_block_pre_activation(self, bottom, num_output):
        model = L.BatchNorm(bottom, use_global_stats=False, in_place=False)
        model = L.Scale(model, bias_term=True)
        model = L.PReLU(model, in_place=True)
        model = self.conv(model, num_output, kernel_size = 1, pad=0, in_place=True)
        model = L.BatchNorm(model, use_global_stats=False, in_place=False)
        model = L.Scale(model, bias_term=True)
        model = L.PReLU(model, in_place=True)
        model = self.conv(model, num_output, kernel_size = 1, pad=0, in_place=True)
        model = L.Eltwise(bottom, model, eltwise_param=dict(operation=1))
        return model

    def add_block_3x3_3x3_3x3_bn(self, bottom, num_output):
        model = self.conv(bottom, num_output, wf = msra_constant)
        model = L.BatchNorm(model, use_global_stats=False, in_place=True)
        model = L.Scale(model, bias_term=True, in_place=True)
        model = L.ReLU(model, in_place=True)

        model = self.conv(model, num_output, wf = msra_constant)
        model = L.BatchNorm(model, use_global_stats=False, in_place=True)
        model = L.Scale(model, bias_term=True, in_place=True)
        model = L.ReLU(model, in_place=True)

        model = self.conv(model, num_output, wf = msra_constant)
        model = L.BatchNorm(model, use_global_stats=False, in_place=True)
        model = L.Scale(model, bias_term=True, in_place=True)
        model = L.ReLU(model, in_place=True)

        output = L.Eltwise(bottom, model, eltwise_param=dict(operation=1))
        return output


    def add_conv_bn_relu(self, bottom, num_output):
        model = self.conv(bottom, num_output, wf = msra_constant)
        model = L.BatchNorm(model, use_global_stats=False, in_place=True)
        model = L.Scale(model, bias_term=True, in_place=True)
        model = L.ReLU(model, in_place=True)

        return model

    def build_convolution(self, bottom, num_output, num_block):
        model = self.conv_prelu(bottom, num_output, 3, 2, 1, True,wf=xavier_constant)

        for i in range(num_block):
            model = self.add_conv_bn_relu(model, num_output)
        return model

    def make_net(self, data_file, block_nums,  batch_size=128, feature_dim=512, class_num=17501):
        assert len(block_nums) == 4, print('cause there four convolutions')
        data, label = L.ImageData(image_data_param=dict(source=data_file,
                                                   batch_size=batch_size,
                                                   shuffle=True,
						   root_folder='/home/wangaodi/train_data/'),

                             transform_param=dict(mean_value=[127.5, 127.5, 127.5],
                                                  scale=0.0078125,
                                                  mirror=True),
                             name='data',
                             ntop=2)#						   rand_number=15,

        conv1 = self.build_convolution(data, 64, block_nums[0])
        conv2 = self.build_convolution(conv1, 128, block_nums[1])
        conv3 = self.build_convolution(conv2, 256, block_nums[2])
        conv4 = self.build_convolution(conv3, 512, block_nums[3])

        fc5 = L.InnerProduct(conv4,
                             num_output=feature_dim,
                             bias_term=True,
                             param=[dict(lr_mult=1, decay_mult=1), dict(lr_mult=2, decay_mult=0)],
                             weight_filler=dict(type='xavier'),
                             bias_filler=dict(type='constant'),
                             name='fc5')

        fc6 = L.MarginInnerProduct(fc5,
                                   label,
                                   num_output=class_num,
                                   type=3,
                                   param=dict(lr_mult=1, decay_mult=1),
                                   weight_filler=dict(type='xavier'),
                                   base=1000,
                                   gamma=0.12,
                                   power=1,
                                   lambda_min=6,
                                   iteration=0,
                                   top='lambda')

        loss = L.SoftmaxWithLoss(fc6, label)
        return to_proto(loss)


def make_net():
    # make spherenet20
    model = Spherenet()

    # make spherenet36
    with open('sphereface_model.prototxt', 'w') as f:
        block_nums = [1, 2, 2, 6]
        print(str(model.make_net('/home/wangaodi/train_example/vgg+asia+se3k_redup.txt', block_nums, batch_size=100)), file=f)




if __name__ == '__main__':
    make_net()
