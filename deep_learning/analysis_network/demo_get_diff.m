addpath(genpath('~/github/global_tool'));
caffe_path = '/home/scw4750/xdx/sphereface-master/tools/caffe-sphereface/matlab';
addpath(genpath(caffe_path));

caffe.set_mode_gpu();
caffe.set_device(1);
solver=caffe.Solver('/raid/hujun/retrain_sphereface/train_file_7/sphereface_solver.prototxt');
count = 0;
key='conv1_2';
for i=1:100
    i
    solver.step(1);
    count = count + 1;
    diff = solver.net.blobs(key).get_diff();
    param = solver.net.layers(key).params(1).get_data();
    bias = solver.net.layers(key).params(2).get_data();
    activation = solver.net.blobs(key).get_data();
    loss = solver.net.blobs('softmax_loss').get_data()
    subplot(4,1,1);
    hist(diff(:));
    subplot(4,1,2);
    hist(activation(:));
    subplot(4,1,3);
    hist(param(:));
    subplot(4,1,4);
    hist(bias(:));
end
caffe.reset_all();