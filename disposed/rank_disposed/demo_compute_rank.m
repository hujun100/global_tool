clear;
addpath(genpath('/home/scw4750/github/global_tool'));

caffe_path='/home/scw4750/github/caffe/matlab';
rank_n=50;
% for lightencnn
prototxt='/home/scw4750/github/IJCB2017/lightencnn_deploy.prototxt';
caffemodel='/home/scw4750/github/IJCB2017/final_LightenedCNN_C.caffemodel';
data_key='image';
feature_key='eltwise_fc1';
is_gray=true;
data_size=[128 128];
is_transpose=true;
norm_type=0;  %type=0 indicates that the data is just divided by 255
averageImg=[0 0 0];
preprocess_param.do_alignment=true;
preprocess_param.align_param.alignment_type='lightcnn';
distance_type='cos';

% %for vgg
% prototxt='/home/scw4750/github/vgg_face_caffe/VGG_FACE_deploy.prototxt';
% caffemodel='/home/scw4750/github/vgg_face_caffe/VGG_FACE.caffemodel';
% data_key='data';
% feature_key='fc7';
% is_gray=false;
% data_size=[224 224];
% is_transpose=true;
% norm_type=1;
% averageImg=[129.1863,104.7624,93.5940] ;
% preprocess_param.do_alignment=true;
% preprocess_param.align_param.alignment_type='bbox';
% distance_type='cos';

% %for face-caffe
% prototxt='/home/scw4750/github/eccv_deep_face/face_example/face_deploy.prototxt';
% caffemodel='/home/scw4750/github/eccv_deep_face/face_example/face_model.caffemodel';
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

net_param.data_size=data_size;
net_param.data_key=data_key;
net_param.feature_key=feature_key;
net_param.is_gray=is_gray;
net_param.norm_type=norm_type;
net_param.averageImg=averageImg;
%preprocess_param
% preprocess_param.is_square=true;

rank_param.distance_type='cos';
rank_param.rank_n=rank_n;

probe_dir='/home/scw4750/github/IJCB2017/liangjie/alignment/multipie/global_probe';
probe_txt='/home/scw4750/github/IJCB2017/liangjie/txt/probe_list.txt';


gallery_root_dir='/home/scw4750/github/IJCB2017/liangjie/alignment/multipie';
gallery_dir_name={'enlarge_mulitpie' 'enlarge_multipie_han'};
gallery_txt='/home/scw4750/github/IJCB2017/liangjie/txt/gallery_list.txt';
cmc_count=1;
for i=1:length(gallery_dir_name)
    [result_rankn,analysis] = compute_rank([gallery_root_dir filesep gallery_dir_name{i} '/gallery/'],probe_dir,...
        gallery_txt,probe_txt,caffe_path,prototxt,caffemodel, ...
    net_param,preprocess_param,rank_param);
cmc(cmc_count).name=[gallery_root_dir filesep gallery_dir_name{i} '/gallery/'];
cmc(cmc_count).rankn=result_rankn;
cmc(cmc_count).analysis=analysis;
cmc_count=cmc_count+1;
end

% for baseline with two images
baseline_gallery_txt='/home/scw4750/github/IJCB2017/liangjie/txt/baseline_gallery_list.txt';
gallery_dir='/home/scw4750/github/IJCB2017/liangjie/alignment/multipie/baseline_mulitpie/gallery';
[result_rankn,analysis] = compute_rank(gallery_dir,probe_dir,baseline_gallery_txt,probe_txt,caffe_path,prototxt,caffemodel, ...
    net_param,preprocess_param,rank_param);
cmc(cmc_count).name=gallery_dir;
cmc(cmc_count).rankn=result_rankn;
cmc(cmc_count).analysis=analysis;
cmc_count=cmc_count+1;

%for baseline with one image
baseline_gallery_txt='/home/scw4750/github/IJCB2017/liangjie/alignment/multipie/baseline_mulitpie_only_one/list.txt';
gallery_dir='/home/scw4750/github/IJCB2017/liangjie/alignment/multipie/baseline_mulitpie_only_one/gallery';
[result_rankn,analysis] = compute_rank(gallery_dir,probe_dir,baseline_gallery_txt,probe_txt,caffe_path,prototxt,caffemodel, ...
    net_param,preprocess_param,rank_param);
cmc(cmc_count).name=gallery_dir;
cmc(cmc_count).rankn=result_rankn;
cmc(cmc_count).analysis=analysis;
cmc_count=cmc_count+1;
