clear;
addpath(genpath('/home/scw4750/github/global_tool'));

caffe_path='/home/scw4750/github/caffe/matlab';
rank_n=50;
% for lightencnn
% prototxt='/home/scw4750/github/2D/2D_models/lightenCNN/LightenedCNN_C_deploy.prototxt';
% caffemodel='/home/scw4750/github/2D/2D_models/lightenCNN/LightenedCNN_C.caffemodel';
prototxt='/home/scw4750/BRL/LJ/lightcnn/LightenedCNN_C_deploy.prototxt';
caffemodel='/home/scw4750/BRL/LJ/snapshot/v2/sphereface_model_iter_10000.caffemodel';
data_key='image';
feature_key='eltwise_fc1';
is_gray=true;
data_size=[128 128];
norm_type=0;  % type=0 indicates that the data is just divided by 255
averageImg=[0 0 0];
preprocess_param.do_alignment=false;
preprocess_param.align_param.alignment_type='lightcnn';

% %for vgg
% prototxt='/home/scw4750/github/2D/2D_models/vggFace/VGG_FACE_deploy.prototxt';
% caffemodel='/home/scw4750/github/2D/2D_models/vggFace/VGG_FACE.caffemodel';
% data_key='data';
% feature_key='fc7';
% is_gray=false;
% data_size=[224 224];
% norm_type=1;
% averageImg=[129.1863,104.7624,93.5940] ;   %%%RGB
% preprocess_param.do_alignment=false;


% %for centerloss
% prototxt='/home/scw4750/github/2D/2D_models/centerLoss/face_deploy.prototxt';
% caffemodel='/home/scw4750/github/2D/2D_models/centerLoss/face_model.caffemodel';
% data_key='data';
% feature_key='fc5';
% is_gray=false;
% data_size=[112 96];
% norm_type=2;
% averageImg=[0 0 0];
% preprocess_param.do_alignment=false;
% preprocess_param.align_param.alignment_type='centerloss';
% distance_type='cos';


% %for ResNet
%prototxt='/home/scw4750/github/2D/2D_models/ResNet/ResNet-50-deploy.prototxt';
%caffemodel='/home/scw4750/github/2D/2D_models/ResNet/ResNet-50-model.caffemodel';
% data_key='data';
% feature_key='pool5';
% is_gray=false;
% data_size=[224 224];
% norm_type=1;
% averageImg=[123, 104, 127] ;    %%%RGB
% preprocess_param.do_alignment=true;
% preprocess_param.align_param.alignment_type='lightcnn';
% distance_type='cos';


net_param.data_size=data_size;
net_param.data_key=data_key;
net_param.feature_key=feature_key;
net_param.is_gray=is_gray;
net_param.norm_type=norm_type;
net_param.averageImg=averageImg;

matrix_param.distance_type='cos';

preprocess_param.is_continue_without_landmarks=false;


probe_dir='';
probe_txt='/home/scw4750/BRL/LJ/lightcnn/lightcnn3_probe.txt';


gallery_dir= '';
gallery_txt='/home/scw4750/BRL/LJ/lightcnn/lightcnn3_gallery.txt';

analysis = get_analysis_matrix_from_net(gallery_dir,probe_dir,...
    gallery_txt,probe_txt,caffe_path,prototxt,caffemodel, ...
    net_param,preprocess_param,matrix_param);


