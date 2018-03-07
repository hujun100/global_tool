data = importdata('/home/brl/TRAIN/DataSet/temp');
dataDir = '/home/brl/TRAIN/DataSet/CASIA-WebFace-118X102';
outDir = '/home/brl/TRAIN/DataSet/CASIA-WebFace-112X96';
size = [112,96];
if isfield(data,'textdata')
    data = data.textdata;
end
for i = 1:length(data)
    i
    path = data{i};
    img = imread(fullfile(dataDir, path));
    img = imresize(img, size);
    outPath = fullfile(outDir, path);
    make_dir(outPath);
    imwrite(img, outPath);
end