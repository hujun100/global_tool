% just build lmdb in matlab by calling executable program wrote by c++.
% the reason I write this code is I can tolerate using  shell command and scripts.

% %for constractive loss
% tools='/home/scw4750/github/caffe/build/tools/convert_imageset';
% pos_neg_pair_name='train_test_list/pos_neg_pair_for_train/pos:neg-1:20/cylindrical_map_merge.txt';
% gal_data_root='/home/scw4750/github/IJCB2017/liufeng/train/lightcnn/train_test_data/gallery';
% pro_data_root='/home/scw4750/github/IJCB2017/liufeng/train/lightcnn/train_test_data/probe/still';
% resize_height=144;
% resize_width=144;
% gray='true';
% gal_output_name='lmdb/gal_lmdb';
% pro_output_name='lmdb/pro_lmdb';
% 
% 
% splitPair(pos_neg_pair_name);
% gal_data_list=[pos_neg_pair_name '-gal'];
% pro_data_list=[pos_neg_pair_name '-pro'];
% if exist(gal_output_name,'dir')
%    rmdir(gal_output_name,'s'); 
% end
% if exist(pro_output_name,'dir')
%    rmdir(pro_output_name,'s'); 
% end
% 
% system([tools ' --resize_height ' num2str(resize_height) ' --resize_width ' ...
%     num2str(resize_width) ' --gray=' gray ' ' gal_data_root filesep ' ' ...
%     gal_data_list ' ' gal_output_name]);
% system([tools ' --resize_height ' num2str(resize_height) ' --resize_width ' ...
%     num2str(resize_width) ' --gray=' gray ' ' pro_data_root filesep ' ' ...
%     pro_data_list ' ' pro_output_name]);
% delete(gal_data_list);
% delete(pro_data_list);


%for center loss
tools='/home/scw4750/github/caffe/build/tools/convert_imageset';
list_txt='/home/scw4750/github/learning/tensorflow/vgg_face/name_label.txt';
data_root='/home/scw4750/github/learning/tensorflow/vgg_face/7_gallery/brl_alignment';
resize_height=224;
resize_width=224;
gray='false';
output_name='vgg_lmdb';
shuffle='false';

if exist(output_name,'dir')
   rmdir(output_name,'s'); 
end

system([tools ' --resize_height ' num2str(resize_height) ' --resize_width ' ...
    num2str(resize_width) ' --gray=' gray ' --shuffle=' shuffle ' ' data_root filesep ' ' ...
    list_txt ' ' output_name]);

