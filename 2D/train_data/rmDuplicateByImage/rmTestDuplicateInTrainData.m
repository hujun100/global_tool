% clc;clear;
load('cacdvs_img_feature_map.mat');
testImgFeaturesMap = img_features_map;
load('cleanedCacd_img_feature_map.mat');
fout = fopen('testImgIdentity.txt','wt');
allImgPaths = img_features_map.keys();
allTestImgPaths = testImgFeaturesMap.keys();
newImgPaths = cell(length(allImgPaths), 1);
for i = 1:length(allImgPaths)
    path = allImgPaths{i};
    idx = strfind(path, '_');
    newImgPaths{i} = path(idx(1):idx(end));
end
uImgPaths = unique(newImgPaths);
uImgLen = length(uImgPaths);
for i_u = 1:uImgLen
    classIndexMap{i_u} = find(strcmp(newImgPaths, uImgPaths{i_u}));
end

% allImgFeatures = cell2mat(img_features_map.values())';
% testImgFeatures = cell2mat(testImgFeaturesMap.values());
% scoreMatrix = allImgFeatures * testImgFeatures;

classScore = zeros(uImgLen, 1);
classScoreMatrx = zeros(uImgLen, length(testImgFeatures));
for i_u = 1:uImgLen
    i_u
    allIndexPerClass = classIndexMap{i_u};
    allIndexLen = length(allIndexPerClass);
    classScoreMatrx(i_u,:) = mean(scoreMatrix(allIndexPerClass, :));
end
[~,index] = max(classScoreMatrx, [], 1);
for i_i = 1:length(index)
     fprintf(fout, '%s %s\n', allTestImgPaths{i_i}, uImgPaths{index(i_i)});
end
fclose(fout);