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

%for vgg
prototxt='/raid/hujun/retrain_vgg/vgg_face_lmdb.prototxt';
caffemodel='/raid/hujun/retrain_vgg/snapshot/v23/lvgg_iter_195000.caffemodel';
data_key='data';
feature_key='fc7';
is_gray=false;
data_size=[224 224];
norm_type=1;
averageImg=[129.1863,104.7624,93.5940] ;   %%%RGB
preprocess_param.do_alignment=false;



net_param.data_size=data_size;
net_param.data_key=data_key;
net_param.feature_key=feature_key;
net_param.is_gray=is_gray;
net_param.norm_type=norm_type;
net_param.averageImg=averageImg;

matrix_param.distance_type='cos';

preprocess_param.is_continue_without_landmarks=false;


probe_dir='/raid/hujun/train_data';
probe_txt='asia_3_person_per_class.txt';


gallery_dir= probe_dir;
gallery_txt='web_3_person_per_class.txt';
tic
analysis = get_analysis_matrix_from_net(gallery_dir,probe_dir,...
    gallery_txt,probe_txt,caffe_path,prototxt,caffemodel, ...
    net_param,preprocess_param,matrix_param);
toc

asia = importdata(probe_txt);
asia = asia.textdata;
web = importdata(gallery_txt);
web = web.textdata;

fid = fopen('bigger.txt','wt');
for i_p = 1:size(bigger,1)
    for i_g = 1:size(bigger,2)
        if bigger(i_p, i_g) == 1
            fprintf(fid, '%s %s\n', asia{i_p}, web{i_g});
        end
    end
end
fclose(fid);