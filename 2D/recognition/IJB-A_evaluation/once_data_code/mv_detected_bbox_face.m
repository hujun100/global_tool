clear;
addpath(genpath('~/github/global_tool'));
data = importdata('/home/scw4750/Dataset/IJB-A/all_5pt.txt');
root_dir = '/home/scw4750/Dataset/IJB-A/template_subject_id_bbox_2.0';
des_dir = '/home/scw4750/Dataset/IJB-A/template_subject_id_bbox_1.0';
for i = 1:length(data)
    i
    lm_file = data{i};
    [lm, bbox, num_lm] = read_multi_5pt([root_dir filesep lm_file]);
    if num_lm ~= 1
        continue;
    end
    source_file = [root_dir filesep lm_file(1:end-3) 'jpg'];
    img = imread(source_file);
    align_bbox = get_align_bbox(img, bbox, 1.1);
    des_file = [des_dir filesep lm_file(1:end-3) 'jpg'];
    imwrite(img(align_bbox(2):align_bbox(2)+align_bbox(4), align_bbox(1):align_bbox(1)+align_bbox(3),:),...
        des_file);
%     copyfile(source_file, des_file);
end
