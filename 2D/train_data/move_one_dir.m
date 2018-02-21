addpath(genpath('/raid/hujun/global_tool'));
data = importdata('/raid/hujun/train_data/selected_BRL_all.txt');
all_imgs = data.textdata;
all_labels = data.data;

for i = 1:length(all_imgs)
    i
    source_file = all_imgs{i};
    source_file_split = regexp(source_file,filesep,'split');
    img_name = [source_file_split{1} '_' source_file_split{2} '_' source_file_split{3}];;
    des_file = ['one_dir/' img_name];
    copyfile(source_file,des_file);
end