function [aligned_img]=bbox_align_single(img,ffp_fn,padding_factor)
if nargin<3
    padding_factor=1;
end

fid=fopen(ffp_fn,'rt');
facial_point=textscan(fid,'%f');
facial_point=facial_point{1};

assert(length(facial_point)>=14,'bbox should be provide\n');
fclose(fid);

bbox=facial_point(11:14);

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
aligned_img = imresize(aligned_img,[256,256]);

end

