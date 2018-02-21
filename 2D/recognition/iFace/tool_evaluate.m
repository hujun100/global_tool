
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
    v4 = getSimilarity_wolfit(featsP_idx, f1);
    v5 = getSimilarity_wolfit(featsP_idx, f2);
%     % �����쳣����
%     if v4>0.9
%         na1 = C{y(i)};
%         sim2 = featsP_idx * f1';
%         [~, it] = max(sim2);
%         na2 = C{it};
%         fprintf('exception: (%s) (%s) similarity %0.4f\n', na1, na2, v4);
%     end
%     if v5>0.9
%         na1 = C{y(i)};
%         sim2 = featsP_idx * f2';
%         [~, it] = max(sim2);
%         na2 = C{it};
%         fprintf('exception: (%s) (%s) similarity %0.4f\n', na1, na2, v5);
%     end
%     % �������ƶ�
    sim(i, :) = [v1 v2 v3 v4 v5];
end

%% ͳ��ʶ���ʣ��������֮���ƶ�>=��ֵ�����������������ƶ�<��ֵ
% % �ֱ���Բ�ͬ����ֵ������ͳ��
ThS = 0:0.01:1;
N = numel(ThS);
Ys = [];
for i=1:N
    succ1 = sim(:,1) >= ThS(i);
    succ2 = sim(:,2) < ThS(i);
    succ3 = sim(:,3) < ThS(i);
    succ4 = sim(:,4) < ThS(i);
    succ5 = sim(:,5) < ThS(i);
    
    succ = succ1 & succ2 & succ3 & succ4 & succ5;
    y = sum(succ)/numel(succ);
    Ys = [Ys; y];
end

% % ���������ֵ
[bestY, idx] = max(Ys);
bestT = ThS(idx);
errIDX = (sim(:,1) >= bestT) & (sum(sim(:, 2:end)>=bestT, 2));
errY = sum(errIDX)/numel(errIDX);
lostIDX = sim(:,1) < bestT;
lostY = sum(lostIDX)/numel(lostIDX);
s = sprintf('\n[rank-1 (%0.2f%%),false alarm:(%0.2f%%),miss rate:(%0.2f%%), best thresholdֵ:%0.2f]\n',...
    bestY*100, errY*100, lostY*100, bestT);
fprintf('%s\n', s);

% % ����
plot(ThS, Ys);
title(s);   xlabel('threshold');   ylabel('rank-1 detection rate');
ylim([0 1]);    grid on;    drawnow
% % ������ֵ��ʹ�ò�׼��Ϊ100%
maxT = max(max(sim(:, 2:end)));
succ = sim(:,1) > maxT;
y = sum(succ)/numel(succ);
fprintf('[when threshold=%0.2f recgnition:100%%, miss rate:%0.2f%%]\n\n', maxT, 100*(1 - y));



%% �������ƶȣ�wolfit���磩
function sim = getSimilarity_wolfit(feats, f)

sim = max(feats * f');
sim = sim(1);

end

% %% �������ƶȣ�resnet���磩
% function sim = getSimilarity_resnet(feats, f)
% 
% N = size(feats, 1);
% vec = zeros(N, 1);
% for i=1:N
%     vec(i) = 1-norm(feats(i,:) - f);
% end
% 
% sim = max(vec);
% sim = sim(1);
% 
% end

% function sim = getSimilarity_resnet_cosine(feats, f)
% 
% N = size(feats, 1);
% vec = zeros(N, 1);
% for i=1:N
%     vec(i) = compute_cosine_score(feats(i,:)',f');
% end
% 
% sim = max(vec);
% sim = sim(1);
% 
% end



