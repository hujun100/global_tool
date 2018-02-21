function [pts, bbox] = read_5pt(ffp_fn)
%pts:
%  size:2*5
%  [left-eye-center-x  right-eye-center-x  nose-x   left-mouse-center-x right-mouse-center-x
%   left-eye-center-y  right-eye-center-y  nose-y   left-mouse-center-y right-mouse-center-y]
%bbox:
%  left-upper-x left-upper-y height width
%
%%%%% old version

fid=fopen(ffp_fn,'rt');
facial_point=textscan(fid,'%f');
facial_point=facial_point{1};
fclose(fid);
pts = zeros(2,5);
pts(1,1:5)=facial_point(1:2:9);
pts(2,1:5)=facial_point(2:2:10);
bbox =facial_point(11:14);

pts = pts';
%%%%%% end

end
