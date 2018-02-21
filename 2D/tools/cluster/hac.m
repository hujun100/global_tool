addpath('~/github/caffe/matlab')
addpath(genpath('~/github/global_tool'));

if exist('ignore_idx','var')
    clear ignore_idx;
end
ignore_idx = [];
root_dir = '/home/scw4750/BRL/faces';
ignore_bro_count = 0;
for i_l = 1:reg_ID_len
     if is_big_angle([root_dir filesep all_reg_ID{i_l}])
         ignore_idx = [ignore_idx i_l]; 
         ignore_bro_count = ignore_bro_count + length(correspond_bro{i_l});
     end
end


data = zeros(4096, 1447);
data = data';
for i_r = 1:length(reg_ID_feature)
    i_r
    data(i_r,:) = reg_ID_feature{i_r};
end

Y=pdist(data, 'cosine');
Y=squareform(Y);
% Y=1-Y;
tic
Z=linkage(Y, 'average');
toc
% dendrogram(Z, 30);
c = cluster(Z,'maxclust',60);

output_root = '/home/scw4750/BRL/linkage_result';
if exist(output_root,'dir')
    rmdir(output_root,'s');
end
mkdir(output_root);
for i_a = 1:1447
    i_a
    if ~isempty(find(ignore_idx == i_a))
        continue;
    end
    output_dir = [output_root filesep num2str(c(i_a))];
    if ~exist(output_dir, 'dir')
        mkdir(output_dir);
    end
    name = all_reg_ID{i_a};
    sour_file = ['/home/scw4750/BRL/faces/' name];
    des_file = [output_dir filesep name];
    copyfile(sour_file, des_file);
    copyfile([sour_file(1:end-3) '5pt'], [des_file(1:end-3) '5pt']);
end





%%%%%%% delete folder with less than 5 image and the number of brother is
%%%%%%% less than 20
output = dir(out_root);
output = output(3:end);
all_img_count = 0;
for i_o = 1:length(output)
    folder = [output(i_o).folder filesep output(i_o).name];
    output_sub = dir([folder filesep '*.jpg']);
    bro_count = 0;
    for i_o = 1:length(output_sub)
        bro_idx = find(strcmp(all_reg_ID, output_sub(i_o).name));
        bro_count = bro_count + length(correspond_bro{bro_idx}); 
    end
    if length(output_sub)<7 && bro_count < 20
         rmdir(folder,'s');
    else
        all_img_count = all_img_count + bro_count + 1;
    end
end