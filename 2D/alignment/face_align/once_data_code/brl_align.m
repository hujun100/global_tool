function brl_align(face_dir,ffp_dir,save_dir,file_filter,output_format,pts_format,is_continue,is_train)

if is_train
    imgSize = [144, 144];
else
    imgSize=[128,128];
end

subdir = dir(face_dir);
subdir = subdir(3:end);
for i=1: length(subdir)
    if ~ subdir(i).isdir
        continue;
    end
    fprintf('[%.2f%%] %s\n', 100*i/length(subdir), subdir(i).name);
    pathstr = [save_dir filesep subdir(i).name];
    if exist(pathstr, 'dir')  == 0
        fprintf('create %s\n', pathstr);
        mkdir(pathstr);
    end
    
    img_fns = dir([face_dir filesep subdir(i).name filesep file_filter]);
    for k=1: length(img_fns)
        img = imread([face_dir filesep subdir(i).name filesep img_fns(k).name]);
        ffp_fn = [ffp_dir filesep subdir(i).name filesep img_fns(k).name(1:end-3) pts_format];
        if is_continue
            if ~exist(ffp_fn, 'file')
                continue;
            end
        end
        assert(logical(exist(ffp_fn, 'file')),'landmarks should be provided\n');
        f5pt = read_5pt(ffp_fn);
        %% If pose is so large or pts is wrong, we use bbox alignment. Otherwise, using lightcnn alignment method. 
        if (f5pt(1,1)<f5pt(3,1) && f5pt(2,1)<f5pt(3,1)) || (f5pt(1,1)>f5pt(3,1) && f5pt(2,1)>f5pt(3,1))
            img_cropped=bbox_align_base(ffp_fn,img,imgSize,is_train);
        else
            if is_train
                img_size=imgSize(1);
                [img2, eyec, img_cropped, resize_scale] = ligntcnn_align(img, f5pt, img_size, 48, 48);
            else
                img_size=imgSize(1);
                [img2, eyec, img_cropped, resize_scale] = ligntcnn_align(img, f5pt, img_size, 48, 40);
            end
            if resize_scale<0 || resize_scale>100
                if is_continue
                    continue;
                end
            end          
        end
        img_cropped = imresize(img_cropped, [img_size img_size], 'Method', 'bicubic');   
        save_fn = [save_dir filesep subdir(i).name filesep img_fns(k).name(1:end-3) output_format];
        imwrite(img_cropped, save_fn);
    end
end

end

function aligned_img=bbox_align_base(ffp_fn,img,imgSize,is_train)

fid=fopen(ffp_fn,'rt');
facial_point=textscan(fid,'%f');
facial_point=facial_point{1};
fclose(fid);

bbox(1)=facial_point(11); %left-top x
bbox(2)=facial_point(12); %left-top y
bbox(3)=facial_point(13); %width
bbox(4)=facial_point(14); %height

img_width=size(img,2);
img_height=size(img,1);
center=bbox(1:2)+bbox(3:4)/2;
if is_train
    padding_factor=1.2;
else
    padding_factor=1.1;
end
square_size=int32(max(bbox(3:4))*padding_factor);
width=square_size;height=square_size;
left_top=int32(center-single(square_size)/2);

left_top(left_top<1)=1;
if left_top(1)+square_size>img_width
    width=img_width-left_top(1);
end
if left_top(2)+square_size>img_height
    height=img_height-left_top(2);
end
assert(width>0,'bbox is wrong');
assert(height>0,'bbox is wrong');

aligned_img=img(left_top(2):left_top(2)+height,left_top(1):left_top(1)+width,:);
aligned_img=imresize(aligned_img,imgSize);
end

function img_cropped=centerloss_align_base(ffp_fn,img,imgSize,is_train)  

        fid=fopen(ffp_fn,'rt');
        facial_point=textscan(fid,'%f');
        facial_point=facial_point{1};
        fclose(fid);
        
        coord5points = [30.2946, 65.5318, 48.0252, 33.5493, 62.7299; ...
            51.6963, 51.5014, 71.7366, 92.3655, 92.2041];
        if is_train
            coord5points(1,1:5)=coord5points(1,1:5)*144/96;
            coord5points(2,1:5)=coord5points(2,1:5)*144/112;
        else
            coord5points(1,1:5)=coord5points(1,1:5)*128/96;
            coord5points(2,1:5)=coord5points(2,1:5);  
            coord5points(2,1:5)=coord5points(2,1:5)*128/112;           
        end
        facial5points(1,1:5)=facial_point(1:2:9);
        facial5points(2,1:5)=facial_point(2:2:10);
        Tfm =  cp2tform(facial5points', coord5points', 'similarity');
        img_cropped = imtransform(img, Tfm, 'XData', [1 imgSize(2)],...
            'YData', [1 imgSize(1)], 'Size', imgSize);

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

function [res, eyec2, cropped, resize_scale] = ligntcnn_align(img, f5pt, crop_size, ec_mc_y, ec_y)
f5pt = double(f5pt);
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
