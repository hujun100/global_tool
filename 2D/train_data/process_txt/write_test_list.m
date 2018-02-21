
fid = fopen('/home/idealsee/face_train_data_needed/asia_4594_suzhou_megaface_7k_x6_final.txt');
data =textscan(fid,'%s %d\n');
all_labels = data{2};
all_imgs = data{1};
fclose(fid);

fid = fopen('/home/idealsee/face_train_data_needed/asia_4594_suzhou_megaface_7k_x6_test.txt','wt');
label_len = length(all_labels);
r = randperm(label_len);
for i = 1:2000
    index = r(i);
    fprintf(fid,'%s %d\n',all_imgs{index},all_labels(index));
end
fclose(fid);