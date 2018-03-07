% clear;
% img_feature_map = img_features_map;
addpath(genpath('~/github/global_tool'));
dataDir = '/home/brl/TRAIN/DataSet/morph2_complete/alignedTestList';
rank_n=50;

probe_txt='/home/brl/TRAIN/DataSet/morph2_complete/testProbe.txt';
gallery_txt='/home/brl/TRAIN/DataSet/morph2_complete/testGallery.txt';
value = img_feature_map.values;
featureDim = length(value{1});

gallery = get_name_label_by_txt(gallery_txt);
probe = get_name_label_by_txt(probe_txt);
galLen = length(gallery);
proLen = length(probe);

allGalFeatures = zeros(featureDim, galLen);
allProFeatures = zeros(proLen, featureDim);

for i = 1:galLen
    allGalFeatures(:,i) = img_feature_map(gallery(i).name); 
end
for i = 1:proLen
    allProFeatures(i,:) = img_feature_map(probe(i).name); 
end
distanceMatrix = allProFeatures * allGalFeatures;
analysis.distance_matrix = distanceMatrix;
analysis.gallery_info = gallery;
analysis.probe_info = probe;

rankParam.rank_n = 50;
rankScore = compute_cmc_by_analysis_matrix(analysis, rankParam)

distance = distanceMatrix;
[~,index]=sort(distance,2,'descend');
for i_p=1:size(distance,1)
    has_pinned=0;
    
    if probe(i_p).label==gallery(index(i_p,1)).label
        continue;
    else
        fprintf('%s %s score:%f gt-score:%f\n',  probe(i_p).name, gallery(index(i_p,1)).name,...
            distanceMatrix(i_p, index(i_p,1)), distanceMatrix(i_p, i_p));
        subplot(2,2,1);
        img = imread(fullfile(dataDir, probe(i_p).name));
        imshow(img);
        subplot(2,2,2);
        img = imread(fullfile(dataDir, gallery(index(i_p,1)).name));
        imshow(img);
        subplot(2,2,3);
        img = imread(fullfile(dataDir, gallery(i_p).name));
        imshow(img);
        subplot(2,2,4);
        img = imread(fullfile(dataDir, probe(index(i_p,1)).name));
        imshow(img);
    end
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
