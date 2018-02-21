function T = weak_projection(M, S)
% Compute the 3D rigid transform between two sets of corresponding points
%
% Inputs:
%   M -- First set of points, 2*n matrix, each column is a point (x, y)
%   S -- Second set of points,3*n matrix,each column is a point(x,y,z)
%
% Outputs:
%   T -- The rigid transformation matrix which maps the points in the
%           second set 'S' to the ones in the first set 'M'.
%           T is a 4*4 matrix: [a b c 0; d e f 0; g h i 0;j k l 1], where a, b, c, d, e, f, g, h, i, j, k, l are the unknown parameters
%
% Requirements:
%   At least five pairs of corresponding points are needed.
%
% Long Shuqin
% 2014-11

n = size(M, 2);
if n<4
    error('ERROR: At least five pairs of corresponding points are required');
end

% % 正交投影变化
% A = zeros(3*n, 12);
% b = zeros(3*n, 1);
% m=ones(1,3*n);
% P=diag(m);
% k=1;
% for i = 1:3:3*n
%     if i==52
%       disp(i);
%     end
%     A(i, :) = [S(1, k) 0 0 S(2,k) 0 0 S(3,k) 0 0 1 0 0];
%     A(i+1, :) = [0 S(1, k) 0 0 S(2,k) 0 0 S(3,k) 0 0 1 0];
%     A(i+2, :) = [0 0 S(1, k) 0 0 S(2,k) 0 0 S(3,k) 0 0 1];
%     P(i+2,:)=0;
%     b(i) = M(1, k);
%     b(i+1) = M(2, k);
%     b(i+2)=0;
%     k=k+1;
% end
% M=P*A;
% X = pinv(M'*M)*(M'*b);
% 
% T = [X(1) X(2) X(3) 0;X(4) X(5) X(6) 0;X(7) X(8) X(9) 0;X(10) X(11) X(12) 1];


%% 透视投影变化
A=zeros(2*n,8);
b=zeros(2*n,1);
k=1;
for i=1:2:2*n
A(i,:)=[S(1,k) S(2,k) S(3,k) 1 0 0 0 0];
A(i+1,:)=[0 0 0 0 S(1,k) S(2,k) S(3,k) 1];
b(i)=M(1,k);
b(i+1)=M(2,k);
k=k+1;
end
X= inv(A'*A)*A'*b;
T = [X(1) X(2) X(3) X(4);X(5) X(6) X(7) X(8)];

% %%%%%%%%%%%%%%%%%%  我的 透视投影
% % Inputs:
% %   M -- First set of points, 2*n matrix, each column is a point (x, y)
% %   S -- Second set of points,3*n matrix,each column is a point(x,y,z)
% % 
% % Outputs:
% %   T -- The rigid transformation matrix which maps the points in the
% %           second set 'S' to the ones in the first set 'M'.
% %           T is a 3*4 matrix: [a b c 0; d e f 0; g h i 0;j k l 1], where a, b, c, d, e, f, g, h, i, j, k, l are the unknown parameters
% 
% A = zeros(2*n,11);
% b = zeros(2*n,1);
% for i = 1:n
%     b(2*i-1,1) = M(1,i);
%     b(2*i,1) = M(2,i);
%     A(2*i-1,:) = [S(1,i) S(2,i) S(3,i) 1 0 0 0 0 -M(1,i)*S(1,i) -M(1,i)*S(2,i) -M(1,i)*S(3,i)];
%     A(2*i,:) = [0 0 0 0 S(1,i) S(2,i) S(3,i) 1 -M(2,i)*S(1,i) -M(2,i)*S(2,i) -M(2,i)*S(3,i)];
% end
% 
% X= pinv(A'*A)*A'*b;
% T = [X(1) X(2) X(3) X(4);X(5) X(6) X(7) X(8);X(9) X(10) X(11) 1];
% 
