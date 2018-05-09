function feature=extract_feature_single_image(img,img_size,data_key,feature_key,net,preprocess_param,is_gray,norm_type,averageImg)

%the difference betwenn extract_feature_single_image and extract_feature_single is that
%        the input is not the same: one is image,and anthor is the location of the image in disk
%
assert(norm_type<=3,'norm_type should be less than 4 now');
if isfield(preprocess_param,'do_alignment') && preprocess_param.do_alignment
    img_width=size(img,2);
    img_height=size(img,1);
    assert(isfield(preprocess_param,'align_param'),'align_param should be provided\n');
    align_param=preprocess_param.align_param;
    if strcmp(align_param.alignment_type,'lightcnn')
        f5pt(1:5,1)=align_param.facial_point(1:2:9);
        f5pt(1:5,2)=align_param.facial_point(2:2:10);
        [img2, eyec, img_cropped, resize_scale] = align(img, f5pt, 128, 48, 40);
        
        % if doing alignment failed,we use 'bbox' method when bbox exists.
        if resize_scale<0 || resize_scale>100&& length(align_param.facial_point)>10
            
            bbox=align_param.facial_point(11:14);
            if isfield(align_param,'padding_factor')
                [aligned_img]=bbox_alignment(img,bbox,align_param.padding_factor);
            else
                [aligned_img]=bbox_alignment(img,bbox,1);
            end
            img=aligned_img;
        else
            img=img_cropped;
        end
        
    elseif strcmp(align_param.alignment_type,'centerloss')
        imgSize = [112, 96];
        % imgSize=[224 224];
        coord5points = [30.2946, 65.5318, 48.0252, 33.5493, 62.7299; ...
            51.6963, 51.5014, 71.7366, 92.3655, 92.2041];
        %         coord5points = [66, 116, 81, 73, 105; ...
        %             117, 116, 149, 169, 169];
        %         coord5points=coord5points*1.8;
        %         coord5points(1,:)=coord5points(1,:)-40;
        %         coord5points(2,:)=coord5points(2,:)-150;
        
        facial5points(1,1:5)=align_param.facial_point(1:2:9);
        facial5points(2,1:5)=align_param.facial_point(2:2:10);
        Tfm =  cp2tform(facial5points', coord5points', 'similarity');
        cropImg = imtransform(img, Tfm, 'XData', [1 imgSize(2)],...
            'YData', [1 imgSize(1)], 'Size', imgSize);
        %         cropImg = imtransform(img, Tfm, 'XData', [1 imgSize(2)],...
        %             'YData', [1 imgSize(1)], 'Size', imgSize,'FillValues',0);
        
        img=cropImg;
    elseif strcmp(align_param.alignment_type,'bbox')
        
        bbox=align_param.facial_point(11:14);
        
        
        if isfield(align_param,'padding_factor')
            [aligned_img]=bbox_alignment(img,bbox,align_param.padding_factor);
        else
            [aligned_img]=bbox_alignment(img,bbox,1);
        end
        img=aligned_img;
        
    elseif strcmp(align_param.alignment_type, 'brl')

        f5pt(1:5,1)=align_param.facial_point(1:2:9);
        f5pt(1:5,2)=align_param.facial_point(2:2:10);
        
        bbox=align_param.facial_point(11:14);
        if (f5pt(1,1)<f5pt(3,1) && f5pt(2,1)<f5pt(3,1)) || (f5pt(1,1)>f5pt(3,1) && f5pt(2,1)>f5pt(3,1))
            if isfield(align_param,'padding_factor')
                img=bbox_alignment(img,bbox,align_param.padding_factor);
            else
                img=bbox_alignment(img,bbox,1.1);
            end
        else
            img_size_single=img_size(1);
            [~, ~, img, resize_scale] = align(img, f5pt, 128, 48, 40);
            if resize_scale<0 || resize_scale>100
                if isfield(align_param,'padding_factor')
                    img=bbox_alignment(img,bbox,align_param.padding_factor);
                else
                    img=bbox_alignment(img,bbox,1);
                end
            end
        end
    end
end

% % 66 117    116 116    81 149     73 169     108 169
%  if ~isfield(preprocess_param,'do_alignment') || ~preprocess_param.do_alignment ...
%          %just put the image in the center of the aligned image
%          %padding_factor determines the size of the aligned image
%          %img=img(1:end,35:end-35,:);
%          height=size(img,1);
%          width=size(img,2);
%          padding_factor=1;
%          if isfield(preprocess_param,'padding_factor')
%              padding_factor=preprocess_param.padding_factor;
%          end
%          final_size=int32(max(width,height)*padding_factor);
%          data=uint8(ones(final_size,final_size,3)*255);
%          data(int32((final_size-height)/2)+1:int32((final_size-height)/2)+height,...
%              int32((final_size-width)/2)+1:int32((final_size-width)/2)+width,:)= ...
%              img(1:end,1:end,:);
%          img=data;
%  end


