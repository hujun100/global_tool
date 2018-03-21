% clc;clear;
% load('cacd_img_feature_map.mat');
load('cacdvs_img_feature_map.mat');
threshold = 0.4;
fout = fopen('needDeleteList.txt','wt');
allImgPaths = img_features_map.keys();
all_class_labels = cell(length(allImgPaths), 1);
for i = 1:length(allImgPaths)
    path = allImgPaths{i};
    idx = strfind(path, '_');
    all_class_labels{i} = path(idx(1):idx(end));
end

%%% type 1 for computing classIndexMap
u_class_labels = unique(all_class_labels);
u_class_len = length(u_class_labels);
for i_u = 1:u_class_len
    classIndexMap{i_u} = find(strcmp(all_class_labels, u_class_labels{i_u}));
end
%%% type 2 for computing classIndexMap
% all_class_labels = sortrows(all_class_labels);
% last_label = '';
% count = 0;
% for i_u = 1:length(all_class_labels)
%     label = all_class_labels{i_u};
%     if strcmp(last_label, label) ==0
%          count = count + 1;
%          classIndexMap{count}= [];
%     end
%     classIndexMap{count} = [classIndexMap{count} i_u];
% end

for i_u = 1:uImgLen
    i_u
    allIndexPerClass = classIndexMap{i_u};
    allIndexLen = length(allIndexPerClass);
    for i_a = 1:allIndexLen
        testIndex = allIndexPerClass(i_a);
        testIndexFeatures = img_features_map(allImgPaths{testIndex});
        for i_b = 1:allIndexLen
            tempFeatures = img_features_map(allImgPaths{allIndexPerClass(i_b)});
            score(i_b) = testIndexFeatures' * tempFeatures;
        end
        if mean(score) < threshold
             fprintf(fout, '%s\n', allImgPaths{testIndex});
        end
    end
end
fclose(fout);