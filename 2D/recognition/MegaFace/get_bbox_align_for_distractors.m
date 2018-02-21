addpath(genpath('~/github/global_tool'));
data = importdata('distractor_10k.txt');
des_dir = '/media/scw4750/pipa_IDcard/megaface/centerloss_distractor_10k/';
source_dir = '/media/scw4750/pipa_IDcard/megaface/distractor_10k/';
for i = 1:length(data)
    i
    img_name = data{i};
    img_file = [source_dir img_name];
    img = imread(img_file);
    
    pts_file = [img_file(1:end-3) '5pt'];
    if exist(pts_file,'file')
        [lm,bbox] = read_5pt(pts_file);
        align_img = bbox_align_single_without_pts(img,bbox,1.1);
        imwrite(align_img,[des_dir img_name])
    elseif exist([img_file(1:end-3) 'bbox'], 'file')
        bbox = importdata([img_file(1:end-3) 'bbox']);
        if isempty(bbox)
            img = imresize(img,[256 256]);
            imwrite(img, [des_dir img_name]);
        end
        align_img = bbox_align_single_without_pts(img,bbox,1.1);
        imwrite(align_img,[des_dir img_name])
    else
        img = imresize(img,[256 256]);
        imwrite(img, [des_dir img_name]);
    end
end