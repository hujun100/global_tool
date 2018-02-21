function T = regAffine(M, S)
% Compute the affine transform between two sets of corresponding points
%
% Inputs:
%   M -- First set of points, 2*n matrix, each column is a point (x, y)
%   S -- Second set of points
%
% Outputs:
%   T -- The affine transformation matrix which maps the points in the
%           second set 'S' to the ones in the first set 'M'.
%           T is a 3*3 matrix: [a b e; c d f; 0 0 1], where a, b, c, d, e,
%           f are the unknown parameters
%
% Requirements:
%   At least three pairs of corresponding points are needed.
%
% Qijun Zhao
% 2014-07

n = size(M, 2);
if n<3
    error('ERROR: At least three pairs of corresponding points are required');
end

A = zeros(2*n, 6);
b = zeros(2*n, 1);

for i = 1:n
    idx = (i-1)*2+1;
    A(idx, :) = [S(1, i) S(2, i) 0 0 1 0];
    A(idx+1, :) = [0 0 S(1, i) S(2, i) 0 1];
    b(idx) = M(1, i);
    b(idx+1) = M(2, i);
end

X = A\b;

T = [X(1) X(2) X(5); X(3) X(4) X(6); 0 0 1];
