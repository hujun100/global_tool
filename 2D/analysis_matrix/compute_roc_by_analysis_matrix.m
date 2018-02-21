function [scores,labels]=compute_roc_by_analysis_matrix(analysis,merged_txt,neg_txt)
% notices:
%   if there are three parameters, then
%       second parameter should be positive pair txt
%                     (origin image name, pair image name, 1)
%       third parameter should be negative pair txt
%                     (origin iamge name, pair image name, 0)
%   if there are two parameters, then second parameter should be txt
%                     (origin image name, pair image name, label)
%
%input:
%  analysis           -- analysis matrix named by Jun Hu
%  merged_txt         --if there are three parameters, the txt should be postive pair txt. if there are two parameters,the txt should be mreged pair txt;
%  neg_txt            --the txt contains origin name and pair name and 0
%               notices: the name should be the same as it stored in
%                 analysis matrix
%output:
%  scores,labels      --the postive and negative pair with scores and
%              labels for drawing roc
%
%Jun Hu
%2017-4

gallery=analysis.gallery_info;
probe=analysis.probe_info;
distance_matrix=analysis.distance_matrix;

if nargin>=3
    
    [ori,pair,label]=get_ori_pair_label_from_txt(pos_txt);
    for i_o=1:length(ori)
        gal_index=get_index_by_name(gallery,ori{i_o});
        pro_index=get_index_by_name(probe,pair{i_o});
        pos_pair(i_o)=distance_matrix(pro_index,gal_index);
    end
    pos_label=ones(1,length(pos_pair));
    
    [ori,pair,label]=get_ori_pair_label_from_txt(neg_txt);
    for i_o=1:length(ori)
        gal_index=get_index_by_name(gallery,ori{i_o});
        pro_index=get_index_by_name(probe,pair{i_o});
        neg_pair(i_o)=distance_matrix(pro_index,gal_index);
    end
    neg_label=zeros(1,length(neg_pair));
    scores=[pos_pair neg_pair];
    labels=[pos_label neg_label];
else
    pos_txt=merged_txt;
    gallery=analysis.gallery_info;
    probe=analysis.probe_info;
    
    [ori,pair,label]=get_ori_pair_label_from_txt(pos_txt);
    for i_o=1:length(ori)
        gal_index=get_index_by_name(gallery,ori{i_o});
        pro_index=get_index_by_name(probe,pair{i_o});
        scores(i_o)=distance_matrix(pro_index,gal_index);
        labels(i_o)=label(i_o);
    end
end
end


function index=get_index_by_name(gallery,name)
   [temp,index]=max(strcmp(extractfield(gallery,'name'),name));
end
function [ori,pair,label]=get_ori_pair_label_from_txt(pos_txt)
fid=fopen(pos_txt,'rt');
pos=textscan(fid,'%s %s %d\n');
fclose(fid);
ori=pos{1};pair=pos{2};label=pos{3};
end
