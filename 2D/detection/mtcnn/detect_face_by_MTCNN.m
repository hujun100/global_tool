clear;clc;
% this scripts use MTCNN to detect bbox and landmarks and write the result
% to a file(.5pt) alongside the image for face alignment
%
%
%(To know the format of 5pt, see global_tool/net_param_preprocess_param_doc.txt)
%Jun Hu
%2017-4


%%% parameters
%%%%%%%%%%%%%%%%%%%%%%%
%% if is_use_relative_path == true
%%     then, relative_path + each line in list_txt is full path of the image
%% else
%%     each line in list_txt is full path of the image
use_mtcnn_v1 = false; 

is_use_relative_path=1;
img_dir='/home/scw4750/Dataset/CASIA-WebFace';

is_write_5pt = 1;
list_txt = '/home/scw4750/Dataset/webface.txt';

is_save_mat = 0;
mat_name = 'train-7k_lm_bbox_map.mat';

is_write_detected_face = false; %if true,you should change the code



%% advanced parameters. If you want to know what it is, see codes
is_square_bbox=0;
crop_factor=1;
%%%%%%%%%%%%%%%%%%%

%path of toolbox
caffe_path='/home/scw4750/github/caffe-windows-ms/matlab';
pdollar_toolbox_path='toolbox-master';
addpath(genpath(caffe_path));
addpath(genpath(pdollar_toolbox_path));
if use_mtcnn_v1
    caffe_model_path='MTCNNv1/model';
    rmpath('MTCNNv2');
    addpath('MTCNNv1');
else
    caffe_model_path='MTCNNv2/model';
    rmpath('MTCNNv1');
    addpath('MTCNNv2');
    model_dir =  strcat(caffe_model_path,'/det4.caffemodel');
    prototxt_dir = fullfile(caffe_model_path, 'det4.prototxt');
    LNet=caffe.Net(prototxt_dir,model_dir,'test');
end


%minimum size of face
minsize=20;
%use cpu
%caffe.set_mode_cpu();
gpu_id=0;
caffe.set_mode_gpu();
caffe.set_device(gpu_id);

%three steps's threshold
threshold=[0.6 0.7 0.7];
% threshold = threshold + 0.1;
%scale factor
factor=0.709;

%load caffe models
prototxt_dir =strcat(caffe_model_path,'/det1.prototxt');
model_dir = strcat(caffe_model_path,'/det1.caffemodel');
PNet=caffe.Net(prototxt_dir,model_dir,'test');
prototxt_dir = strcat(caffe_model_path,'/det2.prototxt');
model_dir = strcat(caffe_model_path,'/det2.caffemodel');
RNet=caffe.Net(prototxt_dir,model_dir,'test');
prototxt_dir = strcat(caffe_model_path,'/det3.prototxt');
model_dir = strcat(caffe_model_path,'/det3.caffemodel');
ONet=caffe.Net(prototxt_dir,model_dir,'test');
faces=cell(0);
error_img=[];

name_lm_map = containers.Map();
name_bbox_map = containers.Map();

if is_use_relative_path
    assert(logical(exist('img_dir','var')),'user should provide image directory');
    assert(~isempty(img_dir),'user should provide image directory');
end
imglist=importdata(list_txt);
if isfield(imglist,'textdata')
     imglist = imglist.textdata;
end
for i=1:length(imglist)
    i
        if is_use_relative_path
            name = [img_dir filesep imglist{i}];
        else
            name = imglist{i};
        end
    try

        img=imread(name);

        if length(size(img)) == 2
            img(:,:,2) = img(:,:,1);
            img(:,:,3) = img(:,:,1);
        end
        
        img_height=size(img,1);
        img_width=size(img,2);
        
        if img_height*img_width > 100000
            if img_height>img_width
                img=imresize(img,500/img_height);
            else
                img=imresize(img,500/img_width);
            end
            imwrite(img, name);
        end
        img_height=size(img,1);
        img_width=size(img,2);
        if img_height<40 || img_width<40
            continue;
        end
    catch
        error_img(length(error_img)+1).name=imglist{i};
        %         delete(imglist{i});
        continue;
    end
    %     we recommend you to set minsize as x * short side
    minl=min([size(img,1) size(img,2)]);
    minsize=fix(minl*0.1);
    tic
    if use_mtcnn_v1
        [bboxes, landmarks]=detect_face(img,minsize,PNet,RNet,ONet,threshold,false,factor);
    else
        [bboxes, landmarks]=detect_face(img,minsize,PNet,RNet,ONet,LNet,threshold,false,factor);
    end
    toc
    
    if size(bboxes, 1)>1
        % pick the face closed to the center
        center   = size(img) / 2;
        distance = sum(bsxfun(@minus, [mean(bboxes(:, [2, 4]), 2), ...
            mean(bboxes(:, [1, 3]), 2)], center(1:2)).^2, 2);
        [~, Ix]  = min(distance);
        bbox = bboxes(Ix,:);
        if is_square_bbox
            bbox=get_square_bbox(bbox,crop_factor);
        end
        points = landmarks(:,Ix);
    elseif size(bboxes, 1)==1
        bbox = bboxes;
        points = landmarks;
    else
        continue;
    end
    
    
    %% write landmarks to file(.5pt)
    if is_write_5pt
        write_5pt(name, bbox, points);
    end
    
    if is_save_mat
%          if is_use_relative_path
%              name = imglist{i};
%          end
         name_lm_map(name) = points;
         name_bbox_map(name) = bbox;
    end
end

save(mat_name,'name_lm_map','name_bbox_map');

fprintf('error images number:%d\n',length(error_img));
caffe.reset_all();





% pre-process to get square bbox
% firstly, this algorithms get the center of the origin bbox
% then, set the center as new bbox's center and the
% max(height,width)*crop_factor as the size of bbox.
%
% notices: this algorithms may not get square bbox because the border
% problems (see the codes)
%
%input:
%    bbox          --the origin bbox
%    crop_factor   --
function bbox=get_square_bbox(bbox,crop_factor)

center=bbox(1,1:2)+bbox(1,3:4); %first element is width-center
center=center/2;
width_height=bbox(1,3:4)-bbox(1,1:2); %first element is width
square_size=int32(max(width_height)*crop_factor);
width=square_size;height=square_size;
left_top=int32(center-single(square_size)/2);
left_top(left_top<1)=1;
if left_top(1)+square_size>img_width
    width=img_width-left_top(1);
end
if left_top(2)+square_size>img_height
    height=img_height-left_top(2);
end
bbox(1:2)=left_top;
bbox(3)=width;
bbox(4)=height;
end

function write_5pt(path,bbox,points)

% idx=strfind(path,'.');
% if ~isempty(idx)
%     path=path(1:idx(end));
% end
fid=fopen([path '.5pt'],'wt');
for i_pt=1:5
    fprintf(fid,'%f %f\n',points(i_pt,1),points(i_pt+5,1));
end
fprintf(fid,'%f %f %f %f %f\n',bbox(1,1),bbox(1,2),bbox(1,3)-bbox(1,1),bbox(1,4)-bbox(1,2),bbox(1,5));
fclose(fid);

end

