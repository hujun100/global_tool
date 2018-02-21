
function [lm2] = read_pts(name, landmarks_num)

lm2 = zeros(landmarks_num, 2);
fid = fopen(name);
answ = textscan(fid,'%f %f',landmarks_num,'headerlines',3);
lm2(:,1) = answ{1,1};
lm2(:,2) = answ{1,2};
fclose(fid);




