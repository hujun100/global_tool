addpath(genpath('~/github/global_tool'));
first_map = first_dataset_img_feature_map;
second_map = second_dataset_img_feature_map;
threshold = 0.35;
dir_for_twins = {};
for i_f = 1:size(first_map,1)
    i_f
    f_name = first_map{i_f,1};
    f_name_split = regexp(f_name,filesep,'split');
    f_dir = f_name_split{1};
    f_feature = first_map{i_f, 2};
    for i_w = 1:size(second_map,1)
%         i_w
        s_name = second_map{i_w, 1};
        s_name_split = regexp(s_name, filesep,'split');
        s_dir = s_name_split{1};
        s_feature = second_map{i_w,2};
        similarity = compute_cosine_score(f_feature, s_feature);
        if similarity>threshold
            dir_for_twins = [dir_for_twins [f_dir ' ' s_dir]];
        end
    end
    dir_for_twins = unique(dir_for_twins);
end
u_dir_for_twins = unique(dir_for_twins);
fid = fopen('dir_for_twins.txt');

for i_u = 1:length(u_dir_for_twins)
    dir_name = u_dir_for_twins{i_u};
    dir_name_split = regexp(dir_name, '_','split');
    fprintf(fid,'%s %s\n',dir_name_split{1},dir_name_split{2});
end
fclose(fid);