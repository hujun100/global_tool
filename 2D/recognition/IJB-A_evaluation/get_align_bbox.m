function align_bbox = get_align_bbox(img, bbox, padding_factor)
%%%% get bbox alignment's (x,y,w,h)
%%%%
img_width=size(img,2);
img_height=size(img,1);
center=bbox(1:2)+bbox(3:4)/2;
width_height=bbox(3:4); %first element is width
square_size=int32(max(width_height)*padding_factor);
width=square_size;height=square_size;
left_top=int32(single(center)-single(square_size)/2);
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

align_bbox = [left_top(1) left_top(2) width height];
end