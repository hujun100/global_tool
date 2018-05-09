clc;clear;
train_data = read_list('/home/brl/TRAIN/DataSet/webface_rm_dup.txt');
del_data = read_list('/home/brl/github/global_tool/2D/train_data/rmDuplicateAcc.toImage/needDeleteList.txt');
diff = setdiff(train_data, del_data);

fid = fopen('/home/brl/TRAIN/DataSet/webface_rm_dup_clean_wrong_example.txt','wt');
for i_d = 1:length(diff)
    fprintf(fid,'%s\n', diff{i_d}); 
end
fclose(fid);


function all_lines = read_list(ffp)
fid = fopen(ffp);
tline = fgetl(fid);
count = 0;
while ischar(tline) 
    count = count + 1
    all_lines{count} = tline;
    tline = fgetl(fid);
end
fclose(fid);
end
