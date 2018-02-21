%  Copyright (c) 2015, Omkar M. Parkhi
%  All rights reserved.
caffe_path='/home/scw4750/github/caffe/matlab';
addpath(genpath(caffe_path));
img = imread('ak.png');
img = single(img);

averageImage = [129.1863,104.7624,93.5940] ;

img = cat(3,img(:,:,1)-averageImage(1),...
    img(:,:,2)-averageImage(2),...
    img(:,:,3)-averageImage(3));

img = img(:, :, [3, 2, 1]); % convert from RGB to BGR
img = permute(img, [2, 1, 3]); % permute width and height


model = 'VGG_FACE_deploy.prototxt';
weights = 'VGG_FACE.caffemodel';
caffe.set_mode_cpu();
net = caffe.Net(model, weights, 'test'); % create net and load weights

batch_size = 4;
data = zeros([size(img) batch_size]);
for i_d = 1:batch_size
   data(:,:,:,i_d) = img(:,:,:);
end

for i = 1:20
tic
res = net.forward({data});
toc
end
prob = res{1};

caffe_ft = net.blobs('fc7').get_data();
