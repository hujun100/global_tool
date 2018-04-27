clear;clc;
data = importdata('/home/brl/TRAIN/DataSet/webface_rm_dup_clean_wrong_example.txt');
all_path = data.textdata;
all_label = data.data;
fid = fopen('/home/brl/TRAIN/DataSet/webface_test_list.txt','wt');
last_label = -1;
for i = 1:length(all_path)
    i
    if(last_label ~= all_label(i))
        last_label = all_label(i);
        count = 0;
        fprintf(fid,'%s %d\n', all_path{i}, all_label(i));
    else
        if count < 2
            count = count + 1;
            fprintf(fid,'%s %d\n', all_path{i}, all_label(i));
        end
    end
end

fclose(fid);