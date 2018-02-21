addpath(genpath('~/github/global_tool'));
addpath('/home/scw4750/github/caffe/matlab');
caffe.reset_all();
close all;
prototxt = 'vgg/vgg_shortcut_deploy.prototxt';
caffemodel = '/media/scw4750/pipa_IDcard/vgg/v9/lvgg_iter_35000.caffemodel';
net = caffe.Net(prototxt,caffemodel,'test');

key='conv5_2';
shortcut_weights = net.layers(key).params(1).get_data();
shortcut_bias = net.layers(key).params(2).get_data();


% caffe.reset_all();
prototxt = 'vgg/vgg_face.prototxt';
caffemodel = '/media/scw4750/pipa_IDcard/vgg/v3/lvgg_iter_70000.caffemodel';
net = caffe.Net(prototxt,caffemodel,'test');

key='conv5_2';
weights = net.layers(key).params(1).get_data();
bias = net.layers(key).params(2).get_data();



% class_len = size(weights,2);
% y=zeros(class_len,1);
% for i = 1:class_len
%     y(i) = norm(weights(:,i)); 
% end
% x=1:class_len;
% plot(x,y)
% 
% railway = 16184:25961;
% 
% a = weights(:,20000);
% b = weights(:,10000);
% c=a-b;
% norm(b)
% norm(a)

