folder = dir('result_zhao');
folder = folder(3:end);
source_dir = 'faces';
des_dir = 'result_zhao';
for i = 1:length(folder)
    i
    all_imgs  = dir([folder(i).folder filesep folder(i).name filesep '*.jpg']);
    for i_a = 1:length(all_imgs)
        fprintf('i:%d   i_a:%d\n', i, i_a);
        img_name = all_imgs(i_a).name;
        idx = find(strcmp(all_reg_ID, img_name));
        all_corres = correspond_bro{idx};
        for i_c = 1:length(all_corres)
            corres_name = all_corres{i_c};
            source_file =  [source_dir filesep corres_name];
            des_file = [folder(i).folder filesep folder(i).name filesep corres_name];
            copyfile(source_file, des_file);
        end
    end
end