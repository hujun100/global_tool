function roc_info = compute_roc_for_ijba(analysis_matrix, topk)

distance = analysis_matrix.distance_matrix;
gal = analysis_matrix.gal_info;
pro = analysis_matrix.pro_info;
all_pairs = zeros(size(distance, 1)*topk, 1);
all_labels = zeros(size(distance, 1)*topk, 1);
for i = 1:size(distance, 1)
     
end

end