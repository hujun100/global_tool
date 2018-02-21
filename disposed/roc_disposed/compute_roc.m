function [scores,labels]=draw_roc(gal_dir,pro_dir, ...
   pair_txt,caffe_path,prototxt,caffemodel,net_param,preprocess_param)
%draw roc curve for cnn
%
%inputs:
%  gal_dir                   --the direcory contains global images
%  pro_dir                  --the direcory contains probe images
%  pair_txt                        --the txt contains lines as the relative path of galgin image,pro image and 1.
%           Notices:pos(neg)_gal_dir+(lines in pos(neg)_txt) should be the
%           full path of all images
%  caffe_path                         -- the matlab path in compilated caffe
%  prototxt and caffemodel            -- for special network
%  net                                -- for special network
%  net_param and preprocess_param     --see net_param_preprocess_param_doc.txt in root directory.
%
%output:
%      			              --the postive and negative pro with its feature and
%      			    score
%
%Jun Hu
%2017-4
addpath(genpath(caffe_path));
caffe.set_mode_gpu();
net=caffe.Net(prototxt,caffemodel,'test');

data=importdata(pair_txt);
% labels=extractfield(
labels=data.data(:)';
gal_name=data.textdata(:,1);
pro_name=data.textdata(:,2);

data_size=net_param.data_size;
data_key=net_param.data_key;
feature_key=net_param.feature_key;
is_gray=net_param.is_gray;
norm_type=net_param.norm_type;
averageImg=net_param.averageImg;
% we might accelerate the runtime of following codes, because the feature may be computed n times.
pair_count=1;
for i=1:length(gal_name)
    i
    gal_fea=extract_feature_single(gal_dir,gal_name{i},data_size,data_key,feature_key,net,preprocess_param,is_gray,norm_type,averageImg);
    gal_fea = squeeze(gal_fea);
    pro_fea=extract_feature_single(pro_dir,pro_name{i},data_size,data_key,feature_key,net,preprocess_param,is_gray,norm_type,averageImg);
    pro_fea = squeeze(pro_fea);

    scores(pair_count)=compute_cosine_score(gal_fea,pro_fea);
    pair_count=pair_count+1;
end

%ROC(scores,labels,10,0);
caffe.reset_all();
end
