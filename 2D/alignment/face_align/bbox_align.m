function bbox_align(face_dir,ffp_dir,save_dir,file_filter,output_format,pts_format,is_continue,is_train, padding_factor)

if nargin<9
   if is_train
     padding_factor = 1.2;
   else
     padding_factor = 1.1;
   end
end

subdir = dir(face_dir);
subdir = subdir(3:end);
for i=1: length(subdir)
    if ~ subdir(i).isdir
        continue;
    end
    fprintf('[%.2f%%] %s\n', 100*i/length(subdir), subdir(i).name);
    pathstr = [save_dir filesep subdir(i).name];
    if exist(pathstr, 'dir')  == 0
        fprintf('create %s\n', pathstr);
        mkdir(pathstr);
    end
    
    img_fns = dir([face_dir filesep subdir(i).name filesep file_filter]);
    for k=1: length(img_fns)
        ffp_fn = [ffp_dir filesep subdir(i).name filesep img_fns(k).name pts_format];
        if is_continue
            if ~exist(ffp_fn, 'file')
                continue;
            end
        end
        img = imread([face_dir filesep subdir(i).name filesep img_fns(k).name]);
        assert(logical(exist(ffp_fn, 'file')),'landmarks should be provided\n');
  
        [aligned_img]=bbox_align_single(img,ffp_fn, padding_factor);
        aligned_img = imresize(aligned_img,[256 256]);
        save_fn = [save_dir filesep subdir(i).name filesep img_fns(k).name];
        imwrite(aligned_img, save_fn);
    end
end
     

