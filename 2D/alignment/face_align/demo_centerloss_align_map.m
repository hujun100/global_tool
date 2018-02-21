clear;
addpath(genpath('~/github/global_tool'));
% img_dir = '/home/idealsee/face_train_data_needed/SuZhou_major_se1000/'
save_dir='/home/idealsee/face_train_data_needed/sphere_train-7k/';
name_lm_bbox_map_mat = '/home/idealsee/github/global_tool/2D/detection/mtcnn/train-7k_lm_bbox_map.mat';
load(name_lm_bbox_map_mat);

residual_num = 2 ;

img_list = name_bbox_map.keys();

for i = 1:length(img_list)
    i
    img_name = img_list{i};
    img = imread(img_name);
    landmarks = name_lm_map(img_name);
    img_aligned = centerloss_align_single_map(img, landmarks);
%     img_name = [img_dir img_name];
    idx = strfind(img_name, filesep);
    output_name = [save_dir img_name(idx(end - residual_num + 1) + 1:end)];
    make_dir(output_name);
    imwrite(img_aligned, output_name);
end

function img_cropped=centerloss_align_single_map(img,facial_point)  
        imgSize = [112, 96]; 
        coord5points = [30.2946, 65.5318, 48.0252, 33.5493, 62.7299; ...
            51.6963, 51.5014, 71.7366, 92.3655, 92.2041];
        facial5points = double(reshape(facial_point, 5, 2)');
        Tfm =  cp2tform(facial5points', coord5points', 'similarity');
        img_cropped = imtransform(img, Tfm, 'XData', [1 imgSize(2)],...
            'YData', [1 imgSize(1)], 'Size', imgSize);

end

