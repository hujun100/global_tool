left_dir = '/home/scw4750/Dataset/huochezhan/railway_evaluation/v1/gallery';
right_dir = '/home/scw4750/Dataset/huochezhan/railway_evaluation/v2/gallery';
txt_dir = '/home/scw4750/Dataset/huochezhan/railway_evaluation/similarity_txt';
output_dir = '/home/scw4750/Dataset/huochezhan/railway_evaluation/similarity_img';
all_txts = dir(txt_dir);
all_txts = all_txts(3:end);
for i_t = 1:length(all_txts)
    i_t
    txt = all_txts(i_t).name;
    data = importdata([txt_dir filesep txt]);
    if isempty(data)
        continue;
    end
    img_pairs = data.textdata;
    similarity = data.data;
    img_pairs_len = length(similarity);
    if img_pairs_len > 4
        img_pairs_len = 4;
    end
    for i_s = 1:img_pairs_len
        if similarity(i_s)<90
            continue;
        end
        left_img = imread([left_dir filesep img_pairs{i_s,1}]);
        right_img = imread([right_dir filesep img_pairs{i_s,2}]);
        subplot(img_pairs_len, 2, i_s*2-1);
        imshow(left_img);
        subplot(img_pairs_len, 2, i_s*2);
        imshow(right_img);
    end
%     output_name = [txt(1:end-3) 'jpg'];
%     output_file = [output_dir filesep output_name];
%     print('-djpeg', output_file);
%     close all;
end