%%% get feature
clear
% %for vgg
prototxt='/home/scw4750/github/2D/2D_models/vggFace/VGG_FACE_deploy.prototxt';
caffemodel='/home/scw4750/github/2D/2D_models/vggFace/VGG_FACE.caffemodel';
data_key='data';
feature_key='fc7';
is_gray=false;
data_size=[224 224];
norm_type=1;
averageImg=[129.1863,104.7624,93.5940] ;
preprocess_param.do_alignment=false;
distance_type='cos';

net_param.data_size=data_size;
net_param.data_key=data_key;
net_param.feature_key=feature_key;
net_param.is_gray=is_gray;
net_param.norm_type=norm_type;
net_param.averageImg=averageImg;

addpath(genpath('~/github/caffe/matlab'));
net=caffe.Net(prototxt, caffemodel,'test');


first_dataset = importdata('bbox_asia.list');
second_dataset = importdata('bbox_webface.list');

first_dataset_dir = 'bbox_align_asia';
first_dataset_img_feature_map = first_dataset;
for i_a = 1:length(first_dataset)
    i_a
    img_file = first_dataset{i_a};
    feature = extract_feature_single(first_dataset_dir, img_file, data_size,data_key, ...
        feature_key,net,preprocess_param,is_gray,norm_type,averageImg);
    first_dataset_img_feature_map{i_a,2} = feature;
end

second_dataset_dir = 'bbox_align_webface';
second_dataset_img_feature_map =second_dataset;
for i_w = 1:length(second_dataset)
    i_w
    img_file = second_dataset{i_w}; 
    feature = extract_feature_single(second_dataset_dir, img_file, data_size,data_key, ...
        feature_key,net,preprocess_param,is_gray,norm_type,averageImg);
    second_dataset_img_feature_map{i_w,2} = feature;
end





