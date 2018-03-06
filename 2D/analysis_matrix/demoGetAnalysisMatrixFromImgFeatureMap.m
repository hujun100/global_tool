clear;
addpath(genpath('~/github/global_tool'));

rank_n=50;

probe_txt='/home/brl/TRAIN/DataSet/morph2_complete/testProbe.txt';
gallery_txt='/home/brl/TRAIN/DataSet/morph2_complete/testGallery.txt';
featureDim = 512;

gallery = get_name_label_by_txt(gallery_txt);
probe = get_name_label_by_txt(probe_txt);
galLen = length(gallery);
proLen = length(probe);

allGalFeatures = zeros(featureDim, galLen);
allProFeatures = zeros(proLen, featureDim);

for i = 1:galLen
    allGalFeatures(:,i) = img_features_map(gallery(i).name); 
end
for i = 1:proLen
    allProFeatures(i,:) = img_features_map(probe(i).name); 
end
distanceMatrix = allProFeatures * allGalFeatures;
analysis.distance_matrix = distanceMatrix;
analysis.gallery_info = gallery;
analysis.probe_info = probe;

rankParam.rank_n = 50;
rankScore = compute_cmc_by_analysis_matrix(analysis, rankParam)


function result=get_name_label_by_txt(txt)
fid=fopen(txt,'rt');
list=textscan(fid,'%s %f');
fclose(fid);
for i_g=1:length(list{1})
    result(i_g).name=list{1,1}{i_g};
    result(i_g).label=list{1,2}(i_g);
end
end