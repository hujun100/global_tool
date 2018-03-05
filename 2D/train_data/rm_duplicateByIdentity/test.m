addpath(genpath('~/github/global_tool'));
% clear;
img_list = '/home/idealsee/gaofeifeiDataSet/clean_redup_vgg+asia+wf+tg3k+se3k+train2k.txt';
duplicate_list = '/home/idealsee/github/global_tool/2D/train_data/rm_duplicate/vggface2_webface_duplicate.csv';
change_second_label_to_first = true; %%
output_file = '/home/idealsee/gaofeifeiDataSet/clean_redup_vgg+asia+wf+tg3k+se3k+train2k_temp.txt';
%%% haha/hehe/dada/ccc; if name in duplicate_list is hehe, the this parameter should be 2
global anchor_num_in_name;
anchor_num_in_name = 2;


% [all_data, all_label] = read_txt(img_list);
fid = fopen(duplicate_list);
dup = textscan(fid,'%s %s\n');
first = dup{1};
second = dup{2};
fclose(fid);
if change_second_label_to_first == false
    temp = first;
    first = second;
    second = temp;
end
global all_dup;
all_dup = [first; second];


all_final_name = cell(1, length(all_data));
all_final_label = zeros(1, length(all_data));
% tic
% for i = 1:length(all_data)
%     i
%     name = all_data{i};
%     name_split = regexp(name, filesep, 'split');
%     anchor_name = name_split{anchor_num_in_name};
%     if find(strcmp(all_dup, anchor_name))
%         all_useful_name{count} = name;
%         all_useful_label(count) = all_label(i);
%         count = count + 1;
%     else
%         all_final_name{final_count} = name;
%         all_final_label(final_count) = all_label(i);
%         final_count = final_count + 1;
%     end
% end
% toc

tic
all_useless_index = find(cellfun(@find_useless_name, all_data));
all_use_index = setdiff(1:length(all_data), all_useless_index);
toc
final_count = length(all_useless_index) + 1;
all_final_name(1: final_count - 1) = all_data(all_useless_index);
all_final_label(1: final_count - 1) = all_label(all_useless_index);
all_useful_name = all_data(all_use_index);
all_useful_label = all_label(all_use_index);


dup_len = length(first);
useful_name_len = length(all_useful_name);

for i_d = 1:dup_len
    i_d
    first_name = first{i_d};
    second_name = second{i_d};
    all_first_index = find(cellfun('isempty', strfind(all_useful_name, [filesep first_name filesep])) == 0);
    all_second_index = find(cellfun('isempty', strfind(all_useful_name, [filesep second_name filesep])) == 0);
    label = all_useful_label(all_first_index(1));
    for i_f = 1:length(all_first_index)
        first_index = all_first_index(i_f);
        all_final_name{final_count} = all_useful_name{first_index};
        all_final_label(final_count) = label;
        final_count = final_count + 1;
    end
    for i_a = 1:length(all_second_index)
        second_index = all_second_index(i_a);
        all_final_name{final_count} = all_useful_name{second_index};
        all_final_label(final_count) = label;
        final_count = final_count + 1;
    end  
end
fid = fopen(output_file, 'wt');
for i = 1:length(all_final_name)
    fprintf(fid, '%s %d\n', all_final_name{i}, all_final_label(i)); 
end
fclose(fid);

function value = find_useless_name(name)

global all_dup;
global anchor_num_in_name;
name_split = regexp(name, filesep, 'split');
anchor_name = name_split{anchor_num_in_name};
value = ~max(strcmp(all_dup, anchor_name));

end
% re_label
