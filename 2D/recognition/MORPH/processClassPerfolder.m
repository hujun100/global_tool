data = importdata('/home/brl/TRAIN/DataSet/morph2_complete/morph.txt');
dataDir = '/home/brl/TRAIN/DataSet/morph2_complete/Images_ori';
outDir = '/home/brl/TRAIN/DataSet/morph2_complete/classPerFoler';
allClass = cell(length(data), 1);
for i = 1:length(data)
    imgPath = data{i};
    pathSplit = regexp(imgPath, '_', 'split');
    className = pathSplit{1};
    allClass{i} = className;
end
uClass = unique(allClass);

for i = 1:length(uClass)
    index = find(strcmp(allClass, uClass{i}));
    if length(index) == 1
        i 
    end
    subFolder = fullfile(outDir, uClass{i});
    mkdir(subFolder);
    for i_i = 1:length(index)
        imgPath = data{index(i_i)};
         copyfile(fullfile(dataDir, imgPath), fullfile(subFolder, imgPath));
    end
end
