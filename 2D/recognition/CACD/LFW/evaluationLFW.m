% --------------------------------------------------------
% Copyright (c) Weiyang Liu, Yandong Wen
% Licensed under The MIT License [see LICENSE for details]
%
% Intro:
% This script is used to evaluate the performance of the trained model on LFW dataset.
% We perform 10-fold cross validation, using cosine similarity as metric.
% More details about the testing protocol can be found at http://vis-www.cs.umass.edu/lfw/#views.
% 
% Usage:
% cd $SPHEREFACE_ROOT/test
% run code/evaluation.m
% --------------------------------------------------------
% 
clear;clc;close all;
test_data_dir = '/home/brl/PycharmProjects/crossAgeFR/lfw_evaluation/alignedLFW';

h5_file = '/home/brl/PycharmProjects/crossAgeFR/lfw.h5';
all_names = h5read(h5_file,'/name');
all_features = h5read(h5_file,'/feature');
for i = 1:length(all_names)
    name = all_names{i};
    idx = strfind(name,'jpg');
    all_names{i} = name(1:idx(1)+2); 
end
%% compute features

pairs = parseList('pairs.txt', test_data_dir);
for i = 1:length(pairs)
    fprintf('extracting deep features from the %dth face pair...\n', i);
    idx = find(strcmp(all_names, pairs(i).fileL));
    pairs(i).featureL = all_features(:,idx);
    idx = find(strcmp(all_names, pairs(i).fileR));
    pairs(i).featureR = all_features(:,idx);
end
%%save result/pairs.mat pairs

%% 10-fold evaluation
pairs = struct2cell(pairs')';
ACCs  = zeros(10, 1);
fprintf('\n\n\nfold\tACC\n');
fprintf('----------------\n');
for i = 1:10
    fold      = cell2mat(pairs(:, 3));
    flags     = cell2mat(pairs(:, 4));
    featureLs = cell2mat(pairs(:, 5)');
    featureRs = cell2mat(pairs(:, 6)');

    % split 10 folds into val & test set
    valFold   = find(fold~=i);
    testFold  = find(fold==i);

    % get normalized feature
    mu        = mean([featureLs(:, valFold), featureRs(:, valFold)], 2);
    featureLs = bsxfun(@minus, featureLs, mu);
    featureRs = bsxfun(@minus, featureRs, mu);
    featureLs = bsxfun(@rdivide, featureLs, sqrt(sum(featureLs.^2)));
    featureRs = bsxfun(@rdivide, featureRs, sqrt(sum(featureRs.^2)));

    % get accuracy of the ith fold using cosine similarity
    scores    = sum(featureLs .* featureRs);
    threshold = getThreshold(scores(valFold), flags(valFold), 10000);
    ACCs(i)   = getAccuracy(scores(testFold), flags(testFold), threshold);
    fprintf('%d\t%2.2f%%\n', i, ACCs(i)*100);
end
fprintf('----------------\n');
fprintf('AVE\t%2.2f%%\n', mean(ACCs)*100);



function pairs = parseList(list, folder)
    i    = 0;
    fid  = fopen(list);
    line = fgets(fid);
    while ischar(line)
          strings = strsplit(line, '\t');
          if length(strings) == 3
             i = i + 1;
             pairs(i).fileL = fullfile(folder, strings{1}, [strings{1}, num2str(str2num(strings{2}), '_%04i.jpg')]);
             pairs(i).fileR = fullfile(folder, strings{1}, [strings{1}, num2str(str2num(strings{3}), '_%04i.jpg')]);
             pairs(i).fold  = ceil(i / 600);
             pairs(i).flag  = 1;
          elseif length(strings) == 4
             i = i + 1;
             pairs(i).fileL = fullfile(folder, strings{1}, [strings{1}, num2str(str2num(strings{2}), '_%04i.jpg')]);
             pairs(i).fileR = fullfile(folder, strings{3}, [strings{3}, num2str(str2num(strings{4}), '_%04i.jpg')]);
             pairs(i).fold  = ceil(i / 600);
             pairs(i).flag  = -1;
          end
          line = fgets(fid);
    end
    fclose(fid);
end

function bestThreshold = getThreshold(scores, flags, thrNum)
    accuracys  = zeros(2*thrNum+1, 1);
    thresholds = (-thrNum:thrNum) / thrNum;
    for i = 1:2*thrNum+1
        accuracys(i) = getAccuracy(scores, flags, thresholds(i));
    end
    bestThreshold = mean(thresholds(accuracys==max(accuracys)));
end

function accuracy = getAccuracy(scores, flags, threshold)
    accuracy = (length(find(scores(flags==1)>threshold)) + ...
                length(find(scores(flags~=1)<threshold))) / length(scores);
end
