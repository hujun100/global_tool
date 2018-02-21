ffp='facescrub_actors.txt';
actors_map = get_name_bbox_map(ffp);
ffp = 'facescrub_actresses.txt';
actresses_map = get_name_bbox_map(ffp);

function name_bbox_map = get_name_bbox_map(ffp)


fid = fopen(ffp);
tline = fgetl(fid);
count=0;
name_bbox_map = containers.Map;
while 1
    count = count + 1
    tline = fgetl(fid);
    if ~ischar(tline), break,end;
    tline_split = regexp(tline,'\t','split');
    name = [tline_split{1} filesep tline_split{1} '_' num2str(count) '.jpg'];
    name1 = [tline_split{1} filesep tline_split{1} '_' num2str(count)];
    name2 = [tline_split{1} filesep tline_split{1} '_' num2str(count) '.jpeg'];
    name3 = [tline_split{1} filesep tline_split{1} '_' num2str(count) '.png'];
    name4 = [tline_split{1} filesep tline_split{1} '_' num2str(count) '.JPG'];
    name5 = [tline_split{1} filesep tline_split{1} '_' num2str(count) '.PNG'];
    name6 = [tline_split{1} filesep tline_split{1} '_' num2str(count) '.gif'];
    bbox_str = tline_split{5};
    bbox_split = regexp(bbox_str,',','split');
    if count == 40499
        
    end
    for i_b = 1:4
        bbox(i_b) = str2double(bbox_split{i_b});
    end
    bbox(3:4) = bbox(3:4) - bbox(1:2);
    name_bbox_map(name) = bbox;
    name_bbox_map(name1) = bbox;
    name_bbox_map(name2) = bbox;
    name_bbox_map(name3) = bbox;
    name_bbox_map(name4) = bbox;
    name_bbox_map(name5) = bbox;
    name_bbox_map(name6) = bbox;
end

fclose(fid);
end