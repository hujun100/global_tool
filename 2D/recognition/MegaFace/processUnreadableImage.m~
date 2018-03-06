data =importdata('/home/brl/TRAIN/facescrub.txt');
root_dir = '/home/brl/TRAIN/downloaded/';
for i_d = 1:length(data)
    i_d
    img_name = data{i_d};
    try
        img = imread([root_dir img_name]);
    catch
        desFile = [root_dir img_name];
        delete(desFile);
        if strcmp(img_name(1:10), data{i_d-1}(1:10))
            copyfile([root_dir data{i_d-1}], desFile);
        else
            copyfile([root_dir data{i_d+1}], desFile);
        end
        continue;
    end
    if numel(img) < 40*40*3
        
    end
end