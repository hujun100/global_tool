function write_h5_single(h5_name,norm_train_data,norm_train_label)
%norm_train_data should be B*3*N
%norm_train_label should be 1*B
if exist(h5_name,'file')
   delete(h5_name); 
end

total_num = size(norm_train_data,1);
pc_num = size(norm_train_data, 3);
h5create(h5_name,'/data',[3 pc_num total_num],'ChunkSize',[1 375 63],'Deflate',4);
h5create(h5_name,'/label',[1 total_num],'ChunkSize',[1 total_num],'Deflate',1);
h5write(h5_name,'/data',permute(norm_train_data,[2 3 1]));
h5write(h5_name,'/label',norm_train_label);

end
