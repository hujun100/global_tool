data = importdata('testImgInTrainData.txt');
dataDir = '/home/brl/TRAIN/DataSet/CACD/DATA/AlignedCACD/CACD2000Cleaned';
for i = 1:length(data)
    i
    delete(fullfile(dataDir, data{i}(12:end)));
end