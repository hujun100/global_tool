clear;clc;
data = importdata('/home/brl/TRAIN/DataSet/cacd_and_morph/morph_trainList.txt');
fid = fopen('/home/brl/TRAIN/DataSet/cacd_and_morph/trainList_with_label_age_10.txt', 'wt');
class_label_count = 1979;
last_class = '';
for i = 1:length(data)
    i
    path = data{i};
    class = path(1:6);
    age = str2num(path(end-5:end-4));
    if strcmp(last_class, class) == 0
        last_class = class;
        class_label_count = class_label_count + 1;
    end
    age_label = floor(age/10)-1;
    if age_label>=6
        age_label=5;
    end
    fprintf(fid,'%s %d %d\n', path, class_label_count, age_label);
end

fclose(fid);
