function similarity = compute_similarity_lightcnn(img1_name, img2_name, img_dir)

% caffe_path='/home/scw4750/github/caffe/matlab';

% rank_n=50;
% for lightencnn
prototxt='/home/scw4750/github/2D/2D_models/lightenCNN/LightenedCNN_C_deploy.prototxt';
caffemodel='/home/scw4750/github/2D/2D_models/lightenCNN/LightenedCNN_C.caffemodel';
data_key='image';
feature_key='eltwise_fc1';
is_gray=true;
data_size=[128 128];
% is_transpose=true;
norm_type=0;  %type=0 indicates that the data is just divided by 255
averageImg=[0 0 0];
preprocess_param.do_alignment=true;
preprocess_param.align_param.alignment_type='lightcnn';
net=caffe.Net(prototxt,caffemodel,'test');
caffe.set_mode_gpu();

img1_fea = extract_feature_single(img_dir, img1_name,data_size,data_key,feature_key,net,preprocess_param, ...
    is_gray,norm_type,averageImg);
img2_fea = extract_feature_single(img_dir, img2_name,data_size,data_key,feature_key,net,preprocess_param, ...
    is_gray,norm_type,averageImg);

similarity = compute_cosine_score(img1_fea, img2_fea);

end