asia = dir('/home/idealsee/face_train_data_needed/sphere_suzhou');
asia = asia(3:end);

do_cut = true; % if the images of a folder is bigger than the cut_number, delete some image to cut_number
cut_number = 500;
cut_fid = fopen('cut_result.txt','wt');

fid = fopen('suzhou_smaller15','wt');
for i = 1:length(asia)
    i
    class = asia(i).name;
    all_imgs = dir([asia(i).folder filesep class '/*.jpg']);
    imgs_len = length(all_imgs);
    if length(all_imgs) <15 
        fprintf(fid,'%s\n',class); 
        continue;
    end
    if do_cut
       if imgs_len>cut_number
            r = randperm(imgs_len);
            for i_c = cut_number:imgs_len
                fprintf(cut_fid,'%s\n', [class filesep all_imgs(r(i_c)).name]);
            end
       end
    end
end
fclose(fid);
fclose(cut_fid);




