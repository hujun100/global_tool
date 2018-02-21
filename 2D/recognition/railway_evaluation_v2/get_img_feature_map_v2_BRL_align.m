

clear;


gal_txt =  '/home/scw4750/Dataset/huochezhan/railway_evaluation/v2/gallery.txt';
pro_txt =  '/home/scw4750/Dataset/huochezhan/railway_evaluation/v2/probe.txt';
gal_dir = '/home/scw4750/Dataset/huochezhan/railway_evaluation/v2/BRL_align_gallery';
pro_dir = '/home/scw4750/Dataset/huochezhan/railway_evaluation/v2/BRL_align_probe';

gal_img_feature_map = get_img_feature_map_single(gal_dir, gal_txt);
pro_img_feature_map = get_img_feature_map_single(pro_dir, pro_txt);

function img_feature_map = get_img_feature_map_single(img_dir, ffp)


addpath(genpath('/home/scw4750/github/global_tool'));
addpath('~/github/caffe/matlab');
caffe_path='/home/scw4750/github/caffe/matlab';
rank_n=50;
% % for lightencnn
% prototxt='/home/scw4750/github/2D/2D_models/lightenCNN/LightenedCNN_C_deploy.prototxt';
% caffemodel='/home/scw4750/github/2D/2D_models/lightenCNN/LightenedCNN_C.caffemodel';
% data_key='image';
% feature_key='eltwise_fc1';
% is_gray=true;
% data_size=[128 128];
% is_transpose=true;
% norm_type=0;  %type=0 indicates that the data is just divided by 255
% averageImg=[0 0 0];
% preprocess_param.do_alignment=false;
% preprocess_param.align_param.alignment_type='lightcnn';

% %for face-caffe
% prototxt='/home/scw4750/github/2D/models/centerLoss/face_deploy.prototxt';
% caffemodel='/home/scw4750/github/2D/models/centerLoss/face_model.caffemodel';
% data_key='data';
% feature_key='fc5';
% is_gray=false;
% data_size=[112 96];
% is_transpose=true;
% norm_type=2;
% averageImg=[0 0 0];
% preprocess_param.do_alignment=true;
% preprocess_param.align_param.alignment_type='centerloss';
% distance_type='cos';


% %for vgg
% prototxt='/home/scw4750/github/2D/2D_models/vggFace/VGG_FACE_deploy.prototxt';
% caffemodel='/home/scw4750/github/2D/2D_models/vggFace/VGG_FACE.caffemodel';
% data_key='data';
% feature_key='fc7';
% is_gray=false;
% data_size=[224 224];
% norm_type=1;
% averageImg=[129.1863,104.7624,93.5940] ;  %%%RGB
% preprocess_param.do_alignment=false;
% distance_type='cos';

%for ResNet
prototxt='/home/scw4750/github/2D/2D_models/ResNet/ResNet-50-deploy.prototxt';
caffemodel='/home/scw4750/github/2D/2D_models/ResNet/ResNet__iter_240000.caffemodel';
data_key='data';
feature_key='pool5';
is_gray=false;
data_size=[224 224];
norm_type=1;
averageImg=[123, 117, 104]  ;               %%%RGB
preprocess_param.do_alignment=false;


net_param.data_size=data_size;
net_param.data_key=data_key;
net_param.feature_key=feature_key;
net_param.is_gray=is_gray;
net_param.norm_type=norm_type;
net_param.averageImg=averageImg;


preprocess_param.is_continue_without_landmarks=false;

net = caffe.Net(prototxt, caffemodel,'test');
caffe.set_mode_gpu();


all_imgs_file = importdata(ffp);
all_imgs_file = all_imgs_file.textdata;
img_feature_map = containers.Map();
for i = 1:length(all_imgs_file)
    i
    img_file = all_imgs_file{i};
    features = extract_feature_single(img_dir, img_file, data_size,data_key, ...
        feature_key,net,preprocess_param,is_gray,norm_type,averageImg);
    img_feature_map(img_file) = features;
end

end


