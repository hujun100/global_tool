function feature = compute_feature_vgg(img1_name, img_dir)

% caffe_path='/home/scw4750/github/caffe/matlab';

% rank_n=50;
% for lightencnn
%for vgg
prototxt='/home/scw4750/github/2D/2D_models/vggFace/VGG_FACE_deploy.prototxt';
caffemodel='/home/scw4750/github/2D/2D_models/vggFace/VGG_FACE.caffemodel';
data_key='data';
feature_key='fc7';
is_gray=false;
data_size=[224 224];
norm_type=1;
averageImg=[129.1863,104.7624,93.5940] ;
preprocess_param.do_alignment=true;
preprocess_param.align_param.alignment_type='bbox';
preprocess_param.align_param.padding_factor = 1.1;

net=caffe.Net(prototxt,caffemodel,'test');
caffe.set_mode_gpu();

feature = extract_feature_single(img_dir, img1_name,data_size,data_key,feature_key,net,preprocess_param, ...
    is_gray,norm_type,averageImg);

end