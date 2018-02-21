clear;
% The function of this script: 
%      Get aligned image invented by BRL.   The detail of this algorithm at the end of this script. 
%
%
%
%
%notices: 1. the five points should be  left-eye,right-eye,nose,left,mouse,rightmouse  in order;
%        the format in pts should be left-eye-x left-eye-y \n      a   
%                                    right-eye-x right-eye-y \n
%                                    ...
%         2. the resized image must be square
%         3. the images should be stored as  root_dir/class/image
%Jun Hu
%2017-4
face_dir='/home/scw4750/Dataset/iFace/distractors_wrapper';
ffp_dir=face_dir;
save_dir='/home/scw4750/Dataset/iFace/BRL_distractors';
% save_dir='/home/scw4750/github/IJCB2017/liangjie/croped/with_pts/enlarge_mulitpie_croped_by_liang_with_pts/gallery';
pts_format='5pt';
output_format='jpg';
filter='*.jpg';
is_continue=true; %when landmarks does not exist or is not correct,choose whether to continue;
is_train=false;
brl_align(face_dir, ffp_dir, save_dir,'*.jpg',output_format,pts_format,is_continue,is_train);

%algorithm:
%If both left-eye and right-eye are on the same side of nose, we use bbox alignment. Otherwise, using lightcnn alignment method.
%
%
%
