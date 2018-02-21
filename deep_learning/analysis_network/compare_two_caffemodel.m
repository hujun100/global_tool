addpath(genpath('~/github/global_tool'));
addpath('/home/scw4750/github/caffe/matlab');

layer_name = 'fc205';

prototxt = 'prototxt/ResNet_lmdb.prototxt';
caffemodel = '/home/scw4750/github/2D/2D_models/ResNet/ResNet__iter_750000.caffemodel';
caffe.set_mode_gpu();
net = caffe.Net(prototxt, caffemodel, 'test');
param = net.layers(layer_name).params(1).get_data();
bias = net.layers(layer_name).params(2).get_data();


prototxt = 'prototxt/ResNet_lmdb.prototxt';
caffemodel = '/home/scw4750/github/2D/2D_models/ResNet/ResNet__iter_80000.caffemodel';
net2 = caffe.Net(prototxt, caffemodel, 'test');
param2 = net2.layers(layer_name).params(1).get_data();
bias2 = net2.layers(layer_name).params(2).get_data();

max(max(param))
min(min(param))
max(max(param2))
min(min(param2))

% 
% max(max(bias-bias2))
% min(min(bias-bias2))


caffe.reset_all();

% img_size = size(processed_img);
% data = zeros(img_size(1),img_size(2),1,1);
% data(:) = processed_img(:);
% net.blobs(data_key).set_data(data);
% net.forward_prefilled();
% acitivation = net.blobs(activation_key).get_data();

