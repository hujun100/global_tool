function ID_file_map = get_ID_file_map(ffp)
%%%%%% get_template_ID and file mapping for IJB-A
cou = 0;
fid = fopen(ffp);
tline = fgetl(fid);
all_ids = [];
all_files = {};
while 1
    cou = cou + 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end;
    line_split = regexp(tline, ',', 'split');
    
    all_ids = [all_ids str2double(line_split{1})] ;
    all_files = [all_files line_split{3}];
end
[result, ia, ic] = unique(all_ids);
ID_file_map = cell(length(result) , 2);
for i_r = 1:length(result)
    ID_file_map{i_r, 1} = result(i_r);
end
for i_a = 1:length(all_files)
    %% the stored map between template ID and image file name
    ID_file_map{ic(i_a),2} = [ID_file_map{ic(i_a), 2} all_files(i_a)];
end

end
