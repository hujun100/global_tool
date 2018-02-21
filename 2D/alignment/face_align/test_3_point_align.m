clear;
img_name = '/home/scw4750/Dataset/BRL/img_frame/glass_jpg/F0001_01_01_030.jpg';
img = imread(img_name);
facial_point = read_5pt([img_name(1:end-3) '5pt']);

imgSize = [112, 96];

coord5points = [30.2946, 65.5318, 48.0252, 33.5493, 62.7299; ...
    51.6963, 51.5014, 71.7366, 92.3655, 92.2041];
coord5points = coord5points(:, 1:3);
facial5points = facial_point(1:3,:)';
% facial5points = facial_point';
Tfm =  cp2tform(facial5points', coord5points', 'similarity');
img_cropped = imtransform(img, Tfm, 'XData', [1 imgSize(2)],...
    'YData', [1 imgSize(1)], 'Size', imgSize);
imshow(img_cropped)
