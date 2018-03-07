data = importdata('/home/brl/Megaface/distractor_1m.txt');
fid = fopen('/home/brl/Megaface/distractor_1mWithLabel.txt','wt');
% %%for facescrub
% allClass = cell(length(data), 1);
% for i = 1:length(data)
%     path = data{i};
%     idx = strfind(path, '/');
%     class = path(1:idx(1));
%     allClass{i} = class;
% end
% uClass = unique(allClass);
% for i = 1:length(uClass)
%     if mod(i, 100) == 1
%         fprintf('length(uClass):%d ; i in uClass:%d\n', length(uClass), i); 
%     end
%     idx = find(strcmp(allClass, uClass{i}));
%     for i_i = 1:length(idx)
%         oneIdx = idx(i_i);
%         fprintf(fid,'%s\t%d\n', data{oneIdx}, i-1);
%     end
% end
% fclose(fid);

%%for distractor

allClass = cell(length(data), 1);
for i = 1:length(data)
    i
    path = data{i};
    fprintf(fid,'%s\t0\n', path);
end
fclose(fid);