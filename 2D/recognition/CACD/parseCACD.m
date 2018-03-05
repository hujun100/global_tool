data = importdata('/home/brl/TRAIN/DataSet/CACD/DATA/cleanedCACDList.txt');
labeled_list = '/home/brl/TRAIN/DataSet/CACD/DATA/cleanedCACDList_with_label.txt';

data_len = length(data);
all_names = cell(data_len, 1);
for i = 1: data_len
    i
    path = data{i};
    name = path(3:end-9);
    all_names{i} = name;
end

all_u_names = unique(all_names); 
fid = fopen(labeled_list, 'wt');
for i = 1:length(all_u_names)
    i
    u_name = all_u_names{i};
    idx = find(strcmp(all_names, u_name));
    for i_i = 1:length(idx)
        fprintf(fid, '%s %d\n', data{idx(i_i)}, i-1); 
    end
end
fclose(fid);
