clear;clc;
%%%%%%%%% to randomly get 3000 test class list
data = importdata('/home/brl/TRAIN/DataSet/morph2_complete/morphPerFolder.txt');
fidGal = fopen('/home/brl/TRAIN/DataSet/morph2_complete/testGallery.txt','wt');
fidPro = fopen('/home/brl/TRAIN/DataSet/morph2_complete/testProbe.txt','wt');
fidTrain = fopen('/home/brl/TRAIN/DataSet/morph2_complete/trainList.txt','wt');
allClass = cell(length(data), 1);
for i = 1:length(data)
    imgPath = data{i};
    pathSplit = regexp(imgPath, '/', 'split');
    className = pathSplit{1};
    allClass{i} = className;
end
uClass = unique(allClass);
r = randperm(length(uClass));
uClass = uClass(r);
testCount = 0;
for i = 1:length(uClass)
    i
    index = find(strcmp(allClass, uClass{i}));
    if length(index) == 1
        continue;
    end
    allPaths = data(index);
    allPathsLen = length(allPaths);
    allAge = zeros(allPathsLen, 1);
    if testCount < 3000
        for i_a = 1:allPathsLen
            path = allPaths{i_a};
            allAge(i_a) = str2num(path(end-5:end-4));
        end
        [~,idx] = max(allAge);
        fprintf(fidPro,'%s %d\n', allPaths{idx}, testCount);
        allAge(idx) = Inf;
        [~,idx] = min(allAge);
        fprintf(fidGal,'%s %d\n', allPaths{idx}, testCount);
        testCount = testCount + 1;
    else
        for i_a = 1:allPathsLen
            path = allPaths{i_a};
            fprintf(fidTrain,'%s\n', path);
        end
    end
end
fclose(fidGal);
fclose(fidPro);
fclose(fidTrain);


%%%%% to construct gallery and probe
% data = importdata('/home/brl/TRAIN/DataSet/morph2_complete/testClassList.txt');
% dataDir = '/home/brl/TRAIN/DataSet/morph2_complete/classPerFoler';

