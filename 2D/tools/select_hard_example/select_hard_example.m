addpath(genpath('/raid/hujun/global_tool'));
addpath('/home/scw4750/caffe-master/matlab');
data = importdata('selected_v2_BRL_all.txt');
all_labels = data.data;
all_imgs = data.textdata;
caffe.reset_all();
net = caffe.Net('ResNet_deploy.prototxt','/raid/hujun/ResNet_bbox/snapshot/v17/ResNet__iter_200000.caffemodel','test');
caffe.set_mode_gpu();
data_key = 'data';
feature_key = 'fc205';
count = 0;
for i_i = 1:length(all_labels)
    i_i
    label = all_labels(i_i);
    img = imread(['/raid/hujun/train_data/' all_imgs{i_i}]);
    img = preprocess_img(img);
    net.blobs(data_key).set_data(img);
    net.forward_prefilled();
    feature=net.blobs(feature_key).get_data();
    [~,index]=max(feature);
    if label+1 ~=index
        count = count + 1;
        hard_example_index(count) = i_i;
        hard_example_feature(count) = feature;
    end
end


function output_img = preprocess_img(img)
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