clear;
addpath(genpath('~/github/global_tool'));
load('brl_image.mat');
rank_n=50;

probe_txt='/home/brl/BRL/image/probe.txt';
gallery_txt='/home/brl/BRL/image/gallery.txt';
featureDim = 1024;

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

% %%% get wrong example
% distance=analysis.distance_matrix;
% [~,index]=sort(distance,2,'descend');
% rank_count=zeros(rank_n,1);
% gallery=analysis.gallery_info;
% probe=analysis.probe_info;
% for i_p=1:size(distance,1)
%     has_pinned=0;
%     if probe(i_p).label ~=gallery(index(i_p, 1)).label
%        subplot(1,3,1);
%        imshow(imread(probe(i_p).name));
%        title(probe(i_p).name(18:end));
%        subplot(1,3,2);
%        imshow(imread(gallery(index(i_p, 1)).name));
%        title([gallery(index(i_p, 1)).name(22:end) ':' num2str(distance(i_p, index(i_p, 1)))])
%        subplot(1,3,3);
%        score = img_feature_map(probe(i_p).name)' * img_feature_map(['aligned_gallery/gallery/' num2str(probe(i_p).label)  '.jpg']);
%        imshow(imread(['/home/brl/BRL/image/aligned_gallery/gallery/' num2str(probe(i_p).label) '.jpg']));
%        title(['ground truth score:' num2str(score)]);
%     end
% end
% rank_score=rank_count/size(distance,1);

%%% compute roc
[h, w] = size(distanceMatrix);
all_score = zeros(h * w, 1);
all_label = zeros(h * w, 1);
for i = 1:h
    i
    for j =  1:w
        index = (i-1)*w + j;
        all_score(index) = distanceMatrix(i, j);
        if probe(i).label == gallery(j).label
            all_label(index) = 1;
        else
            all_label(index) = 0;
        end
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
