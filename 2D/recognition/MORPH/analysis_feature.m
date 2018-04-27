clear;clc;
h5_file = '/home/brl/PycharmProjects/crossAgeFR/reproductAE-CNN/h5/morph.h5';
all_names = h5read(h5_file,'/name');
all_feature = h5read(h5_file, '/feature');
weight_dir = '/home/brl/PycharmProjects/crossAgeFR/reproductAE-CNN/all_weight';
all_weight_h5 = dir([weight_dir '/*.h5']);
name_param_map = containers.Map();
for i_a = 1:length(all_weight_h5)
    name = all_weight_h5(i_a).name;
    param = h5read([weight_dir '/' name], '/param');
    name = name(1:end-3);
    name_param_map(name) = param;
end
% img_feature_map = containers.Map();
% temp = [];
% for i = 1:size(param, 1)
%    temp(i) =  norm(param(i,:));
%    if(temp(i)>0.5)
%        fprintf('haha'); 
%    end
% end
% plot(temp)
%% for normed weight and feature
weight = name_param_map('weight');
for i = 1:size(weight, 1)
    weight(i, :) = weight(i,:) / norm(weight(i,:)); 
end
for i = 6001:size(all_feature, 2)
    resnet_feature = all_feature(:,i); 
    norm_feature = resnet_feature / norm(resnet_feature);
    norm_weight = weight(1,:);

    logits = weight * norm_feature;
    logits_clip = logits;
    logits_clip(logits_clip<0.0001) = 0.0001;
    logits_clip(logits_clip>0.9999) = 0.9999;
    sum(-exp(logits_clip * 10) .* log(1-logits_clip)) / 9000
    %     softmax_logits = softmax(logits);
    max(logits)
end
%% with age
% for i = 6001:size(all_feature, 3)
%     i
%     resnet_feature = all_feature(:,1,i);
% %     age_feature_copy = name_param_map('features2age_kernel') * resnet_feature + name_param_map('features2age_bias');
%     age_feature = all_feature(:,2,i);
% %     age2identity_feature_copy = name_param_map('age2identity_kernel') * age_feature + name_param_map('age2identity_bias');
%     age2identity_feature = all_feature(:,3,i);
%     diff_feature = resnet_feature - age2identity_feature;
% %     age_invariant_feature_copy = name_param_map('age_invariant_features_kernel') * diff_feature + name_param_map('age_invariant_features_bias');
%     age_invariant_feature = all_feature(:,4,i);
% %     norm(age_invariant_feature);
%     identity_kernel = name_param_map('identity_kernel');
% %     age_invariant_feature(1:200) = 0;
%     first_row = identity_kernel(1, :);
%     logits = name_param_map('identity_kernel') * age_invariant_feature + name_param_map('identity_bias');
%     softmax_logits = softmax(logits);
%     max(softmax_logits)
%     name = all_names{i};
%     idx = strfind(name, '/');
%     idx2 = strfind(name, '.');
%     name = name(idx(end-1)+1:idx2+3);
%     feature = age_invariant_feature/norm(age_invariant_feature);
% %     feature = [0.25*all_features(:,i)/norm(all_features(:,i));all_features_v2(:,i)/norm(all_features_v2(:,i))];
%     img_feature_map(name) = feature;
% end

