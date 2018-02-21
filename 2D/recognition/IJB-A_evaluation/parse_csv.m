function [all_files_name, all_labels, all_template_id] = parse_csv(csv_ffp)

all_files_name = {};
all_labels = [];
all_template_id = [];
fid = fopen(csv_ffp);
fgetl(fid);
while 1
    tline = fgetl(fid);
    if ~ischar(tline), break ,end;
    tline_split = regexp(tline,',','split');
    file_path = tline_split{3};
    file_path = strrep(file_path,filesep,'_');
    file_path_split = regexp(file_path,'\.','split');
    file_name = [tline_split{1} '_' tline_split{2} filesep file_path_split{1} '.jpg'];
    all_files_name = [all_files_name file_name];
    all_labels = [all_labels str2double(tline_split{2})];
    all_template_id = [all_template_id str2double(tline_split{1})];
end

fclose(fid);
end
