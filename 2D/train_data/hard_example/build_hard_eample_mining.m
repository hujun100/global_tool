addpath(genpath('/home/idealsee/github/global_tool'));
% [origin, origin_label] = read_txt_basic('/home/idealsee/gaofeifeiDataSet/wf+MS+sz2k+tg2k+train2k-112X96.txt');
% [hard, hard_label] = read_txt_basic('/home/idealsee/gaofeifeiDataSet/hard_example_without_vgg.txt');
r = randperm(length(origin));
hard_len = length(hard);
ratio = 10;
fid = fopen('~/github/global_tool/2D/train_data/hard_origin_1_3.txt','wt');
for i = 1:hard_len * ratio
    i
      fprintf(fid,'%s %d\n',origin{r(i)}, origin_label(r(i)));
end
for i = 1:hard_len
    i
      fprintf(fid,'%s %d\n', hard{i}, hard_label(i));    
end
fclose(fid);
