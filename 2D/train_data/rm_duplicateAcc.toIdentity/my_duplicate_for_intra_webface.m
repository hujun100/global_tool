clear;
addpath(genpath('~/github/global_tool'));
fid = fopen('/media/idealsee/小熊U盘/FaceDatasets-master/CASIA/webface_id_name_list.txt');
webface = textscan(fid,'%d %s');
webface_id = webface{1};
webface_name = webface{2};
fclose(fid);
[all_name_index, all_name_id] = get_name_index(webface_name);
fid = fopen('webface_intra.csv','wt');
for i = 1:length(all_name_index)
    index = all_name_index{i};
    if length(index) == 2
        fprintf(fid, '%07d %07d\n', webface_id(index(1)), webface_id(index(2))); 
    end
end
fclose(fid);
% 
% fid = fopen('inte.txt','wt');
% inte = intersect(vgg(:,2), webface_name);
% for i = 1:length(inte)
%     i
%     vgg_idx = find(strcmp(vgg(:,2), inte{i})); 
%     vgg_idx = vgg_idx(1);
%     wf_idx = find(strcmp(webface_name, inte{i}));
%     wf_idx = wf_idx(1);
%     fprintf(fid,'%07d %s\n', webface_id(wf_idx), vgg{vgg_idx,1});
% end
% fclose(fid);
