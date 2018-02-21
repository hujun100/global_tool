function [fpir001,fpir01]=compute_tpir_from_analysis_matrix(analysis,top_k)

gallery = analysis.gallery_info;
gal_label = extractfield(gallery,'label');
probe = analysis.probe_info;
pro_label = extractfield(probe,'label');
distance_matrix = analysis.distance_matrix;


index_count = 0;
for i_p = 1:size(distance_matrix,1)
    probe_label = pro_label(i_p);
    if isempty(find(gal_label == probe_label, 1))
        index_count = index_count  + 1;
        non_enrolled_probe_index(index_count) = i_p;
    end
end
% sorted_distance = sort(distance_matrix,2,'descend');
% non_enrolled = sorted_distance(non_enrolled_probe_index,1:top_k);
% non_enrolled = non_enrolled(:);
% res = sort(non_enrolled,'descend');
% non_enrolled_len = length(non_enrolled);
% threshold001 = res(int32(non_enrolled_len/100));
% threshold01 = res(int32(non_enrolled_len/10));
% 
% fpir001=get_fpir(distance_matrix,gal_label,pro_label,non_enrolled_probe_index,threshold001,top_k);
% fpir01=get_fpir(distance_matrix,gal_label,pro_label,non_enrolled_probe_index,threshold01,top_k);


sorted_distance = sort(distance_matrix,2,'descend');
top1_value = sorted_distance(non_enrolled_probe_index,1);
sorted_top1 = sort(top1_value,'descend');
top1_len = length(sorted_top1);

threshold001 = sorted_top1(int32(top1_len/100));
threshold01 = sorted_top1(int32(top1_len/10));

fpir001=get_fpir(distance_matrix,gal_label,pro_label,non_enrolled_probe_index,threshold001,top_k);
fpir01=get_fpir(distance_matrix,gal_label,pro_label,non_enrolled_probe_index,threshold01,top_k);


end

function fpir = get_fpir(distance_matrix,gal_label,pro_label,non_enrolled_probe_index,threshold,top_k)

enrolled_probe_index = setdiff(1:size(distance_matrix,1),non_enrolled_probe_index);
[distance_matrix,mat_index] = sort(distance_matrix,2,'descend');
fp = 0;
for i_p = 1:length(enrolled_probe_index)
    index = enrolled_probe_index(i_p);
    for i_g = 1:top_k
        if distance_matrix(index,i_g)>threshold && gal_label(mat_index(index,i_g))==pro_label(index)
            fp = fp +1;
            break;
        end
    end
end

fpir = fp/length(enrolled_probe_index);

end