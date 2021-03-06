%%%% To rm the un-exist line in txt
% refresh('bbox_22_railway.txt','refresh_bbox_22_railway.txt');
% refresh('bbox_30_railway.txt','refresh_bbox_30_railway.txt');
% refresh('bbox_asia.txt','refresh_bbox_asia.txt');
% refresh('bbox_webface.txt','refresh_bbox_webface.txt');
% refresh('bbox_hujun.txt','refresh_bbox_hujun.txt');
addpath(genpath('~/github/global_tool'));
source_list = '/home/brl/TRAIN/DataSet/cacd_and_morph/morph_trainList.txt';
des_list = '/home/brl/TRAIN/DataSet/cacd_and_morph/morph_trainList_refreshed.txt';
copyfile(source_list, des_list);
[image, label] = read_txt(des_list);
refresh(des_list, image);

function refresh(out_ffp, image)
root_dir = '/home/brl/TRAIN/DataSet/cacd_and_morph/morph_classPerFoler/';

fid = fopen('del_line_list.txt','wt');
% data = importdata(ffp);
% image = data.textdata;
% label = data.data;

for i = 1:length(image)
    i
    img_name = image{i};
    if ~exist([root_dir img_name],'file')
        fprintf(fid,'%d\n', i); 
    end
end

fclose(fid);
system(['tac del_line_list.txt|xargs -i sed -i ''{}d'' '  out_ffp]);

end
