
root_dir = '/home/scw4750/Dataset/huochezhan/21_CDWRWS_Passenger';
output_gal_dir = '/home/scw4750/Dataset/huochezhan/v1/gallery';
output_pro_dir = '/home/scw4750/Dataset/huochezhan/v1/probe';
all_sub_dir = dir(root_dir);
all_sub_dir = all_sub_dir(3:end);
for i_s = 1:length(all_sub_dir)
    i_s
    sub_dir = all_sub_dir(i_s).name;
    all_imgs = dir([root_dir filesep sub_dir filesep '*.jpg']);
    all_imgs_len = length(all_imgs);
    if all_imgs_len <= 1
        continue;
    end
    if all_imgs_len>=7
        r = randperm(all_imgs_len);
        %%%% gallery
        index = r(1);
        gal_source_file = [all_imgs(index).folder filesep all_imgs(index).name];
        output_sub_dir =[output_gal_dir filesep sub_dir];
        if ~exist(output_sub_dir,'dir')
            mkdir(output_sub_dir);
        end
        gal_des_file = [output_sub_dir filesep all_imgs(index).name];
        copyfile(gal_source_file, gal_des_file);
        copyfile([gal_source_file(1:end-3) '5pt'], [gal_des_file(1:end-3) '5pt']);
        for i = 2:7
            index = r(i);
            pro_source_file = [all_imgs(index).folder filesep all_imgs(index).name];
            output_sub_dir = [output_pro_dir filesep sub_dir];
            if ~exist(output_sub_dir, 'dir')
                mkdir(output_sub_dir);
            end
            pro_des_file = [output_sub_dir filesep all_imgs(index).name];
            copyfile(pro_source_file, pro_des_file);
            copyfile([pro_source_file(1:end-3) '5pt'], [pro_des_file(1:end-3) '5pt']);
        end
    else
        continue;
    end
end
