clc;clear;
data = importdata('MS_reduplicton_id_v2.txt');
fid = fopen('asia_intra.csv','wt');
for i = 1:size(data, 1);
     fprintf(fid,'%06d %06d\n', data(i,1), data(i,2));
end
fclose(fid);