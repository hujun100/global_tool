% clear;
addpath(genpath('~/github/global_tool'));
[all_files,all_labels,~]=parse_csv('/home/scw4750/Dataset/IJB-A/IJB-A_1N_sets/split1/search_gallery_1.csv');
all_class_index = get_class_index(all_labels);
all_files_len = length(all_files);

class_len = length(all_class_index);
all_svm_struct = cell(class_len,1);

for i_c = 1:class_len
    i_c
    one_class_index = all_class_index{i_c};
    one_class_len = length(one_class_index);
    pos_features = zeros(one_class_len, 4096);
    for i_p = 1:one_class_len
        pos_features(i_p,:) = img_feature_map(all_files{one_class_index(i_p)}); 
    end
    pos_labels = ones(one_class_len,1);
    
    neg_len = all_files_len-one_class_len;
    all_neg_index = setdiff(1:all_files_len,one_class_index);
    neg_features = zeros(neg_len,4096);
    for i_n=1:neg_len
        neg_features(i_n,:) = img_feature_map(all_files{all_neg_index(i_n)});
    end
    neg_labels = -ones(neg_len,1);
    
%     svm_struct = svmtrain([pos_features;neg_features],[pos_labels;neg_labels],...
%         'kernel_function','linear');
%     all_svm_struct{i_c} = svm_struct;
%     features = [pos_features;neg_features];
%     labels = [pos_labels;neg_labels];
    
end

[all_pro_files,all_pro_labels,all_pro_template] = parse_csv('/home/scw4750/Dataset/IJB-A/IJB-A_1N_sets/split1/search_probe_1.csv');
all_template_index = get_class_index(all_pro_template);
all_template_len = length(all_template_index);
for i_t = 1:all_template_len
    i_t
    one_class_index = all_template_index{i_t};
    all_query_result = zeros(length(one_class_index),length(all_svm_struct));
    
    for i_i = 1:length(one_class_index)
        query_feature = img_feature_map(all_pro_files{one_class_index(i_i)});
        
        all_query_result = [];
        for i_s = 1:length(all_svm_struct)
            svm_struct = all_svm_struct{i_s}; 
            query_result = svmclassify(svm_struct,query_feature');
            all_query_result(i_i,i_s)= query_result;
        end
    end
    max(max(all_query_result))
end

