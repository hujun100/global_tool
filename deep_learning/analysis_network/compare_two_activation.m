addpath(genpath('~/github/global_tool'));
addpath('/home/scw4750/github/caffe/matlab');
clear;
processed_img = imread('/home/scw4750/github/deep-visualization-toolbox/input_images/img_8579.jpg');
processed_img = imresize(processed_img, [224,224]);
if length(size(processed_img)) == 2
    processed_img(:,:,2) = processed_img(:,:,1);
    processed_img(:,:,3) = processed_img(:,:,1);
else
    RGB = [129.1863 104.7624 93.5940];
    processed_img=single(processed_img);
    processed_img(:,:,1) = processed_img(:,:,1) - RGB(1);
    processed_img(:,:,2) = processed_img(:,:,2) - RGB(2);
    processed_img(:,:,3) = processed_img(:,:,3) - RGB(3);
end
processed_img = processed_img(:,:,[2 3 1]);
% processed_img = single(processed_img)/255;

data_key='data';
activation_key = 'res5c';

prototxt = 'prototxt/ResNet_lmdb.prototxt';
caffemodel = '/home/scw4750/github/2D/2D_models/ResNet/ResNet__iter_750000.caffemodel';

left = get_activation(processed_img ,prototxt, caffemodel, data_key, activation_key);
left=squeeze(left);
left = left(:);
% f = activation(:,:,2);
% f = f-min(min(f));
% f = f/max(max(f));
% imshow(f)

processed_img = processed_img*0.017;
prototxt = 'prototxt/ResNet_lmdb.prototxt';
caffemodel = '/home/scw4750/github/2D/2D_models/ResNet/ResNet__iter_80000.caffemodel';
right = get_activation(processed_img ,prototxt, caffemodel, data_key, activation_key);
right = squeeze(right);
right = right(:);
max(max(left))
max(max(abs(left-right)))
caffe.reset_all();