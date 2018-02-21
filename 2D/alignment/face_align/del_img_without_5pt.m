function del_img_without_5pt(root_dir, filter, param)
%
%
%
if nargin<2
    filter = '*.jpg';
    param = [];
end
filter_split = regexp(filter,'\.','split')
filter_len = length(filter_split{2});

if isfield(param,'has_sub_dir') && param.has_sub_dir
    
    all_folder = dir(root_dir);
    all_folder = all_folder(3:end);
    for i_a = 1:length(all_folder)
        i_a
        folder = all_folder(i_a).name;
        all_imgs = dir([all_folder(i_a).folder filesep folder filesep filter]);
        
        for i = 1:length(all_imgs)
%             i
            img_name = all_imgs(i).name;
            pt5_name = [img_name(1:end -filter_len) '5pt'];
            if ~exist([all_imgs(i).folder filesep pt5_name],'file')
                delete([all_imgs(i).folder filesep img_name]);
            end
        end
        
    end
    
else
    all_imgs = dir([root_dir filesep filter]);
    for i = 1:length(all_imgs)
        i
        img_name = all_imgs(i).name;
        pt5_name = [img_name(1:end -filter_len) '5pt'];
        if ~exist([root_dir filesep pt5_name],'file')
            delete([root_dir filesep img_name]);
        end
    end
    
end

end
