
clear;
addpath(genpath('/home/scw4750/github/global_tool'));

caffe_path='/home/scw4750/github/caffe/matlab';
rank_n=50;

% % for lightencnn
% prototxt='/home/scw4750/github/2D/2D_models/lightenCNN/LightenedCNN_C_deploy.prototxt';
% caffemodel='/home/scw4750/github/2D/2D_models/lightenCNN/LightenedCNN_C.caffemodel';
% data_key='image';
% feature_key='eltwise_fc1';
% is_gray=true;
% data_size=[128 128];
% norm_type=0;  %type=0 indicates that the data is just divided by 255
% averageImg=[0 0 0];
% preprocess_param.do_alignment=true;
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

% %for ResNet
% prototxt='/home/scw4750/github/2D/2D_models/ResNet/ResNet-50-deploy.prototxt';
% caffemodel='/media/scw4750/pipa_IDcard/hujun/BRL/ResNet__iter_240000.caffemodel';
% data_key='data';
% feature_key='pool5';
% is_gray=false;
% data_size=[224 224];
% is_transpose=true;
% norm_type=1;
% averageImg=[123, 117, 104]  ;
% preprocess_param.do_alignment=true;
% preprocess_param.align_param.alignment_type='lightcnn';
% distance_type='cos';

 %for vgg
prototxt='/home/scw4750/github/2D/2D_models/vggFace/VGG_FACE_deploy.prototxt';
caffemodel='/home/scw4750/github/2D/2D_models/vggFace/best_result/lvgg_iter_75000.caffemodel';
data_key='data';
feature_key='fc7';
is_gray=false;
data_size=[224 224];
norm_type=1;
averageImg=[129.1863,104.7624,93.5940] ;   %%%RGB
preprocess_param.do_alignment=true;
preprocess_param.align_param.alignment_type='bbox';

net_param.data_size=data_size;
net_param.data_key=data_key;
net_param.feature_key=feature_key;
net_param.is_gray=is_gray;
net_param.norm_type=norm_type;
net_param.averageImg=averageImg;

matrix_param.distance_type='cos';

preprocess_param.is_continue_without_landmarks=false;


probe_dir='/media/scw4750/tb4/data/lfw_data/lfw_mtcnn';
% probe_txt='gallery.txt';


gallery_dir='/media/scw4750/tb4/data/lfw_data/lfw_mtcnn';
% gallery_txt='probe.txt';

for i = 1:10
    i
    txt_name = ['verification_split_10' filesep 'lfw_pos_neg_split_' num2str(i) '.txt'];
    [scores,labels]=compute_roc(gallery_dir,probe_dir,txt_name,caffe_path,prototxt,caffemodel,net_param,preprocess_param);
    [~,~,info] = vl_roc(scores, labels);
    accuracy = evaluation.accuracy.eval_best([],scores,labels);
    all_acc{i} = accuracy;
    all_info{i} = info;
end

