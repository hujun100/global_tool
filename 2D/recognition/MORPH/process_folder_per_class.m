data = importdata('/home/brl/TRAIN/DataSet/morph2_complete/morph.txt');
dataDir = '/home/brl/TRAIN/DataSet/morph2_complete/Images_ori';
outDir = '/home/brl/TRAIN/DataSet/morph2_complete/classPerFoler';
tic
r= randperm(length(data));
data = data(r);
data = sortrows(data);

classIndex = {};
classCount = 0;
lastClass = '';
for i = 1:length(data)
    imgPath = data{i};
    pathSplit = regexp(imgPath, '_', 'split');
    className = pathSplit{1};
    if strcmp(className, lastClass) == 0 
        lastClass = className;
        classCount = classCount + 1;
        classIndex{classCount} = [];
    end        
    classIndex{classCount} = [classIndex{classCount} i];
end
toc
% allClass = cell(length(data), 1);
% for i = 1:length(data)
%     imgPath = data{i};
%     pathSplit = regexp(imgPath, '_', 'split');
%     className = pathSplit{1};
%     allClass{i} = className;
% end
% 
% 
% uClass = unique(allClass);
% for i = 1:length(uClass)
%     index = find(strcmp(allClass, uClass{i}));
%     if length(index) == 1
%         i 
%     end
%     subFolder = fullfile(outDir, uClass{i});
%     mkdir(subFolder);
%     for i_i = 1:length(index)
%         imgPath = data{index(i_i)};
%          copyfile(fullfile(dataDir, imgPath), fullfile(subFolder, imgPath));
%     end
% end
