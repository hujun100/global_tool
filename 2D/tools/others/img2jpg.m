img_dir = '/home/scw4750/Dataset/IJB-A/img';
output_dir = '/home/scw4750/Dataset/IJB-A/img_jpg';

img2jpg_single(img_dir, output_dir);

function img2jpg_single(img_dir,output_dir)

all_imgs = dir(img_dir);
for i = 1:length(all_imgs)
    i
    img_file = all_imgs(i).name;
    if strcmp(img_file(1),'.')
        continue;
    end
    
    img = imread([img_dir filesep img_file]);
    img_file_split = regexp(img_file, '\.','split');
    if strcmp(img_file_split{2}, 'txt')
        continue;
    end
    output_file = [output_dir filesep img_file_split{1} '.jpg'];
    imwrite(img,output_file);
end

end