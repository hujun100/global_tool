function write_list_for_dir(txt_name,img_dir,filter,param)
%To get list for the directory as images, the output is a txt
%   which containing lines with name and label
%input:
%  img_dir    --the root dir for all image
%txt_name:
%  txt_name   --the output list name
%filter
%	      --file_filter as '*.jpg' and so on.
%param.out_format --the output format
%param.name_handle --a function that get label from image name
%param.is_fullpath --if true, the list should contain the directory name
%param.with_label  -- whether to write label to 'txt' file
%param.begin_number -- 
%
%output:
%       the output should be [image_name(1:end-length(filter)+2) out_format]
%
%Jun Hu
%2017-4


fid=fopen(txt_name,'wt');
if nargin<4
  param.with_label=false;
end

img_struct=dir([img_dir filesep filter]);
if strcmp(filter,'')
   img_struct = img_struct(2:end);
end
for i_s=1:length(img_struct)
    output_name=img_struct(i_s).name;
    if isfield(param,'begin_number') 
       label = i_s - 1 + param.begin_number;
    else
       label = i_s - 1;
    end
    if isfield(param,'name_handle')
        label=param.name_handle(output_name);
    end
    if isfield(param,'out_format')
        output_name=[output_name(1:end-length(filter)+2) param.out_format];
    end
    if isfield(param,'is_fullpath') && param.is_fullpath
        output_name=[img_dir filesep output_name];
    end
    if label~=Inf
        if isfield(param,'with_label') && param.with_label
            fprintf(fid,'%s %d\n',output_name,label);
        else
            fprintf(fid,'%s\n',output_name);
        end
    end
end

fclose(fid);
end
