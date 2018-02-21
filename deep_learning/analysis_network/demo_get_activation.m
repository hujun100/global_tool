addpath(genpath('~/github/global_tool'));
addpath('/home/scw4750/github/caffe/matlab');
caffe.set_mode_gpu();
processed_img = imread('/home/scw4750/github/non_important/deep-visualization-toolbox/input_images/F0001_C1_0076.jpg');
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
activation_key = 'pool5';

prototxt='/home/scw4750/github/global_tool/deep_learning/analysis_network/prototxt/ResNet-50-deploy.prototxt';
caffemodel='/home/scw4750/github/2D/2D_models/ResNet/res_v7/ResNet__iter_750000.caffemodel';

activation = get_activation(processed_img ,prototxt, caffemodel, data_key, activation_key);

% f = activation(:,:,2);
% f = f-min(min(f));
% f = f/max(max(f));
% imshow(f)
