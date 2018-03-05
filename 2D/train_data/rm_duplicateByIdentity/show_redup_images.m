addpath(genpath('/home/idealsee/github/global_tool'));
% [vgg, vgg_labels] = read_txt('/home/idealsee/gaofeifeiDataSet/vgg.txt');
% [asia, asia_labels] = read_txt('/home/idealsee/gaofeifeiDataSet/rename_asia.txt');
sim = importdata('/home/idealsee/github/clean_data/vgg_asia_reduplicton_id.txt');
vgg_root = '/home/idealsee/gaofeifeiDataSet/';
asia_root = '/home/idealsee/gaofeifeiDataSet/';
fid = fopen('vgg_asia_intersection.txt','wt');

for i = 1:size(sim, 1)
    i
    folder = ['redup_id/' num2str(i)];
    if ~exist(folder,'dir')
        mkdir(folder);
    end
    first_id = sim(i, 1);
    second_id = sim(i, 2);
    similarity = sim(i, 3);
    first_index = find(vgg_labels == first_id);
    vgg_img_name = vgg{first_index(1)};
    first_split = regexp(vgg_img_name, filesep, 'split');
    
    second_index = find(asia_labels == second_id);
    asia_img_name = asia{second_index(1)};
    second_split = regexp(asia_img_name, filesep, 'split');
    fprintf(fid,'%s %s\n', first_split{2}, second_split{2});
%     if(length(first_index) <4 || length(second_index)<4)
%         continue;
%     end
%     for i_n = 1:3
%         vgg_img_name = vgg{first_index(i_n)};
%         copyfile([vgg_root vgg_img_name], fullfile(folder, strrep(vgg_img_name, '/','_')));
%         asia_img_name = asia{second_index(i_n)};
%         copyfile([asia_root asia_img_name], fullfile(folder, strrep(asia_img_name, '/','_')));
%     end
end
fclose(fid);
