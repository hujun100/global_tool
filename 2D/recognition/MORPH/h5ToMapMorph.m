clear;clc;
h5_file = '/home/brl/PycharmProjects/crossAgeFR/reproductAE-CNN/h5/morph.h5';
all_names = h5read(h5_file,'/name');
all_features = h5read(h5_file, '/feature');

% h5_file_v2 = '/home/brl/PycharmProjects/crossAgeFR/result/v2/cacd_features_only_eye_area.h5';
% all_names = h5read(h5_file_v2,'/name');
% all_features_v2 = h5read(h5_file_v2, '/feature');

img_feature_map = containers.Map();
for i = 1:9000
    i
    name = all_names{i};
    idx = strfind(name, '/');
    idx2 = strfind(name, '.');
    name = name(idx(end-1)+1:idx2+3);
    feature = all_features(:,i);
%     feature = (feature - mean(feature))/std(feature);
    feature = feature/norm(feature);
%     feature = [0.25*all_features(:,i)/norm(all_features(:,i));all_features_v2(:,i)/norm(all_features_v2(:,i))];
    img_feature_map(name) = feature;
end
