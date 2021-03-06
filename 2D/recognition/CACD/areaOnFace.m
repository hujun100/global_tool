clear;clc;

% %%show area on face
% data = importdata('/home/brl/TRAIN/DataSet/CACD/txt/cacd_5pt_list_without_5pt.txt');
% data_dir = '/home/brl/TRAIN/DataSet/CACD/DATA/AlignedCACD';
% img_path = fullfile(data_dir, data{10});
% img = imread(img_path);
% [lm, ~] = read_5pt([img_path '.5pt']);
% imshow(img);hold on;
% plot(lm(:,1),lm(:,2),'.r', 'LineWidth',3);
% bbox = [lm(1, 1)-15, lm(1, 2) - 10, 70, 20];
% rectangle('Position', bbox, 'edgecolor', 'g');

%%preprocess area on face on test dataset
data = importdata('/home/brl/TRAIN/DataSet/CACD/DATA/AlignedCACD_VS/cacd_vs_list.txt');
data_dir = '/home/brl/TRAIN/DataSet/CACD/DATA/AlignedCACD_VS/CACD_VS';
out_dir = '/home/brl/TRAIN/DataSet/CACD/DATA/AlignedCACD_VS/CACD_VS_without_eye_area';
for i = 1:length(data)
    img_path = fullfile(data_dir, data{i});
    img = imread(img_path);
    try
      [lm, ~] = read_5pt([img_path '.5pt']);
    catch
        i
      lm = [30.2946, 65.5318, 48.0252, 33.5493, 62.7299; ...
    51.6963, 51.5014, 71.7366, 92.3655, 92.2041]' + 3;
    end
    lm = int8(lm);
    % imshow(img);hold on;
    % plot(lm(:,1),lm(:,2),'.r', 'LineWidth',3);
%     eye_area_img = img(lm(1, 2) - 10: lm(1, 2) + 9, lm(1, 1)-15:lm(1, 1) +54,:);
%     imwrite(eye_area_img, fullfile(out_dir, data{i}));
    img(lm(1, 2) - 10: lm(1, 2) + 9, lm(1, 1)-15:lm(1, 1) +54,:) = 0;
    img_without_eye_area = img(4:115,4:99,:);
    imwrite(img_without_eye_area, fullfile(out_dir, data{i}));

    % rectangle('Position', bbox, 'edgecolor', 'g');
end