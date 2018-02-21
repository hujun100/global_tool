function activation = get_activation(processed_img, prototxt, caffemodel, data_key, activation_key)

caffe.set_mode_gpu();
net = caffe.Net(prototxt, caffemodel, 'test');


img_size = size(processed_img);
data = zeros(img_size(1),img_size(2),3,1);
data(:) = processed_img(:);
net.blobs(data_key).set_data(data);
net.forward_prefilled();
activation = net.blobs(activation_key).get_data();
end

