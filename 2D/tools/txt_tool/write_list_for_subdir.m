function write_list_by_subdir(txt_name,img_dir,filter,param)
%To get list for the directory as  sub_dir/images, the output is a txt
%   which containing lines with name and label
%input:
%  img_dir    --the root dir for all image
%txt_name:
%  txt_name   --the output list name
%filter
%	      --file_filter as '*.jpg' and so on.
%param.out_format --the output format
%param.dir_handle --a function that get label from subdirectory
%param.name_handle --a function taht get label from image name
%param.is_fullpath --if true, the list should contain the directory name
%param.with_label  -- whether to write label to 'txt' file
%param.begin_number -- 
%
%output:
%    if param.is_fullpath is true,
%          then the output should be [ sub_dir/image_name(1:end-length(filter)+2) out_format] and label
%    otherwise,[image_name(1:end-length(filter)+2) out_format]
%
%Jun Hu
%2017-4
if nargin<=3
   param.with_label = false;  
end

fid=fopen(txt_name,'wt');
img_struct=dir(img_dir);
img_struct=img_struct(3:end);
%%% if there is empty folder
empty_folder_count = 0;
for i=1:length(img_struct)
    if isfield(param,'dir_handle')
        label=param.dir_handle(img_struct(i).name);
    else
    if isfield(param,'begin_number') 
       label = i - 1 + param.begin_number - empty_folder_count;
    else
       label = i - 1 - empty_folder_count;
    end

    end
    sub_img_struct=dir([img_dir filesep img_struct(i).name filesep filter]);
    if strcmp(filter,'')
        sub_img_struct = sub_img_struct(3:end);
    end
    if length(sub_img_struct) == 0
        empty_folder_count = empty_folder_count + 1;
    end
    for i_s=1:length(sub_img_struct)
        output_name=sub_img_struct(i_s).name;
        if isfield(param,'name_handle')
            label=param.name_handle(output_name);
        end
        if isfield(param,'out_format')
            output_name=[output_name(1:end-length(filter)+2) param.out_format];
        end
        output_name=[img_struct(i).name filesep output_name];
        if isfield(param,'is_fullpath') && param.is_fullpath
            output_name=[img_dir filesep output_name];
        end
        if label~=Inf
            %fprintf(fid,'%s %d\n',output_name,label);
            if isfield(param,'with_label') && param.with_label
                fprintf(fid,'%s %d\n',output_name,label);
            else
                fprintf(fid,'%s\n',output_name);
            end
        end
    end
end
fclose(fid);
end
