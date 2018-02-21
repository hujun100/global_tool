%%prerequisite:    
%%               image_name_txt which contains all the images name
%%               serveral containers.map which contains the corresponding bbox of image in img_name_txt
%%
%%
addpath(genpath('~/github/global_tool'));
image_name_txt='/home/scw4750/github/global_tool/2D/recognition/MegaFace/faceScrub.txt';
data =importdata(image_name_txt);
root_dir = '/media/scw4750/pipa_IDcard/megaface/FaceScrub/downloaded/';
output_dir = '/media/scw4750/pipa_IDcard/megaface/bbox_FaceScrub/';
padding_factor=1.1;

for i_d = 1:length(data)
    i_d
    img_name = data{i_d};
    img = imread([root_dir img_name]);
    pts_name = [img_name(1:end-3) '5pt'];
    pts_file = [root_dir pts_name];
    
    img_name_split = regexp(img_name,filesep,'split');
    output_file_dir = [output_dir img_name_split{1}];
    output_file = [output_dir img_name];
    if ~exist(output_file_dir,'dir')
        mkdir(output_file_dir);
    end
    gt_bbox=[];
    if actors_map.isKey(img_name) 
        gt_bbox = actors_map(img_name);
    end
    if actresses_map.isKey(img_name)
        gt_bbox = actresses_map(img_name);
    end

    assert(~isempty(gt_bbox),'error');


    if exist(pts_file,'file')
        [pts,bbox]=read_5pt(pts_file);
        iou = IoU(gt_bbox,bbox');
        if iou>0.3
             align_img = bbox_align_single(img,pts_file,1.1);
             imwrite(align_img,output_file,'JPEG');
             continue;
        end
    end
    align_img = bbox_align_single_without_pts(img,gt_bbox,1.5);
    imwrite(align_img,output_file,'JPEG');
end