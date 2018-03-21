
clear;
addpath(genpath('~/github/global_tool'));
caffe_path='~/github/caffe-ms/matlab';
addpath(genpath(caffe_path));
rank_n=50;
%for ResNet
img_dir = '/home/brl/TRAIN/DataSet/CASIA-WebFace-118x102/';
all_imgs_ffp = '/home/brl/TRAIN/DataSet/webface_rm_dup.txt';


prototxt = '/home/brl/TRAIN/best_result/train_file_v82/sphereface_deploy.prototxt';
caffemodel = '/home/brl/TRAIN/best_result/v90/sphereface_model_iter_230000.caffemodel';
data_key='data';
feature_key='fc5';
% feature_key = 'InnerProduct1';
is_gray=false;

data_size=[112, 96];
norm_type=2;
averageImg=[127.5, 127.5, 127.5] ;   %%%RG7
preprocess_param.do_alignment=false;


net_param.data_size=data_size;
net_param.data_key=data_key;
net_param.feature_key=feature_key;
net_param.is_gray=is_gray;
net_param.norm_type=norm_type;
net_param.averageImg=averageImg;

matrix_param.distance_type='cos';

preprocess_param.is_continue_without_landmarks=false;

net = caffe.Net(prototxt, caffemodel,'test');
caffe.set_mode_gpu();

all_imgs_file = importdata(all_imgs_ffp);
if isfield(all_imgs_file,'textdata')
    all_labels = all_imgs_file.data;
    all_imgs_file = all_imgs_file.textdata;
end
% img_feature_map = all_imgs_file;
img_feature_map = containers.Map();
for i = 1:length(all_imgs_file)
    i
    img_file = all_imgs_file{i};
    features = extract_feature_single(img_dir, img_file, data_size,data_key, ...
        feature_key,net,preprocess_param,is_gray,norm_type,averageImg);
    features  = features/norm(features);
    img_feature_map([img_file ' ' num2str(all_labels(i))]) = features;
end






