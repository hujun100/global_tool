addpath(genpath('~/github/global_tool'));
[all_files,all_labels,~]=parse_csv('/home/scw4750/Dataset/IJB-A/IJB-A_1N_sets/split1/search_gallery_1.csv');
all_class_index = get_class_index(all_labels);
all_features = zeros(length(all_files),4096);
for i_f = 1:length(all_files)
     all_features(i_f,:) = img_feature_map(all_files{i_f});
end

save('feature_label.mat','all_features','all_class_index');
