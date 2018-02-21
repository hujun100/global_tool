
wrote_root_dir = '/home/scw4750/Dataset/IJB-A/template_subject_id';
img_dir = '/home/scw4750/Dataset/IJB-A';
for i = 1:10
    i_str = num2str(i);
    csv_file = ['/home/scw4750/Dataset/IJB-A/IJB-A_1N_sets/split' i_str '/search_gallery_' i_str '.csv'];
    write_template_subject_id_from_csv(csv_file,...
        img_dir, wrote_root_dir);
    csv_file = ['/home/scw4750/Dataset/IJB-A/IJB-A_1N_sets/split' i_str '/search_probe_' i_str '.csv'];
    write_template_subject_id_from_csv(csv_file,...
        img_dir, wrote_root_dir);
end

for i = 1:10
    i_str = num2str(i);
    csv_file = ['/home/scw4750/Dataset/IJB-A/IJB-A_11_sets/split' i_str '/verify_metadata_' i_str '.csv'];
    write_template_subject_id_from_csv(csv_file,...
        img_dir, wrote_root_dir);
end


function write_template_subject_id_from_csv(csv_ffp, img_dir,wrote_root_dir)

fid = fopen(csv_ffp);
fgetl(fid);

bbox_factor = 1.5;
count = 0;
while 1
    count = count + 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end;
    tline_split = regexp(tline, ',','split');
    template_subject_name = [tline_split{1} '_' tline_split{2}];
    
    img_file = tline_split{3};
    img = imread([img_dir filesep img_file]);
    img_file_split = regexp(img_file, '\.','split');
    output_img_name = [img_file_split{1} '.jpg'];
    output_img_name = strrep(output_img_name, filesep, '_');

    wrote_dir = [wrote_root_dir filesep template_subject_name];
    
    if ~exist(wrote_dir,'dir')
        mkdir(wrote_dir);
    end
    output_file = [wrote_dir filesep output_img_name];
    if ~exist(output_file,'file')
        bbox_str = tline_split(7:10);
        bbox = int32(str2double(bbox_str));
        align_bbox = get_align_bbox(img, bbox, bbox_factor);
        imwrite(img(align_bbox(2):align_bbox(2)+align_bbox(4), align_bbox(1):align_bbox(1)+align_bbox(3),:),...
            [wrote_dir filesep output_img_name]);
    end
    pts_file =[output_file(1:end-3) 'bbox'];
    if ~exist(pts_file,'file')
        pts_fid = fopen(pts_file,'wt');
        fprintf(pts_fid,'%d %d %d %d\n', bbox(1)-align_bbox(1),bbox(2)-align_bbox(2),bbox(3),bbox(4));
        fclose(pts_fid);
    end
end

end
%
% function write_template_subject_id(all_info, img_dir, img_prefix)
%
% % all_frames = dir();
% all_frames = dir(img_dir);
% all_frames = all_frames(17:end);
% all_names = all_info(:, 3);
% root_dir = '/home/scw4750/Dataset/IJB-A';
% wrote_root_dir = '/home/scw4750/Dataset/IJB-A/template_subject_id_bbox';
% bbox_factor = 0.9;
% cou = 0;
% for i = 1:length(all_frames)
%     i
%     %     name = ['img' filesep all_frames(i).name];
%     name = [img_prefix filesep all_frames(i).name];
%     idx = find(strcmp(all_names, name));
%     img = imread([root_dir filesep name]);
%     for i_i = 1:length(idx)
%         cou = cou + 1;
%         template_subject_name = [all_info{idx(i_i),1} '_' all_info{idx(i_i),2}];
%         bbox_str = all_info(idx(i_i),7:10);
%         bbox = int32(str2double(bbox_str));
%         align_bbox = get_align_bbox(img, bbox, bbox_factor);
%         wrote_dir = [wrote_root_dir filesep template_subject_name];
%         if ~exist(wrote_dir,'dir')
%             mkdir(wrote_dir);
%         end
%         imwrite(img(align_bbox(2):align_bbox(2)+align_bbox(4), align_bbox(1):align_bbox(1)+align_bbox(3),:),...
%             [wrote_dir filesep all_frames(i).name]);
%     end
% end
% end
