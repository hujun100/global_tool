
%% ��ȡ������
clc;clear;close all
root_dir = '/home/scw4750/Dataset/iFace/';
addpath(genpath('~/github/global_tool'));
fprintf('Reading features...\n');
featsD = dlmread([root_dir 'distractor_features.txt']);
% fea_norm = norm(featsD);
% featsD = featsD/fea_norm;
for i = 1:size(featsD,1)
    fea = featsD(i,:);
    featsD(i,:) = fea/norm(fea);
end

featsP = dlmread([root_dir 'person_features.txt']);
for i = 1:size(featsP,1)
    fea = featsP(i,:);
    featsP(i,:) = fea/norm(fea);
end
% fea_norm = norm(featsP);
% featsP = featsP/fea_norm;

personID = dlmread([root_dir 'person_ID.txt']);
all_distractors = importdata([root_dir 'distractor_path.txt']);


fid = fopen([root_dir 'person_path.txt'], 'r');
C = textscan(fid, '%s', 'Delimiter', '\n');
C = C{1};
fclose(fid);
fprintf('Reading is ok.\n');

%% �������ƶ�
% ��ȡ�������
pos = int32(dlmread([root_dir 'pairs.txt']));
N = size(pos, 1);
sim = zeros(N, 5);
% ���������������֮������ƶ�
x = pos(:, 1);
y = pos(:, 2);
% parfor i=1:N

for i=1:N
    i
    if mod(i,500) == 0
         fprintf('Process %d from %d...\n', i, N);
    end
    f1 = featsP(x(i), :);
    f2 = featsP(y(i), :);
    % �����������֮������ƶ�
    v1 = getSimilarity_wolfit(f1, f2);

    v2 = getSimilarity_wolfit(featsD, f1);
    v3 = getSimilarity_wolfit(featsD, f2);
    % �ֱ���������������������֮���������ƶ�
    idx = (personID == personID(x(i))) | (personID == personID(y(i)));
    featsP_idx = featsP;
    featsP_idx(idx, :) = 0;
    [v4,v4_index] = getSimilarity_wolfit(featsP_idx, f1);
    [v5,v5_index] = getSimilarity_wolfit(featsP_idx, f2);

      
    img_v4 = imread([root_dir 'BRL_persons/' C{x(i)}]);
    distractor_v4 = imread([root_dir 'BRL_distractors/' all_distractors{v4_index}]);
    subplot(2,2,1)
    imshow(img_v4);
    subplot(2,2,2);
    imshow(distractor_v4);
    
    title(sprintf('%f %f %f',v1,v4,v5));
    
    img_v5 = imread([root_dir 'BRL_persons/' C{y(i)}]);
    distractor_v5 = imread([root_dir 'BRL_distractors/' all_distractors{v5_index}]);
    subplot(2,2,3)
    imshow(img_v5);
    subplot(2,2,4);
    imshow(distractor_v5);
    
     
    sim(i, :) = [v1 v2 v3 v4 v5];
end


function [sim,index] = getSimilarity_wolfit(feats, f)

[sim,index] = max(feats * f');
% sim = sim(1);

end
