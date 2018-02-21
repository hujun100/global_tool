
clear;
addpath(genpath('/home/scw4750/github/global_tool'));

caffe_path='/home/scw4750/github/caffe/matlab';
rank_n=50;
% for lightencnn
prototxt='/home/scw4750/github/2D/models/lightenCNN/LightenedCNN_C_deploy.prototxt';
caffemodel='/home/scw4750/github/2D/models/lightenCNN/LightenedCNN_C.caffemodel';
data_key='image';
feature_key='eltwise_fc1';
is_gray=true;
data_size=[128 128];
is_transpose=true;
norm_type=0;  %type=0 indicates that the data is just divided by 255
averageImg=[0 0 0];
preprocess_param.do_alignment=true;
preprocess_param.align_param.alignment_type='lightcnn';


net_param.data_size=data_size;
net_param.data_key=data_key;
net_param.feature_key=feature_key;
net_param.is_gray=is_gray;
net_param.norm_type=norm_type;
net_param.averageImg=averageImg;

matrix_param.distance_type='cos';

preprocess_param.is_continue_without_landmarks=false;


probe_dir='/home/scw4750/ytf';
% probe_txt='gallery.txt';


gallery_dir='/home/scw4750/ytf';
% gallery_txt='probe.txt';

for i = 1:10
    i
    txt_name = ['split_10' filesep 'split_' num2str(i) '.txt'];
    [scores,labels]=compute_roc(gallery_dir,probe_dir,txt_name,caffe_path,prototxt,caffemodel,net_param,preprocess_param);
    [~,~,info] = vl_roc(scores, labels);
    accuracy = evaluation.accuracy.eval_best([],scores,labels);
    all_acc{i} = accuracy;
    all_info{i} = info;
end

