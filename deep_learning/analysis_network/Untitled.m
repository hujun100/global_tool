addpath(genpath('~/github/global_tool'));
% a = img_feature_map('0_1673/frame_29930_00060.jpg');
% b = img_feature_map('0_1673/frame_29985_00540.jpg');
% c = img_feature_map('0_1673/img_8558.jpg');
% 
% compute_cosine_score(a,b);
% compute_cosine_score(b,c);
% compute_cosine_score(a,c);
% a_pos_index = find(a>0);
% b_pos_index = find(b>0);
% c_pos_index = find(c>0);
% length(intersect(a_pos_index,b_pos_index))
% length(intersect(a_pos_index,c_pos_index))
% length(intersect(b_pos_index,c_pos_index))
% % a(a<0) = 0;
% % b(b<0) = 0;
% % c(c<0) = 0;
% % 
% % compute_cosine_score(a,b)
% % compute_cosine_score(b,c)
% % compute_cosine_score(a,c)
data = importdata('/home/scw4750/Dataset/IJB-A/all_imgs.txt');
inter  = 1:4096;
for i = 1:23
    feature = img_feature_map(data{i});
    pos_index = find(feature>0);
    inter = intersect(inter,pos_index);
end