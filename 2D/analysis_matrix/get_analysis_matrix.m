function analysis=get_analysis_matrix(gallery,probe,matrix_param)
%compute rank_socre
%
%input:
%  gallery  -- a struct that has field fea(image's feature) and its label for gallery and name(empty is availbale if just calculate cmc)
%  probe    -- a struct that has field fea(image's feature) and its label for probe   and name(empty is availbale if just calculate cmc)
%  matrix_param.distance_type --'cos' 'L2'
%output:
%  analysis
%
%
%Jun Hu
%2017-3
distance_type='cos';
if nargin<3
   matrix_param=[];
end
if isfield(matrix_param,'distance_type')
    distance_type=matrix_param.distance_type;
end

%%% new method to compute cosine analysis matrix for acclebrating -- 17-9
if strcmp(distance_type,'cos')
    gallery_matrix = zeros(length(gallery(1).fea), length(gallery));
    for i_g=1:length(gallery)
        gallery_matrix(:,i_g) = gallery(i_g).fea/norm(gallery(i_g).fea);
        if isfield(gallery,'name')
            analysis.gallery_info(i_g).name=gallery(i_g).name;
        end
        analysis.gallery_info(i_g).label=gallery(i_g).label;
    end 
    for i_p = 1:length(probe)
        if isfield(probe, 'name')
            analysis.probe_info(i_p).name=probe(i_p).name;
        end
        analysis.probe_info(i_p).label=probe(i_p).label;
    end

    probe_matrix = zeros(length(probe), length(probe(1).fea));
    for i_p = 1:length(probe)
        probe_matrix(i_p,:) = probe(i_p).fea/norm(probe(i_p).fea);
    end

    analysis.distance_matrix = probe_matrix*gallery_matrix;
    return;
end

% %%%% old version to comptue analysis matrix 
% for i_p=1:length(probe)
%     fprintf('get_analysis matrix i_p:%d\n',i_p);
%     for i_g=1:length(gallery)
%         if strcmp(distance_type,'cos')
%             result(i_g).score=compute_cosine_score(gallery(i_g).fea,probe(i_p).fea);
%         else
%             result(i_g).score=pdist2(gallery(i_g).fea',probe(i_p).fea');
%         end
%         analysis.distance_matrix(i_p,i_g)=result(i_g).score;
%         if isfield(gallery,'name')
%             analysis.gallery_info(i_g).name=gallery(i_g).name;
%         end
%         analysis.gallery_info(i_g).label=gallery(i_g).label;
%         if isfield(probe, 'name')
%             analysis.probe_info(i_p).name=probe(i_p).name;
%         end
%         analysis.probe_info(i_p).label=probe(i_p).label;
%     end
%     
%     if strcmp(distance_type,'cos')
%         [sort_score,index]=sort([result.score],'descend');
%     else
%         [sort_score,index]=sort([result.score]);
%     end
%     analysis.sort_matrix(i_p,:)=index;
% end

end
