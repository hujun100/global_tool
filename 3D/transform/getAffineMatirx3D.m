function T = getAffineMatirx3D(M, S)
% Compute the affine transform between two sets of corresponding points
%
% Inputs:
%   M -- First set of points, 3*n matrix, each column is a point (x, y,z)
%   S -- Second set of points
%
% Outputs:
%   T -- The affine transformation matrix which maps the points in the
%           second set 'S' to the ones in the first set 'M'.
%           T is a 4*4 matrix: [s_x 0 0 t_x;s_y 0 0 t_y;s_z 0 0 t_z; 0 0 0 1], where are the unknown parameters
%
% Requirements:
%   At least three pairs of corresponding points are needed.
%
% feng Liu
% 2015-04

n = size(M, 2);
if n<3
    error('ERROR: At least three pairs of corresponding points are required');
end

A = zeros(3*n, 6);
b = zeros(3*n, 1);

for i = 1:n
    idx = (i-1)*3+1;
    A(idx, :) = [S(1, i) 1 0 0 0 0];
    A(idx+1, :) = [0 0 S(2, i) 1 0 0];
    A(idx+2, :) = [0 0 0 0 S(3, i) 1];
    b(idx) = M(1, i);
    b(idx+1) = M(2, i);
    b(idx+2) = M(3, i);
end

X = pinv(A)*b;

T = [X(1) 0 0 X(2);0 X(3) 0 X(4);0 0 X(5) X(6);0 0 0 1];
