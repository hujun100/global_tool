clear;
% The function of this script: get aligned image by bbox. The detail of this algorithm at the end of this script.
%
%
%notices: 1. the five points should be  left-eye,right-eye,nose,left-mouse,right-mouse  in order;
%        the format in pts should be left-eye-x left-eye-y \n
%                                    right-eye-x right-eye-y \n
%                                    ...
%         3. the images should be stored as  root_dir/class/image
%Jun Hu
%2017-4

face_dir='/home/scw4750/BRL/LJ/multipie-data/multipie_data_all';
ffp_dir=face_dir;
save_dir='/home/scw4750/BRL/LJ/multipie-data/bbox_probe';
% save_dir='/home/scw4750/github/IJCB2017/liangjie/croped/with_pts/enlarge_mulitpie_croped_by_liang_with_pts/gallery';
pts_format='.5pt';
output_format='jpg';
filter='*.jpg';
is_continue= true; %when landmarks does not exist or is not correct,choose whether to continue;
is_train = false;
bbox_align(face_dir, ffp_dir, save_dir,filter,output_format,pts_format,is_continue,is_train);


%algorithm:
% firstly, this algorithms get the center of the origin bbox
% then, set the center as new bbox's center and the
% max(height,width)*crop_factor as the size of bbox.
% As a result, the image in bbox is aligned image.
