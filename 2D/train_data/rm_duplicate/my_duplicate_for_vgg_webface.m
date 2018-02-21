clear;
fid = fopen('/media/idealsee/小熊U盘/FaceDatasets-master/VGGFace2/vggface2_identity_trans.csv');
count = 1;
while 1
    line = fgetl(fid);
    if ~ischar(line), break, end
    idx = strfind(line, '"');
    vgg{count, 1} = line(1:7);
    vgg{count, 2} = line(idx(1)+1:idx(2)-1);
    count = count + 1;
end
fclose(fid);

fid = fopen('/media/idealsee/小熊U盘/FaceDatasets-master/CASIA/webface_id_name_list.txt');
webface = textscan(fid,'%d %s');
webface_id = webface{1};
webface_name = webface{2};
fclose(fid);

fid = fopen('inte.txt','wt');
inte = intersect(vgg(:,2), webface_name);
for i = 1:length(inte)
    i
    vgg_idx = find(strcmp(vgg(:,2), inte{i})); 
    vgg_idx = vgg_idx(1);
    wf_idx = find(strcmp(webface_name, inte{i}));
    wf_idx = wf_idx(1);
    fprintf(fid,'%07d %s\n', webface_id(wf_idx), vgg{vgg_idx,1});
end
fclose(fid);
