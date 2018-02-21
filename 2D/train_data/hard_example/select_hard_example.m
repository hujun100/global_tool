addpath(genpath('/raid/hujun/global_tool'));
addpath('/home/idealsee/github/caffe-sphereface-mod/matlab');
% fid = fopen('/home/idealsee/gaofeifeiDataSet/wf+MS+sz2k+tg2k+train2k+vgg-112X96.txt');
% % data = textscan(fid,'%s %d\n');
% count = 1;
% while 1
% %     count
%     line = fgetl(fid);
%     if ~ischar(line),break,end
% %     line
%     idx = strfind(line, ' ');
%     all_imgs{count} = line(1:idx(end)-1);
%     all_labels(count) = str2num(line(idx(end)+1:end));
%     count = count + 1;
% end
% fclose(fid);

caffe.reset_all();

prototxt = '/home/idealsee/server/best result/180102/sphereface_deploy.prototxt';
caffemodel = '/home/idealsee/server/best result/180102/0.00001+dropout/sphereface_model_iter_23000.caffemodel';
img_root_dir = '/home/idealsee/gaofeifeiDataSet/';

data_key = 'data';
feature_key = 'MarginInnerProduct1';


net = caffe.Net(prototxt , ...
   caffemodel ,'test');
caffe.set_mode_gpu();
caffe.set_device(0);

count = 0;
record_count = 0;
begin_number = 1;
fid = fopen('hard_example.txt','wt');
last_label=-1;
deleted_number = 0;
for i_i = begin_number:length(all_labels)
    i_i
    label = all_labels(i_i);
    if label ~= last_label
        count=0;
        one_class_number = sum(all_labels == label);
    end
    last_label = label;
    try
        img = imread([img_root_dir all_imgs{i_i}]);
    catch
        continue;
    end
    preprocessed_img = preprocess_img_sphereface(img);
    net.blobs(data_key).set_data(preprocessed_img);
    net.forward_prefilled();
    feature=net.blobs(feature_key).get_data();
    [~,index]=max(feature);
    if label+1 ~=index
        fprintf(fid,'%s %d\n', all_imgs{i_i}, label);
        count = count + 1;
%         hard_example_index(count) = i_i;
%         hard_example_feature{count} = feature;
%         
%         img_max_index = find(all_labels == index-1);
%         img_max_index = img_max_index(1);
%         img_max_name = all_imgs{img_max_index};
%         img_max_name_split = regexp(img_max_name,'/','split');
% %         fprintf(fid,'%s\n',img_max_name_split{2});
%         img_name = ['/raid/hujun/train_data/' all_imgs{i_i}];
%         threshold = single(count)/one_class_number;
%         if threshold > 0.1
%             record_count = record_count + 1;
%             img_name_split = regexp(img_name,filesep,'split');
%             record{record_count} = img_name_split{end-1};
%         end
%         try
%             delete(img_name);
%         catch
%             continue;
%         end
%         img_name_split = regexp(img_name,'/','split');
%         fprintf(fid,'%s\n',img_name_split{2});
%         %%% show img
%         subplot(2,1,1);
%         imshow(img);
% 
%         img_max = imread(['/raid/hujun/train_data/' img_max_name]);
%         subplot(2,1,2);
%         imshow(img_max);

    end
end
fclose(fid);

function output_img = preprocess_img_vgg(img)
if length(size(img)) == 2
    img(:,:,2) = img(:,:,1);
    img(:,:,3) = img(:,:,1);
end

averageImg = [123, 117, 104];
img_size = [224,224];
img = img(:, :, [3, 2, 1]); % convert from RGB to BGR
img = permute(img, [2, 1, 3]); % permute width and height
img=imresize(img,img_size);
data = zeros(img_size(2),img_size(1),3,1);
data = single(data);

img=single(img);
img = cat(3,img(:,:,1)-averageImg(3),...
    img(:,:,2)-averageImg(2),...
    img(:,:,3)-averageImg(1));
data(:,:,1,1) = (single(img(:,:,1)));
data(:,:,2,1) = (single(img(:,:,2)));
data(:,:,3,1) = (single(img(:,:,3)));
output_img = data;
end

function output_img = preprocess_img_sphereface(cropImg)
temp=cropImg;
if size(cropImg,3)==1
    cropImg(:,:,1)=temp;
    cropImg(:,:,2)=temp;
    cropImg(:,:,3)=temp;
end
cropImg = single(cropImg);
cropImg = (cropImg - 127.5)/128;
cropImg = permute(cropImg, [2,1,3]);
cropImg = cropImg(:,:,[3,2,1]);
output_img = cropImg;
end