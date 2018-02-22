function [img_cropped, conf]=centerloss_align_single(img,ffp_fn, is_train)

imgSize = [112, 96];
if is_train
    imgSize = imgSize + 6;
end
fid=fopen(ffp_fn,'rt');
facial_point=textscan(fid,'%f');
facial_point=facial_point{1};
conf = facial_point(15);
fclose(fid);

coord5points = [30.2946, 65.5318, 48.0252, 33.5493, 62.7299; ...
    51.6963, 51.5014, 71.7366, 92.3655, 92.2041];
if is_train
    coord5points = coord5points + 3;
end
facial5points(1,1:5)=facial_point(1:2:9);
facial5points(2,1:5)=facial_point(2:2:10);
Tfm =  cp2tform(facial5points', coord5points', 'similarity');
img_cropped = imtransform(img, Tfm, 'XData', [1 imgSize(2)],...
    'YData', [1 imgSize(1)], 'Size', imgSize);

end
