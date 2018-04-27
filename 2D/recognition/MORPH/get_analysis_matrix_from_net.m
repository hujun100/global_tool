function analysis=get_analysis_matrix_from_net(gallery_dir,probe_dir,gallery_txt,probe_txt,caffe_path,prototxt,caffemodel,net_param,preprocess_param,matrix_param)
%compute the rank 1-n for cnn
%
%inputs:
%  gallery(probe)_dir --the direcory contains imgs
%  gallery(probe)_txt --the txt contains lines such as *.png *.jpg and its labels.
%           Notices:gallery(probe)_dir+(lines in gallery(probe)_txt) should be the
%           full path of all images
%  caffe_path               -- the matlab path in compilated caffe
%  prototxt and caffemodel  -- for special network
%
%  net_param and preprocess_param     --see net_param_preprocess_param_doc.txt in root directory. 
%
%  matrix_param.distance_type            -- candidate is 'cos'(cosine similarity)
%                           'L2'(l2 distance)
%output:
%     analysis.distance_matrix --x-axes:gallery y-axes:probe
%                (x,y)=similarity of gallery(x) and probe(y)
%     analysis.sort_matrix     --
%     analysis.gallery_info    --
%     analysis.gallery_info    --
%Jun Hu
%2017-4

addpath(genpath(caffe_path));
caffe.set_mode_gpu();
net=caffe.Net(prototxt,caffemodel,'test');
%%%加载网络


%read list
gallery=get_name_label_by_txt(gallery_txt);
probe=get_name_label_by_txt(probe_txt);
%%%读取gallery和probe的标签文件

%info for extract_feature
data_size=net_param.data_size;
data_key=net_param.data_key;
feature_key=net_param.feature_key;
is_gray=net_param.is_gray;
norm_type=net_param.norm_type;
averageImg=net_param.averageImg;


%extract feature
for i_g=1:length(gallery)
%     gallery(i_g).name=gallery(i_g).name(47:end);
%     gallery(i_g).name=strrep(gallery(i_g).name,'depth','color');
    fprintf('extract feature i_g:%d\n',i_g);
    feature=extract_feature_single(gallery_dir,gallery(i_g).name,data_size,data_key,feature_key,net,preprocess_param,is_gray,norm_type,averageImg);
    %%%提取每一张图片的特征
    gallery(i_g).fea=feature;
    %gallery(i_g).img=imread([gallery_dir filesep gallery(i_g).name]);
end
%%%提取了gallery中所有图片的特征
for i_p=1:length(probe)
%    probe(i_p).name=probe(i_p).name(47:end);
%     probe(i_p).name=strrep(probe(i_p).name,'depth','color');
%      probe(i_p).name=strrep(probe(i_p).name,'DEPTH','COLOR');
    fprintf('extract feature i_p:%d\n',i_p);
     feature=extract_feature_single(probe_dir,probe(i_p).name,data_size,data_key,feature_key,net,preprocess_param,is_gray,norm_type,averageImg);
    probe(i_p).fea=feature;
    %probe(i_p).img=imread([probe_dir filesep probe(i_p).name]);
end
%%%提取了probe中所有的特征
%compute rank
analysis=get_analysis_matrix(gallery,probe,matrix_param);
%fprintf('rank1: %f\n',rankn(1));
caffe.reset_all();
end

function result=get_name_label_by_txt(txt)
fid=fopen(txt,'rt');
list=textscan(fid,'%s %f');
fclose(fid);
for i_g=1:length(list{1})
    result(i_g).name=list{1,1}{i_g};
    result(i_g).label=list{1,2}(i_g);
end
end
