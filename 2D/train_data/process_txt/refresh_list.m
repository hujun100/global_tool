%%%% To rm the un-exist line in txt
% refresh('bbox_22_railway.txt','refresh_bbox_22_railway.txt');
% refresh('bbox_30_railway.txt','refresh_bbox_30_railway.txt');
% refresh('bbox_asia.txt','refresh_bbox_asia.txt');
% refresh('bbox_webface.txt','refresh_bbox_webface.txt');
% refresh('bbox_hujun.txt','refresh_bbox_hujun.txt');
refresh('/home/idealsee/face_train_data_needed/webface.txt','/home/idealsee/face_train_data_needed/webface_new.txt');

function refresh(ffp,out_ffp)
root_dir = '/home/idealsee/face_train_data_needed/';
fid = fopen(out_ffp,'wt');
data = importdata(ffp);
image = data.textdata;
label = data.data;
for i = 1:length(image)
    i
    img_name = image{i};
    if exist([root_dir img_name],'file')
        fprintf(fid,'%s %d\n', img_name, label(i)); 
    end
end

fclose(fid);
end
