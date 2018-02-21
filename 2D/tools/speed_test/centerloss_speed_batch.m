clear;clc;
addpath('/home/scw4750/github/caffe/matlab');
caffe.reset_all();

% load face model and creat network
caffe.set_device(0);
caffe.set_mode_gpu();
model = 'face_deploy.prototxt';
weights = 'face_model.caffemodel';
net = caffe.Net(model, weights, 'test');

% load face image, and align to 112 X 96
imgSize = [112, 96];
coord5points = [30.2946, 65.5318, 48.0252, 33.5493, 62.7299; ...
                51.6963, 51.5014, 71.7366, 92.3655, 92.2041];

image = imread('001_01_01_110_04.png');
% facial5points = [105.8306, 147.9323, 121.3533, 106.1169, 144.3622; ...
%                  109.8005, 112.5533, 139.1172, 155.6359, 156.3451];
fid=fopen('001_01_01_110_04.5pt');
data=textscan(fid,'%f %f');
facial5points(1,1:5)=data{1};
facial5points(2,1:5)=data{2};
fclose(fid);

Tfm =  cp2tform(facial5points', coord5points', 'similarity');
cropImg = imtransform(image, Tfm, 'XData', [1 imgSize(2)],...
                                  'YData', [1 imgSize(1)], 'Size', imgSize);
% image = imread('data/Jennifer_Aniston_0016.jpg');
% cropImg =imresize(image,imgSize);

% transform image, obtaining the original face and the horizontally flipped one
if size(cropImg, 3) < 3
   cropImg(:,:,2) = cropImg(:,:,1);
   cropImg(:,:,3) = cropImg(:,:,1);
end
cropImg = single(cropImg);
cropImg = (cropImg - 127.5)/128;
cropImg = permute(cropImg, [2,1,3]);
cropImg = cropImg(:,:,[3,2,1]);

cropImg_(:,:,1) = flipud(cropImg(:,:,1));
cropImg_(:,:,2) = flipud(cropImg(:,:,2));
cropImg_(:,:,3) = flipud(cropImg(:,:,3));

batch_size =3;
data = zeros([size(cropImg) batch_size]);
for i = 1:batch_size
   data(:,:,:,i) = cropImg(:,:,:); 
end

data_ = zeros([size(cropImg) batch_size]);
for i = 1:batch_size
   data_(:,:,:,i) = cropImg_(:,:,:); 
end

% extract deep feature
for i_f = 1: 20
tic
res = net.forward({data});
res_ = net.forward({data_});
toc
end
deepfeature = [res{1}; res_{1}];

caffe.reset_all();
