%%%%%note: this code is so hard for reader to understand due to the bad emotion of the
%%%%%author when writting this evaluation code. So just look look and write your own code.
%%%%%Jun Hu 
%%%%%17-8

addpath(genpath('~/github/global_tool'));
rankn=50;

for i = 1:10
    gal_csv = ['/home/scw4750/Dataset/IJB-A/IJB-A_1N_sets/split' num2str(i) '/search_gallery_' num2str(i) '.csv'];
    pro_csv = ['/home/scw4750/Dataset/IJB-A/IJB-A_1N_sets/split' num2str(i) '/search_probe_' num2str(i) '.csv'];
    
    analysis_matrix = compute_analysis_matrix_for_IJBA_single(gal_csv, pro_csv,img_feature_map);
    
    rank_v1 = compute_cmc_by_analysis_matrix(analysis_matrix);
    
    clear v2_gallery;
    clear v2_probe;
    
    %%%%%%% compute close set rank 
    v2_gallery = analysis_matrix.gallery_info;
    v2_probe = analysis_matrix.probe_info;
    v2_distance_matrix = analysis_matrix.distance_matrix;
    all_gal_labels = extractfield(v2_gallery,'label');
    all_pro_labels = extractfield(v2_probe,'label');
    
    u_g = unique(all_gal_labels);
    u_p = unique(all_pro_labels);
    u_s = setdiff(u_p,u_g);
    ignore_idx = [];
    for i_p = 1:length(all_pro_labels)
         label = all_pro_labels(i_p);
         if ~isempty(find(u_s == label))
             ignore_idx = [ignore_idx i_p];
         end
    end
    all_pro_labels(ignore_idx) = [];
    v2_probe(ignore_idx) = [];
    v2_distance_matrix(ignore_idx,:) = [];
    
    
    v2_analysis_matrix.distance_matrix = v2_distance_matrix;
    v2_analysis_matrix.gallery_info = v2_gallery;
    v2_analysis_matrix.probe_info = v2_probe;
    rank_v2 = compute_cmc_by_analysis_matrix(v2_analysis_matrix);
    %%%%%%% end:compute close set rank 

    %%%%%% compute FNIR@FPIR for top20 pairs
    [tpir001,tpir01] = compute_tpir_from_analysis_matrix(analysis_matrix,20);
    roc_info = compute_roc_for_ijba(analysis_matrix, 20);
    %%%%%% end: compute FNIR@FPIP for top20 pairs
    
%     %%%%%% compute FNIR@FPIR for top30 pairs
%     gallery = analysis_matrix.gallery_info;
%     probe = analysis_matrix.probe_info;
%     distance_matrix = analysis_matrix.distance_matrix;
%     all_scores = zeros(size(distance_matrix,1)*30,1);
%     all_labels = all_scores;
%     count = 0;
%     for i_d = 1:size(distance_matrix,1)
%         for i_3 = 1:30
%             count = count + 1;
%             all_scores(count) = distance_matrix(i_d,i_3);
%             all_labels(count) = (gallery(i_3).label == probe(i_d).label);
%         end
%     end
%     [~,~,info] = vl_roc(all_scores, all_labels);
%     %%%%%% compute FNIR@FPIR v2: for all pairs
%     gallery = analysis_matrix.gallery_info;
%     probe = analysis_matrix.probe_info;
%     distance_matrix = analysis_matrix.distance_matrix;
%     all_scores_v2 = zeros(size(distance_matrix,1)*size(distance_matrix,2),1);
%     all_labels_v2 = all_scores_v2;
%     count = 0;
%     for i_d = 1:size(distance_matrix,1)
%         for i_3 = 1:30
%             count = count + 1;
%             all_scores_v2(count) = distance_matrix(i_d,i_3);
%             all_labels_v2(count) = (gallery(i_3).label == probe(i_d).label);
%         end
%     end
%     [~,~,info_v2] = vl_roc(all_scores_v2, all_labels_v2);
    %%%%%% end: compute FNIR@FPIR
    
    all_rank{i,1} = rank_v1;
    all_rank{i,2} = rank_v2;
    rank1(i) = rank_v2(1);
    
    all_tpir001(i) = tpir001;
    all_tpir01(i) = tpir01;
end
mean(rank1)
sqrt(var(rank1))
mean(all_tpir001)
sqrt(var(all_tpir001))
mean(all_tpir01)
sqrt(var(all_tpir01))


function analysis_matrix = compute_analysis_matrix_for_IJBA_single(gal_csv, pro_csv,img_feature_map)

[all_gal_names, all_gal_labels, all_gal_template_id] = parse_csv(gal_csv);
[all_pro_names, all_pro_labels, all_pro_template_id] = parse_csv(pro_csv);

% for i_g = 1:length(all_gal_names)
%     analysis_matrix.gallery_info(i_g).name = all_gal_names{i_g};
%     analysis_matrix.gallery_info(i_g).label = all_gal_labels(i_g);
% end
% 
% for i_p = 1:length(all_pro_names)
%     pro_name = all_pro_names{i_p};
%     analysis_matrix.probe_info(i_p).name = pro_name;
%     analysis_matrix.probe_info(i_p).label = all_pro_labels(i_p);
%     
% end

analysis_matrix.distance_matrix = zeros(length(all_pro_names),length(all_gal_names));
for i_g = 1:length(all_gal_names)
    i_g
    gal_name = all_gal_names{i_g};
%     gal_idx = strcmp(img_feature_map(:,1), gal_name);
    gal_feature = img_feature_map(gal_name);
    for i_p = 1:length(all_pro_names)
%         i_p
        pro_name = all_pro_names{i_p};
%         pro_idx = all_pro_index(i_p);
        pro_feature = img_feature_map(pro_name);
        score = compute_cosine_score(gal_feature, pro_feature);
        analysis_matrix.distance_matrix(i_p,i_g) = score;
    end
end


distance_matrix = analysis_matrix.distance_matrix;

all_gal_template_index = get_class_index(all_gal_template_id);



for i_b = 1:length(all_gal_template_index)
    one_class_index = all_gal_template_index{i_b};
    v2_distance_matrix(:,i_b) = max(distance_matrix(:, one_class_index),[],2);
    new_gallery(i_b).name = all_gal_names{one_class_index(1)};
    new_gallery(i_b).label = all_gal_labels(one_class_index(1));
end

all_pro_template_index = get_class_index(all_pro_template_id);
for i_a = 1:length(all_pro_template_index)
    one_class_index = all_pro_template_index{i_a}; 
    v3_distance_matrix(i_a,:) = max(v2_distance_matrix(one_class_index,:),[],1);
    new_probe(i_a).name = all_pro_names{one_class_index(1)};
    new_probe(i_a).label = all_pro_labels(one_class_index(1));
end

analysis_matrix.distance_matrix = v3_distance_matrix;
analysis_matrix.gallery_info = new_gallery;
analysis_matrix.probe_info = new_probe;

end



