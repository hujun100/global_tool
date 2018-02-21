function cropped= lightcnn_align_single(img, f5pt, crop_size, ec_mc_y, ec_y)
if nargin <3
    crop_size=128;
    ec_mc_y=48;
    ec_y=40;
end
if strcmp(class(f5pt),'char')
  f5pt = read_5pt(f5pt);
  f5pt = double(f5pt);
end
ang_tan = (f5pt(1,2)-f5pt(2,2))/(f5pt(1,1)-f5pt(2,1));
ang = atan(ang_tan) / pi * 180;
img_rot = imrotate(img, ang, 'bicubic');
imgh = size(img,1);
imgw = size(img,2);

% eye center
x = (f5pt(1,1)+f5pt(2,1))/2;
y = (f5pt(1,2)+f5pt(2,2))/2;
% x = ffp(1);
% y = ffp(2);

ang = -ang/180*pi;
%{
x0 = x - imgw/2;
y0 = y - imgh/2;
xx = x0*cos(ang) - y0*sin(ang) + size(img_rot,2)/2;
yy = x0*sin(ang) + y0*cos(ang) + size(img_rot,1)/2;
%}
[xx, yy] = transform(x, y, ang, size(img), size(img_rot));
eyec = round([xx yy]);
x = (f5pt(4,1)+f5pt(5,1))/2;
y = (f5pt(4,2)+f5pt(5,2))/2;
[xx, yy] = transform(x, y, ang, size(img), size(img_rot));
mouthc = round([xx yy]);

resize_scale = ec_mc_y/(mouthc(2)-eyec(2));
assert(resize_scale>0 && resize_scale<100,'resize_scale should be in range');
if resize_scale<0 || resize_scale>100
    res=0;%no meaning
    eyec2=0;%no meaning
    cropped=zeros(crop_size,crop_size,size(img,3));
    return;
end

img_resize = imresize(img_rot, resize_scale);


res = img_resize;
%hujun why?
eyec2 = (eyec - [size(img_rot,2)/2 size(img_rot,1)/2]) * resize_scale + [size(img_resize,2)/2 size(img_resize,1)/2];
eyec2 = round(eyec2);
img_crop = zeros(crop_size, crop_size, size(img_rot,3));
% crop_y = eyec2(2) -floor(crop_size*1/3);
crop_y = eyec2(2) - ec_y;
crop_y_end = crop_y + crop_size - 1;
crop_x = eyec2(1)-floor(crop_size/2);
crop_x_end = crop_x + crop_size - 1;

box = guard([crop_x crop_x_end crop_y crop_y_end], size(img_resize,2),size(img_resize,1));
img_crop(box(3)-crop_y+1:box(4)-crop_y+1, box(1)-crop_x+1:box(2)-crop_x+1,:) = img_resize(box(3):box(4),box(1):box(2),:);

% img_crop = img_rot(crop_y:crop_y+img_size-1,crop_x:crop_x+img_size-1);
cropped = img_crop/255;
end

function r = guard(x, Nx,Ny)
x(x<1)=1;
if x(1)>Nx
    x(1)=Nx;
end
if x(2)>Nx
    x(2)=Nx;
end
if x(3)>Ny
    x(3)=Ny;
end
if x(4)>Ny
    x(4)=Ny;
end
r = x;
end

function [xx, yy] = transform(x, y, ang, s0, s1)
% x,y position
% ang angle
% s0 size of original image
% s1 size of target image

x0 = x - s0(2)/2;
y0 = y - s0(1)/2;
xx = x0*cos(ang) - y0*sin(ang) + s1(2)/2;
yy = x0*sin(ang) + y0*cos(ang) + s1(1)/2;
end

function res = read_5pt(fn)
fid = fopen(fn, 'r');
raw = textscan(fid, '%f %f');
fclose(fid);
res = [raw{1} raw{2}];
% fid = fopen(fn, 'r');
% raw = textscan(fid, '%f;');
% raw=raw{1};
% fclose(fid);
% res(1:5,1)=raw(1:5);
% res(1:5,2)=raw(6:10);
end
