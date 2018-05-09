%To re-label images of a txt
%
% clc;clear;
addpath(genpath('~/github/global_tool'));
[all_imgs, all_labels] = read_txt('/home/brl/TRAIN/DataSet/webface_rm_dup_clean_wrong_example_10566.txt');

fid = fopen('/home/brl/TRAIN/DataSet/webface_rm_dup_clean_wrong_example_final.txt','wt');
tic
all_class_index = get_class_index(all_labels);
toc
del_count = 0;
for i = 1:length(all_class_index)
    i
    one_class_index = all_class_index{i};
    one_class_index_len = length(one_class_index);
    if one_class_index_len <5
        del_count = del_count + 1;
        continue;
    end
    for i_o = 1:one_class_index_len
        index = one_class_index(i_o);
        img_file = all_imgs{index};
        img_file_split = regexp(img_file,filesep,'split');
%         if strcmp(img_file_split{1},'sphere_22_railway')
%             del_count = del_count + 1;
%             break;
%         end
%         if strcmp(img_file_split{1},'sphere_30_railway')
%             del_count = del_count + 1;
%             break;
%         end
%         if strcmp(img_file_split{1},'bbox_webface')
%             del_count = del_count + 1;
%             break;
%         end
%         if strcmp(img_file_split{1},'bbox_pipa')
%             del_count = del_count + 1;
%             break;
%         end
        fprintf(fid, '%s %d\n',img_file,i-1-del_count);
    end
end

fclose(fid);

