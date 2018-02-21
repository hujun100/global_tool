function [rank_score,analysis]=compute_rank_single(gallery,probe,rank_param)
%compute rank_socre
%
%input:
%  gallery  -- a struct that has field fea() and its label for gallery
%  probe    -- a struct that has field fea() and its label for probe
%  rank_param.rank_n   -- the max rank number
%  rank_param.distance_type --'cos' 'L2'
%output:
%  rank_score
%notices:
%           -- just for the scores that the bigger the better.
%
%Jun Hu
%2017-3

rank_n=rank_param.rank_n;
rank_count=zeros(rank_n,1);
distance_type=rank_param.distance_type;
for i_p=1:length(probe)
    fprintf('compute rank i_p:%d\n',i_p);
    for i_g=1:length(gallery)
        if strcmp(distance_type,'cos')
            result(i_g).score=compute_cosine_score(gallery(i_g).fea,probe(i_p).fea);
        else
            result(i_g).score=pdist2(gallery(i_g).fea',probe(i_p).fea');
        end
        analysis.distance_matrix(i_p,i_g)=result(i_g).score;
        analysis.gallery_info(i_g).name=gallery(i_g).name;
        analysis.gallery_info(i_g).label=gallery(i_g).label;
        analysis.probe_info(i_p).name=probe(i_p).name;
        analysis.probe_info(i_p).label=probe(i_p).label;
    end
    
    %     if i_p==163
    %        asdf=2;
    %     end
    if strcmp(distance_type,'cos') 
       [sort_score,index]=sort([result.score],'descend');
    else
        [sort_score,index]=sort([result.score]);
    end
    analysis.sort_matrix(i_p,:)=index;
    %     thre=sort_score(rank_n);
    has_pinned=0;
    for i_s=1:rank_n
        if probe(i_p).label==gallery(index(i_s)).label
            has_pinned=1;
        end
        rank_count(i_s)=rank_count(i_s)+(probe(i_p).label==gallery(index(i_s)).label||has_pinned);
    end
end
rank_score=single(rank_count)/single(length(probe));
end
