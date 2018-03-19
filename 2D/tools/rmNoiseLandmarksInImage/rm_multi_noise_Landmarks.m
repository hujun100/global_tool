addpath(genpath('~/github/global_tool'));
caffe_path='/home/brl/github/caffe-ms/matlab';
addpath(caffe_path);
img_dir = '/home/brl/TRAIN/DataSet/CACD/DATA/AlignedCACD_VS/CACD_VS/';
all_imgs_ffp = '/home/brl/TRAIN/DataSet/CACD/DATA/AlignedCACD_VS/cacd_vs_list.txt';
prototxt = '/home/brl/TRAIN/DataSet/CACD/DATA/getCACDFeatures/best_result/train_file_v82/sphereface_deploy.prototxt';
caffemodel = '/home/brl/TRAIN/DataSet/CACD/DATA/getCACDFeatures/best_result/v90/sphereface_model_iter_230000.caffemodel';
data_key='data';
feature_key='fc5';
is_gray=false;
data_size=[112, 96];
norm_type=2;
averageImg=[127.5, 127.5, 127.5] ;   %%%RG7
preprocess_param.do_alignment=false;
net_param.is_gray=is_gray;
net_param.norm_type=norm_type;
net_param.averageImg=averageImg;
matrix_param.distance_type='cos';
preprocess_param.is_continue_without_landmarks=false;
net = caffe.Net(prototxt, caffemodel,'test');
caffe.set_mode_gpu();


allImgPaths = importdata('/home/brl/TRAIN/facescrub.txt');
featureDim = 1024;
dataDir = '/home/brl/TRAIN/downloaded';

allImgLen = length(allImgPaths);
allClass = cell(allImgLen, 1);
allFeatures = zeros(allImgLen, featureDim);
% allImgLen = 200; %%for test
for i = 1:allImgLen
    if mod(i, 1000) ==1
        fprintf('first i:%d\n',i);
    end
    imgPath = allImgPaths{i};
    class = regexp(imgPath, filesep, 'split');
    lmPath = [imgPath '.5pt'];
    lmPath = fullfile(dataDir, lmPath);
    multiFacesLm = dir([fullfile(dataDir, imgPath), '.multi*.5pt']);
    if ~isempty(multiFacesLm) || ~exist(lmPath, 'file')
        allClass{i} = 'NULL';
        continue;
    end
    allClass{i} = class{1};
    img = imread(fullfile(dataDir, imgPath));
    img = exceptionDeal(img);
    [img_cropped, conf]=centerloss_align_single(img,lmPath, false);
    features = extract_feature_single_image(img_cropped, data_size, data_key,...
        feature_key,net,preprocess_param,is_gray,norm_type,averageImg);
    features = features/norm(features);
    allFeatures(i,:) = features;

end

uAllClass = unique(allClass(1:allImgLen));
classFeaturesMap = containers.Map();
for i_u = 1:length(uAllClass)
    if ~strcmp(uAllClass{i_u}, 'NULL')
        index = find(strcmp(allClass, uAllClass{i_u}));
        classFeaturesMap(uAllClass{i_u}) = mean(allFeatures(index,:), 1);
    end
end

for i = 1:allImgLen
    if mod(i, 1000) ==1
        fprintf('second i:%d\n',i);
    end
    imgPath = allImgPaths{i};
    class = regexp(imgPath, filesep, 'split');
    class = class{1};
    
    multiFacesLm = dir([fullfile(dataDir, imgPath), '.multi*.5pt']);
    if isempty(multiFacesLm)
        continue;
    end
    scores = [];
    img = imread(fullfile(dataDir, imgPath));
    img = exceptionDeal(img);
    for i_m = 1:length(multiFacesLm)
        [img_cropped, conf]=centerloss_align_single(img,...
            [multiFacesLm(i_m).folder filesep multiFacesLm(i_m).name], false);

        features = extract_feature_single_image(img_cropped, data_size, data_key,...
            feature_key,net,preprocess_param,is_gray,norm_type,averageImg);
        features = features/norm(features);
        scores(i_m) = classFeaturesMap(class) * features;
    end
    [~, idx] = max(scores);
    [lm, bbox] = read_5pt([multiFacesLm(idx).folder filesep multiFacesLm(idx).name]);
    write_5pt([fullfile(dataDir, imgPath) '.5pt'], bbox, lm);
end

function outImg = exceptionDeal(img)

if max(img(:)) > 255 || min(img(:))<0
    img = single(img);
    maxValue = max(img(:));
    minValue = min(img(:));
    img = (img - minValue)/(maxValue-minValue)*255;
    outImg = uint8(img);
else
    outImg=img;
end

end



function write_5pt(path,bbox,points)

% idx=strfind(path,'.');
% if ~isempty(idx)
%     path=path(1:idx(end));
% end
fid=fopen(path,'wt');
for i_pt=1:5
    fprintf(fid,'%f %f\n',points(i_pt,1),points(i_pt,2));
end
fprintf(fid,'%f %f %f %f 1.0\n',bbox(1),bbox(2),bbox(3),bbox(4));
fclose(fid);

end