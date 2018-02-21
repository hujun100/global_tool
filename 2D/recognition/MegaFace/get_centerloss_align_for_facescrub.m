%%prerequisite:    
%%               image_name_txt which contains all the images name
%%               serveral containers.map which contains the corresponding bbox of image in img_name_txt
%%
%%
addpath(genpath('~/github/global_tool'));
data =importdata('/home/scw4750/github/global_tool/2D/recognition/MegaFace/faceScrub.txt');
root_dir = '/media/scw4750/pipa_IDcard/megaface/FaceScrub/downloaded/';
output_dir = '/media/scw4750/pipa_IDcard/megaface/centerloss_FaceScrub/';
padding_factor=1.1;

for i_d = 1:length(data)
    i_d
    img_name = data{i_d};
    img = imread([root_dir img_name]);
    pts_name = [img_name '.5pt'];
    pts_file = [root_dir pts_name];
    
    img_name_split = regexp(img_name,filesep,'split');
    output_file_dir = [output_dir img_name_split{1}];
    output_file = [output_dir img_name];
    if ~exist(output_file_dir,'dir')
        mkdir(output_file_dir);
    end
    assert(logical(exist(pts_file,'file')),'landmarks should be provided');

    align_img = centerloss_align_single(img,pts_file);
%     imshow(align_img);
    imwrite(align_img,output_file,'JPEG');
end