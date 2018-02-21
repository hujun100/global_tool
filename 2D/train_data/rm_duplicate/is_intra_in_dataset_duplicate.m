clear;clc
inter = read_duplicate('all_inter.txt');
intra = read_duplicate('all_intra.txt');
for i = 1:length(intra)
%     i
    index = find(strcmp(inter, intra{i}));
    if ~isempty(index)
        fprintf('%s\n', intra{i}); 
    end
end

function all = read_duplicate(list)

fid = fopen(list);
dup = textscan(fid,'%s %s\n');
first = dup{1};
second = dup{2};
fclose(fid);
all=[first;second];
end