% Copyright (c) 2014
% Zhixuan Ding, Lin Zhang software college of Tongji University, 20134


function [data, zmin, nrows, ncols, imfile] = read_bntfile(filepath)




fid = fopen(filepath, 'r');
if (fid == -1)
    disp(['Could not open file, ' filepath]);
    return
end

nrows = fread(fid, 1, 'uint16');
ncols = fread(fid, 1, 'uint16');
zmin = fread(fid, 1, 'float64');

len = fread(fid, 1, 'uint16');
imfile = fread(fid, [1 len], 'uint8=>char');

% normally, size of data must be nrows*ncols*5
len = fread(fid, 1, 'uint32');
data = fread(fid, [len/5 5], 'float64');

fclose(fid);