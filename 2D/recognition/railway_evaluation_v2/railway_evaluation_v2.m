 addpath(genpath('~/github/global_tool'));
% gal_txt_with_label = '/home/scw4750/Dataset/huochezhan/v1/gallery.txt';
% pro_txt_with_label = '/home/scw4750/Dataset/huochezhan/v1/probe.txt';
pos_neg_pair_txt = '/home/scw4750/Dataset/huochezhan/railway_evaluation/v2/pos_neg_pair.txt';
[scores, labels] = compute_roc_from_img_feature_map(gal_img_feature_map, pro_img_feature_map, ...
    pos_neg_pair_txt);
[~,~,info]=vl_roc(scores,labels);
accuracy = evaluation.accuracy.eval_best([],scores,labels,10);
