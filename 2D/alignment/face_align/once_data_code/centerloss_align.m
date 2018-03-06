function centerloss_align(face_dir,ffp_dir,save_dir,file_filter,pts_format,conf_threshold,is_continue, is_train)

subdir = dir(face_dir);
subdir = subdir(3:end);
for i=1: length(subdir)
    if ~subdir(i).isdir
        continue;
    end
    fprintf('[%.2f%%] %s\n', 100*i/length(subdir), subdir(i).name);
    
    img_fns = dir([face_dir filesep subdir(i).name filesep file_filter]);
    for k=1: length(img_fns)
        
        
        save_fn = [save_dir filesep subdir(i).name filesep img_fns(k).name(1:end)];
        if exist(save_fn, 'file')
            continue;
        end
        
        img = imread([face_dir filesep subdir(i).name filesep img_fns(k).name]);
        ffp_fn = [ffp_dir filesep subdir(i).name filesep img_fns(k).name(1:end) '.' pts_format];
        if is_continue
            if ~exist(ffp_fn, 'file')
                continue;
            end
        end
        
        pathstr = [save_dir filesep subdir(i).name];
        if exist(pathstr, 'dir')  == 0
            fprintf('create %s\n', pathstr);
            mkdir(pathstr);
        end
        
        assert(logical(exist(ffp_fn, 'file')),'landmarks should be provided\n');
        try
            [img_cropped, conf]=centerloss_align_single(img,ffp_fn, is_train);
        catch
            continue;
        end
        if conf< conf_threshold
            continue;
        end
        
        imwrite(img_cropped, save_fn);
    end
end

end


