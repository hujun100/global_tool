%%%to select 6 images for each class in training process


addpath(genpath('/raid/hujun/global_tool'));
data = importdata('label_wrong_BRL_all.txt');
all_imgs = data.textdata;
all_labels = data.data;

% for i = 1:length(all_labels)
%     i
%     assert(all_labels(i+1)-all_labels(i)<=1,'assert');
% end
fid = fopen('label_corrected_BRL_all.txt','wt');
all_class_index = get_class_index(all_labels);
for i = 1:length(all_class_index)
    i
    one_class_index = all_class_index{i};
    one_class_index_len = length(one_class_index);
    
    for i_o = 1:one_class_index_len
        index = one_class_index(i_o);
        fprintf(fid, '%s %d\n',all_imgs{index},i-1);
    end
end

fclose(fid);
