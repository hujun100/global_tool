% clc;clear;
% load('cacdvs_img_feature_map.mat');
% testImgFeaturesMap = img_features_map;
% load('cleanedCacd_img_feature_map.mat');
threshold = 0.95;
fout = fopen('testImgInTrainData.txt','wt');
allImgPaths = img_features_map.keys();
allTestImgPaths = testImgFeaturesMap.keys();

allImgFeatures = cell2mat(img_features_map.values())';
testImgFeatures = cell2mat(testImgFeaturesMap.values());
scoreMatrix = allImgFeatures * testImgFeatures;
scoreMatrix = scoreMatrix > threshold;
for i = 1:length(allTestImgPaths)
    index = find(scoreMatrix(:,i));
    for i_i = 1:length(index)
        fprintf(fout, '%s %s\n',  allTestImgPaths{i}, allImgPaths{index(i_i)});
    end
end
fclose(fout);