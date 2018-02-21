% gal = analysis.gallery_info;
% pro = analysis.probe_info;
% score_matrix = analysis.distance_matrix;
% [gal_class, gal_class_id] = get_class_index(extractfield(gal, 'label'));
% [pro_class, pro_class_id] = get_class_index(extractfield(pro, 'label'));
% gal_class_num = length(gal_class);
% pro_class_num = length(pro_class);
% merged_score_matrix = zeros(pro_class_num, gal_class_num);
% gal_cal_count = 0;
% for i_p = 1:pro_class_num
%     i_p
%     pro_class_index = pro_class{i_p};
%     pro_name = pro(pro_class_index(1)).name;
%     pro_name_split = regexp(pro_name, filesep, 'split');
%     all_pro_name{i_p} = pro_name_split{2};
%     for i_g = 1:gal_class_num
%         gal_class_index = gal_class{i_g};
%         gal_name = gal(gal_class_index(1)).name;
%         if gal_cal_count == 0
%             gal_name_split = regexp(gal_name, filesep, 'split');
%             all_gal_name{i_g} = gal_name_split{2};
%         else
%             gal_cal_count = 1; 
%         end
%         max_value = max(max(score_matrix(pro_class_index, gal_class_index)));
%         mean_value = mean(mean(score_matrix(pro_class_index, gal_class_index)));
%         merged_score_matrix(i_p, i_g) = mean_value;
%     end
% end

data_fid = fopen('/home/idealsee/github/clean_data/vgg_asia_intersection.txt');
data= textscan(data_fid,'%s %s');
all_pro_name_needed = data{2}; 
fclose(data_fid);
fid = fopen('old_rename_corrosponding.txt','wt');
for i = 1:length(all_pro_name_needed)
    pro_name = all_pro_name_needed{i};
    pro_index = find(strcmp(all_pro_name, pro_name));
    [max_score, max_index] = max(merged_score_matrix(pro_index, :));
    gal_name = all_gal_name{max_index};
    fprintf(fid, '%s %s\n', pro_name, gal_name);
end
fclose(fid);
