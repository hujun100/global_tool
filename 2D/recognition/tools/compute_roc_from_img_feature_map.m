
function [scores, labels] = compute_roc_from_img_feature_map(gal_img_feature_map, pro_img_feature_map, ...
    pos_neg_pair_txt)

% all_gal_names = keys(gal_img_feature_map);
% all_pro_names = keys(pro_img_feature_map);

[all_gal_names,all_pro_names,label]=get_ori_pair_label_from_txt(pos_neg_pair_txt);
for i_o=1:length(all_gal_names)
    i_o
    gal_name = all_gal_names{i_o};
    pro_name = all_pro_names{i_o};
%     gal_index = get_index_by_name(all_gal_names, gal);
%     pro_index = get_index_by_name(all_pro_names, pro);
    gal_feature = gal_img_feature_map(gal_name);
    pro_feature = pro_img_feature_map(pro_name);
    scores(i_o)= compute_cosine_score(gal_feature, pro_feature);
    labels(i_o)=label(i_o);
end





end


function [ori,pair,label]=get_ori_pair_label_from_txt(pos_txt)
fid=fopen(pos_txt,'rt');
pos=textscan(fid,'%s %s %d\n');
fclose(fid);
ori=pos{1};pair=pos{2};label=pos{3};
end

% function rank_count = compute_rank_from_img_feature_map(gal_img_feature_map, pro_img_feature_map, ...
%     gal_txt_with_label, pro_txt_with_label)
% 
% rank_n =50;
% rank_count=zeros(rank_n,1);
% 
% 
% 
% for i_p = 1:length(all_pro_index)
%     i_p
%     pro_index = all_pro_index(i_p);
%     pro_feature = pro_img_feature_map{pro_index,2};
%     all_scores = [];
%     for i_g = 1:length(all_gal_index)
%         gal_index = all_gal_index(i_g);
%         gal_feature = gal_img_feature_map{gal_index, 2};
%         score = compute_cosine_score(pro_feature, gal_feature);
%         all_scores = [all_scores score];
%     end
%     [~,index] = sort(all_scores,'descend');
%     has_pinned=false;
%     for i_s=1:rank_n
%         if pro(i_p).label==gal(index(i_s)).label
%             has_pinned=1;
%         end
%         rank_count(i_s)=rank_count(i_s)+has_pinned;
%     end
% end
% rank_count = rank_count/length(all_pro_index);
% end
% 
% function all_index = get_all_index(img_feature_map, all_names)
% 
% for i_g = 1:length(all_names)
%     name = all_names{i_g};
%     index = find(strcmp(img_feature_map(:,1), name));
%     all_index(i_g) = index;
% end
% 
% end
% 
% 
% 
% function result=get_name_label_by_txt(txt)
% fid=fopen(txt,'rt');
% list=textscan(fid,'%s %f');
% fclose(fid);
% for i_g=1:length(list{1})
%     result(i_g).name=list{1,1}{i_g};
%     result(i_g).label=list{1,2}(i_g);
% end
% end
