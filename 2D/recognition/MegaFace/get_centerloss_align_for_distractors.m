addpath(genpath('~/github/global_tool'));
data = importdata('distractor_10k.txt');
des_dir = '/media/scw4750/pipa_IDcard/megaface/centerloss_distractor_1m/';
source_dir = '/media/scw4750/pipa_IDcard/megaface/distractor_1m/';
for i = 1:length(data)
    i
    img_name = data{i};
    img_file = [source_dir img_name];
    img = imread(img_file);
    
    pts_file = [img_file(1:end-3) '5pt'];
    make_dir([des_dir img_name]);
    if exist([img_file(1:end-3) '3pt'], 'file')
        align_img = centerloss_align_single_3pt(img,[img_file(1:end-3) '3pt']);
        imwrite(align_img,[des_dir img_name])
    elseif exist(pts_file,'file')
        align_img = centerloss_align_single(img,pts_file);
        imwrite(align_img,[des_dir img_name])
    else
        img = imresize(img,[112, 96]);
        imwrite(img, [des_dir img_name]);

    end
end