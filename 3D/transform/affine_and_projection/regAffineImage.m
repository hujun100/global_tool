function [im2] = regAffineImage(im1, T)
% Map the input image im1 to a new image im2 via a given affine
% transformation matrix T
%
% Inputs:
%   im1 -- The input image
%   T   -- The given affine transformation matrix, which can be obtained by
%           using the function regAffine
%           T is a 3*3 matrix: [a b e; c d f; 0 0 1] with six parameters a, b, c, d, e and
%           f.
%
% Outputs:
%   im2 -- The affine-transformed version of the input image
%
% Qijun Zhao
% 2014-07

[h, w, nc] = size(im1);
if nc == 1
    im2 = zeros(h, w);
elseif nc == 3
    im2 = zeros(h, w, nc);
else
    error('ERROR: Unknown image formats');
end

[cs, rs] = meshgrid(1:w, 1:h);

coor2 = [cs(:) rs(:)]';

coor1 = inv(T) * [coor2; ones(1, size(coor2, 2))];
coor1(3, :) = [];

coor1 = floor(coor1);
idx = find(coor1(1, :)<=0 | coor1(1, :)>w | coor1(2, :)<=0 | coor1(2, :)>h);
coor2(:, idx) = [];
coor1(:, idx) = [];

ind1 = sub2ind([h, w], coor1(2, :), coor1(1, :));
ind2 = sub2ind([h, w], coor2(2, :), coor2(1, :));

if nc == 1
    im2(ind2) = im1(ind1);
else
    im2(ind2) = im1(ind1);
    im2(h*w+ind2) = im1(h*w+ind1);
    im2(2*h*w+ind2) = im1(2*h*w+ind1);
end

im2 = uint8(im2);

