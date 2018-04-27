clear;
clc;
% addpath(genpath('/home/scw4750/github/global_tool'));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%�������������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
caffe_path='/home/brl/github/caffe-ms/matlab';
rank_n=10;
% for lightencnn
%prototxt='/home/scw4750/github/2D/2D_models/lightenCNN/LightenedCNN_C_deploy.prototxt';
%caffemodel='/home/scw4750/github/2D/2D_models/lightenCNN/LightenedCNN_C.caffemodel';
prototxt='/media/brl/fzq/3DMM_CNN/testData/LightenedCNN_C_deploy.prototxt';
%%%����Э��
caffemodel='LightenedCNN_C__iter_108000.caffemodel';
%%%����ģ��
data_key='data';
%%%�����������
feature_key='eltwise_fc1';
%%%��ȡ���������
is_gray=true;
data_size=[128 128];
%%%������ݵĳߴ�
norm_type=0;  
% type=0 indicates that the data is just divided by 255
averageImg=[0 0 0];
%%%�Ƿ�Ҫ��ȥƽ��ֵ
preprocess_param.do_alignment=false;
preprocess_param.align_param.alignment_type='lightcnn';

% for vgg
% prototxt='G:\data_deal\VGG_FACE\vgg_face_caffe\vgg_face_caffe\VGG_FACE_deploy.prototxt';
% caffemodel='G:\data_deal\VGG_FACE\vgg_face_caffe\vgg_face_caffe\VGG_FACE.caffemodel';
% data_key='data';
% feature_key='fc7';
% is_gray=false;
% data_size=[224 224];
% norm_type=1;
% averageImg=[129.1863,104.7624,93.5940] ;   %%%RGB
% preprocess_param.do_alignment=false;


%for centerloss
% prototxt='I:\Dataset\Lock3DFace\sphereface_preprocess\prototxt\sphereface_deploy.prototxt';
% caffemodel='H:\face_train_test_iter_30000.caffemodel';
% data_key='data';
% feature_key='fc5';
% is_gray=false;
% data_size=[112 96];
% norm_type=2;
% averageImg=[0 0 0];
% preprocess_param.do_alignment=false;
% preprocess_param.align_param.alignment_type='centerloss';
% distance_type='cos';
% % 

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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%����gallery��probe%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% maindir='H:\final_test\VGG\';
% dirmain=dir('H:\final_test\VGG');
% %���·�����������е�gallery image folder��probe image folder
% lbdir='H:\final_test_labels\VGG\'
% dirlb=dir('H:\final_test_labels\VGG');
%%���·���洢��Ӧ��labels
% for h_1=3:length(dirmain)
%     probe_name=dirmain(h_1).name;
%     labels_name=dirlb(h_1).name;
probe_dir='/media/brl/fzq/3DMM_CNN/testData/curtinface/test1/low_depth_al/'
probe_txt='/media/brl/fzq/3DMM_CNN/testData/curtinface/test1/low_probe.txt'
%%%����gallery������ļ�
gallery_dir= '/media/brl/fzq/3DMM_CNN/testData/curtinface/test1/pic_al/';
gallery_txt='/media/brl/fzq/3DMM_CNN/testData/curtinface/test1/pic_gallery.txt';
% path= probe_name;
% path='E:\data_hzg\anaylisi_matrix';
analysis = get_analysis_matrix_from_net(gallery_dir,probe_dir,...
    gallery_txt,probe_txt,caffe_path,prototxt,caffemodel, ...
    net_param,preprocess_param,matrix_param);
%%%%���Ǹ��Զ��庯����εõ�һ��probe��gallery�ķ�������
% save('analysis');
rank_score=compute_cmc_by_analysis_matrix(analysis);

% fid=fopen('C:\Users\Administrator\Desktop\VGG_FACE_ID.txt','at');
% fprintf(fid,'%s,\n',probe_name);
% for h_2=1:10
%     fprintf(fid,'%f ',rank_score(h_2));
% end
% fprintf(fid,'\n');
% fprintf(fid,'%f,',rank_score(1));
% fprintf(fid,'%f',rank_score(2));
% fprintf(fid,'\n');
% fclose(fid);
% end




    

