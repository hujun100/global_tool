data = importdata('/home/brl/TRAIN/DataSet/CACD/DATA/cleanedTestImageOfCACD_with_label.txt');
allPaths = data.textdata;
allLabel = data.data;
labeled_list = '/home/brl/TRAIN/DataSet/CACD/DATA/cleanedTestImageOfCACD_with_label_age.txt';
fid = fopen(labeled_list, 'wt');
allPathsLen = length(allPaths);
allAge = zeros(allPathsLen, 1);
for i = 1: allPathsLen
    i
    path = allPaths{i};
    age = path(1:2);
    allAge(i) = str2num(age);
    label = floor(str2num(age)/5)-3;
    if label == -1
        label=0;
    elseif label==9
        label=8;
    end
    fprintf(fid, '%s %d %d\n', path, allLabel(i), label); 
end
fclose(fid);
% interval = 5;
% for i = 2:12
%    lowerBound = i*interval;
%    upperBound = i*interval+interval-1;
%    index = find(allAge>=lowerBound & allAge<=upperBound);
%    length(index)
% end
% 14:19 20:24 ...50:54 55:62
