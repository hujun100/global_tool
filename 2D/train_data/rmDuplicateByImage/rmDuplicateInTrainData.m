% clc;clear;
% load('cacd_img_feature_map.mat');
load('cacdvs_img_feature_map.mat');
threshold = 0.4;
fout = fopen('needDeleteList.txt','wt');
allImgPaths = img_features_map.keys();
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