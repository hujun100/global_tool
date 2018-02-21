
function rank_count = compute_rank_from_img_feature_map(gal_img_feature_map, pro_img_feature_map, ...
    gal_txt_with_label, pro_txt_with_label)

rank_n =50;
rank_count=zeros(rank_n,1);

gal = get_name_label_by_txt(gal_txt_with_label);
pro = get_name_label_by_txt(pro_txt_with_label);
all_gal_names = extractfield(gal,'name');
all_pro_names = extractfield(pro,'name');
% all_gal_index = get_all_index(gal_img_feature_map, all_gal_names);
% all_pro_index = get_all_index(pro_img_feature_map, all_pro_names);

for i_p = 1:length(all_pro_names)
    i_p
    pro_name = all_pro_names{i_p};
    pro_feature = pro_img_feature_map(pro_name);
    all_scores = [];
    for i_g = 1:length(all_gal_names)
        gal_name = all_gal_names{i_g};
        gal_feature = gal_img_feature_map(gal_name);
%         temp_pro_feature = pro_feature/norm(pro_feature);
%         temp_gal_feature = gal_feature/norm(gal_feature);
        score = compute_cosine_score(pro_feature, gal_feature);
%         score = norm(temp_pro_feature-temp_gal_feature);
        all_scores = [all_scores score];
    end
    [~,index] = sort(all_scores,'descend');
%         [~,index] = sort(all_scores,'ascend');
    has_pinned=false;
    for i_s=1:rank_n
        if pro(i_p).label==gal(index(i_s)).label
            has_pinned=1;
        end
        rank_count(i_s)=rank_count(i_s)+has_pinned;
    end
end
rank_count = rank_count/length(all_pro_names);
end

% function all_index = get_all_index(img_feature_map, all_names)
% 
% for i_g = 1:length(all_names)
%     name = all_names{i_g};
%     index = find(strcmp(img_feature_map(:,1), name));
%     all_index(i_g) = index;
% end
% 
% end



function result=get_name_label_by_txt(txt)
fid=fopen(txt,'rt');
list=textscan(fid,'%s %f');
fclose(fid);
for i_g=1:length(list{1})
    result(i_g).name=list{1,1}{i_g};
    result(i_g).label=list{1,2}(i_g);
end
end
