data = importdata('newlist_for_pose_smaller_20.txt');
data_len = length(data);
number_list = 10;
for i = 1:number_list
    fid = fopen(['webface20_' num2str(i) '.txt'], 'wt');
    begin_j = (i-1) * floor(data_len/number_list) + 1;
    end_j = (i) * floor(data_len/number_list);
    for j = begin_j:end_j
         fprintf(fid, '%s\n', data{j});
    end
    fclose(fid);
end