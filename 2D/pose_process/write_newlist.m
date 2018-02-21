% data = importdata('/home/idealsee/github/deep-head-pose-master/output/pose_webface.txt');
fid = fopen('/home/idealsee/github/deep-head-pose-master/output/pose_webface.txt');
% data = textscan(fid,'%s %d\n');
fout = fopen('newlist_for_pose_smaller_10.txt','wt');
count = 1;
while 1
    count
    line = fgetl(fid);
    if ~ischar(line),break,end
%     line
    idx = strfind(line, ' ');
    all_imgs{count} = line(1:idx(1)-1);
    first_pose = str2num(line(idx(1)+1:idx(2)-1));
    second_pose= str2num(line(idx(2)+1:idx(3)-1));
    third_pose = str2num(line(idx(3)+1:end));
    count = count + 1;
    max_pos = 10;
    if(abs(first_pose) < max_pos && abs(second_pose) < max_pos && abs(third_pose) < max_pos )
        fprintf(fout, '%s\n', line(1:idx(1)-1));
    end
end
fclose(fid);
fclose(fout);

