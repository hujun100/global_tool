function [all_imgs, all_labels] = read_txt(txt_file)
fid = fopen(txt_file);
% data = textscan(fid,'%s %d\n');
count = 1;
tic
while 1
%     count
    if( mod(count, 100000) == 0)
        fprintf('read_txt function iteration:%d\n',count)
        toc
    end
    line = fgetl(fid);
    if ~ischar(line),break,end
%     line
    idx = strfind(line, ' ');
    if length(idx)>=1
        all_imgs{count} = line(1:idx(end)-1);
        all_labels(count) = str2num(line(idx(end)+1:end));
    else
        all_imgs{count} = line;
        all_labels = 'NULL';
    end
    count = count + 1;
end
fclose(fid);
end