%fprintf('img %s\n',[img_dir filesep img_file]);
if norm_type==2
    temp=img;
    if size(img,3)==1
        cropImg(:,:,1)=temp;
        cropImg(:,:,2)=temp;
        cropImg(:,:,3)=temp;
    else
        cropImg = temp;
    end
    if sum(abs(size(cropImg) - [118, 102, 3])) == 0
        cropImg = cropImg(3:114, 3:98,:);
    elseif sum(abs(img_size - [112, 112])) == 0
        temp = zeros([112,112,3]);
        temp(:, 8:8+95,:) = cropImg;
        cropImg = temp;
    else
        cropImg=imresize(cropImg,img_size);
    end
    cropImg = single(cropImg);
    cropImg = (cropImg - 127.5)/128;
    cropImg = permute(cropImg, [2,1,3]);
    cropImg = cropImg(:,:,[3,2,1]);
    
    cropImg_(:,:,1) = flipud(cropImg(:,:,1));
    cropImg_(:,:,2) = flipud(cropImg(:,:,2));
    cropImg_(:,:,3) = flipud(cropImg(:,:,3));
    
    % extract deep feature
    net.blobs(data_key).set_data(cropImg);
    net.forward_prefilled();
    res = net.blobs(feature_key).get_data();
%     net.blobs(data_key).set_data(cropImg_);
%     net.forward_prefilled();
%     res_=net.blobs(feature_key).get_data();
%     feature = [res; res_];
    feature = res;
%    feature = res + res_;
else
    if is_gray
        if size(img,3)==3
            img=uint8(img);
            %img = img(:,:,3);
            img=rgb2gray(img);
        end
    else
        if size(img,3)<3
            img(:,:,2)=img(:,:,1);
            img(:,:,3)=img(:,:,1);
        end
        img = img(:, :, [3, 2, 1]); % convert from RGB to BGR
    end
    
    img=imresize(img,img_size);
    if is_gray
        img=img';
    else
        img = permute(img, [2, 1, 3]); % permute width and height
    end
    
    if is_gray
        data = zeros(img_size(2),img_size(1),1,1);
        data = single(data);
        if norm_type==0
            data(:,:,:,1) = ((single(img) - 1)/255.0);
        elseif norm_type==1
            data(:,:,:,1) = (single(img)-averageImg(1));
        elseif norm_type==2
            data(:,:,:,1)=(single(img)-127.5)/128.0;
        elseif norm_type==3
            data(:,:,:,1) = (single(img)-averageImg(1))*0.017;
        end
    else
        data = zeros(img_size(2),img_size(1),3,1);
        data = single(data);
        if norm_type==0
            data(:,:,1,1) = (single(img(:,:,1))/255.0);
            data(:,:,2,1) = (single(img(:,:,2))/255.0);
            data(:,:,3,1) = (single(img(:,:,3))/255.0);
        elseif norm_type==1
            img=single(img);
            img = cat(3,img(:,:,1)-averageImg(3),...
                img(:,:,2)-averageImg(2),...
                img(:,:,3)-averageImg(1));
            data(:,:,1,1) = (single(img(:,:,1)));
            data(:,:,2,1) = (single(img(:,:,2)));
            data(:,:,3,1) = (single(img(:,:,3)));
        elseif norm_type==2
            data(:,:,1,1) = (single(img(:,:,1))-127.5)/128.0;
            data(:,:,2,1) = (single(img(:,:,2))-127.5)/128.0;
            data(:,:,3,1) = (single(img(:,:,3))-127.5)/128.0;
        elseif norm_type==3
            img=single(img);
            img = cat(3,img(:,:,1)-averageImg(3),...
                img(:,:,2)-averageImg(2),...
                img(:,:,3)-averageImg(1));
            data(:,:,1,1) = (single(img(:,:,1)));
            data(:,:,2,1) = (single(img(:,:,2)));
            data(:,:,3,1) = (single(img(:,:,3)));
            data = data*0.017;
        end
    end
    
    net.blobs(data_key).set_data(data);
    net.forward_prefilled();
    feature=net.blobs(feature_key).get_data();
    feature=squeeze(feature);
end

end

%bounding box alignment method
function [aligned_img]=bbox_alignment(img,bbox,padding_factor)

img_width=size(img,2);
img_height=size(img,1);
center=bbox(1:2)+bbox(3:4)/2;
width_height=bbox(3:4); %first element is width
square_size=int32(max(width_height)*padding_factor);
width=square_size;height=square_size;
left_top=int32(center-single(square_size)/2);
%         r=rectangle('Position',[bbox(1,1:2) width_height],'Edgecolor','g','LineWidth',3);
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

end

%lightcnn's code.
function [res, eyec2, cropped, resize_scale] = align(img, f5pt, crop_size, ec_mc_y, ec_y)
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
cropped = img_crop;
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
