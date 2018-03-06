addpath(genpath('H:/global_tool'));
data = importdata('H:/distractor_1m.txt');
des_dir = 'H:/alignedFlick/';
source_dir = 'H:/FlickrFinal2/';
for i = 1:length(data)
    i
    img_name = data{i};
    img_file = [source_dir img_name];
    img = imread(img_file);
    
    pts_file = [img_file '.5pt'];
    make_dir([des_dir img_name]);
	file_3pt = [img_file '.json.3pt'];
    make_dir([des_dir img_name]);
    if exist(pts_file, 'file')
        align_img = centerloss_align_single(img, pts_file, false);
        imwrite(align_img,[des_dir img_name])
    elseif exist(file_3pt,'file')
        align_img = centerloss_align_single_3pt(img,file_3pt);
        imwrite(align_img,[des_dir img_name])
    else
        img = imresize(img,[112, 96]);
        imwrite(img, [des_dir img_name]);

    end
end