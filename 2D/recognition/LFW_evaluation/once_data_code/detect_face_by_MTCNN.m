clear;
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
is_use_relative_path=1;
is_write_5pt = true;
img_dir='/media/scw4750/tb4/data/lfw_data/lfw';
list_txt = 'detect_list.txt';
is_write_detected_face = false; %if true,you should change the code





%% advanced parameters. If you want to know what it is, see codes
is_square_bbox=0;
crop_factor=1;
%%%%%%%%%%%%%%%%%%%


%path of toolbox
caffe_path='/home/scw4750/github/caffe/matlab';
pdollar_toolbox_path='/home/scw4750/github/global_tool/2D/detection/mtcnn/toolbox-master';
caffe_model_path='/home/scw4750/github/global_tool/2D/detection/mtcnn/MTCNNv2/model';
addpath('/home/scw4750/github/global_tool/2D/detection/mtcnn/MTCNNv2');
addpath(genpath(caffe_path));
addpath(genpath(pdollar_toolbox_path));

%minimum size of face
minsize=20;
%use cpu
%caffe.set_mode_cpu();
gpu_id=0;
caffe.set_mode_gpu();
caffe.set_device(gpu_id);

%three steps's threshold
threshold=[0.6 0.7 0.7];

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
prototxt_dir =  strcat(caffe_model_path,'/det4.prototxt');
model_dir =  strcat(caffe_model_path,'/det4.caffemodel');
LNet=caffe.Net(prototxt_dir,model_dir,'test');
faces=cell(0);
error_img=[];




if is_use_relative_path
    assert(logical(exist('img_dir','var')),'user should provide image directory');
    assert(~isempty(img_dir),'user should provide image directory');
end
imglist=importdata(list_txt);
for i=1:length(imglist)
    i
    try
        if is_use_relative_path
            img=imread([img_dir filesep imglist{i}]);
        else
            img=imread(imglist{i});
        end
        img_height=size(img,1);
        img_width=size(img,2);
        %         if img_height*img_width > 1000000
        %             if img_height>img_width
        %               img=imresize(img,500/img_height);
        %             else
        %               img=imresize(img,500/img_height);
        %             end
        %         end
        %         img_height=size(img,1);
        %         img_width=size(img,2);
    catch
        error_img(length(error_img)+1).name=imglist{i};
        %         delete(imglist{i});
        continue;
    end
    %     we recommend you to set minsize as x * short side
    minl=min([size(img,1) size(img,2)]);
    minsize=fix(minl*0.1);
    tic
    [boudingboxes points]=detect_face(img,minsize,PNet,RNet,ONet,LNet,threshold,false,factor);
    toc
    bbox=boudingboxes;
    for i_b = 1:size(bbox,1)
        
        %% if get small bboxs, ignore them
        height=bbox(i_b,4)-bbox(i_b,2);
        width=bbox(i_b,3)-bbox(i_b,1);
        if(height*width<1600)
            continue;
        end
        %% end: if get small bboxs, ignore them
        
        
        
        %% get square bbox
        if is_square_bbox
            bbox=get_square_bbox(bbox,crop_factor);
        end
        %% end: get square bbox
        
        if is_write_detected_face
            if is_use_relative_path
                img_name = imglist{i};
                imwrite(img(bbox(i_b,2):bbox(i_b,4), bbox(i_b,1):bbox(i_b,3),:),['result' filesep img_name(1:end-4) '_detected.jpg']);
            else
                imwrite(img(bbox(i_b,2):bbox(i_b,4), bbox(i_b,1):bbox(i_b,3),:),['result' imglist{i}]);
            end
        end
        
        %% write landmarks to file(.5pt)
        if is_write_5pt
            if is_use_relative_path
                write_5pt([img_dir filesep imglist{i}],bbox,points);
            else
                write_5pt(imglist{i},bbox,points);
            end
        end
        %% end: write landmarks to file(.5pt)
    end
    
end



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

idx=strfind(path,'.');
path=path(1:idx(end));
fid=fopen([path '5pt'],'wt');
for i_pt=1:5
    fprintf(fid,'%f %f\n',points(i_pt,1),points(i_pt+5,1));
end
fprintf(fid,'%f %f %f %f\n',bbox(1,1),bbox(1,2),bbox(1,3)-bbox(1,1),bbox(1,4)-bbox(1,2));
fclose(fid);

end

