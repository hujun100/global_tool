% all_keys = img_feature_map.keys();
% all_class_index = get_key_class_index(all_keys);
clear pos_label;
clear neg_label;
i=1;
one_class_len = length(all_class_index{i});
pos_features = zeros(one_class_len, 4096);
one_class_index = all_class_index{i};
for i_o = 1:one_class_len
    pos_feature(i_o,:) =  img_feature_map(all_keys{one_class_index(i_o)});
    pos_label(i_o,1) = 1;
end

neg_feature = zeros(100,4096);
neg_class_index = setdiff(1:length(all_class_index),one_class_index);
r = randperm(length(neg_class_index));
for i_n = 1:size(neg_feature,1)
    final_neg_index = r(i_n);
    neg_feature(i_n,:) = img_feature_map(all_keys{final_neg_index});
    neg_label(i_n,1) = 0;
end

svm_struct = svmtrain([pos_feature;neg_feature],[pos_label;neg_label]);
for i = 1:100
svmclassify(svm_struct, neg_feature(i,:))
end



function all_class_index = get_key_class_index(all_keys)

reg_ids={};
count = 0;
for i = 1:length(all_keys)
    i
    key = all_keys{i};
    key_split = regexp(key,filesep,'split');
    id = key_split{1};
    if isempty(find(strcmp(reg_ids,id)))
        count = count + 1;
        reg_ids = [reg_ids id];
        all_class_index{count} = i;
    else
        index = find(strcmp(reg_ids,id));
        all_class_index{index} = [all_class_index{index} i];
    end
end

end

