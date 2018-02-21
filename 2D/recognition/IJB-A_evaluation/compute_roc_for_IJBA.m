addpath(genpath('~/github/global_tool'));
all_result = cell(10,2);
root_dir = '/home/scw4750/Dataset/IJB-A/template_subject_id_bbox_1.0';
for i = 1:10
    comparision_txt = ['/home/scw4750/Dataset/IJB-A/IJB-A_11_sets/split' num2str(i) '/verify_comparisons_' num2str(i) '.csv'];
    [a,b,c,d] = compute_roc_for_IJBA_single(root_dir, comparision_txt, img_feature_map);
%     all_result{i,1} = a;
%     all_result{i,2} = b;
%     all_result{i,3} = c;
%     all_result{i,4} = d;
    accuracy = evaluation.accuracy.eval_best([],a,b,1000);
    [~,~,info] = vl_roc(a,b);
    all_result{i,1} = accuracy;
    all_result{i,2} = info;
    
    all_accuracy(i) = accuracy;
    all_tpr001(i) = info.tpr001;
end
mean(all_accuracy)
sqrt(var(all_accuracy))
mean(all_tpr001)
sqrt(var(all_tpr001))

function [all_scores, all_labels, all_scores_v2, all_labels_v2] = compute_roc_for_IJBA_single(root_dir, comparision_txt, img_feature_map)
%%%%%%% compute roc
%%input: 
%%   root_dir
%%   comparision_txt    root_dir + each line in comparision_txt is full path of one image.
%%   img_feature_map:   built by get_img_feature_map.m
%%                  N*2 cell
%%                  first line is the name of image which is existing in comparision_txt
%%                  second line is the corresponding feature of the image
%%output:
%%   all_scores and all_labels           all geniune and imposter pair
%%   all_scores_v2 and all_labels_v2     maxinum of scores of template id pair
%% Jun Hu
%% 17-8
all_pairs = importdata(comparision_txt);

all_id_class = dir(root_dir);
all_id_class = all_id_class(3:end);
all_id_class = extractfield(all_id_class, 'name');

template_id_index_map = containers.Map('KeyType', 'double', 'ValueType', 'double');

for i_i = 1:length(all_id_class)
    id_class = all_id_class{i_i};
    id_class_split = regexp(id_class,'_','split');
%     template_id(i_i) = ;
    template_id_index_map(int32(str2double(id_class_split{1}))) = i_i;
    all_class(i_i) = str2double(id_class_split{2});
end

count = 0;
pre_allocate_size = 3000000;
all_scores = zeros(pre_allocate_size,1);
all_labels = zeros(pre_allocate_size,1);
% all_scores = [];
% all_labels = [];
all_scores_v2 = [];
all_labels_v2 = [];
for i_a = 1: size(all_pairs, 1)
    gal_id = all_pairs(i_a, 1);
    pro_id = all_pairs(i_a, 2);
    gal_index = template_id_index_map(gal_id);
    pro_index = template_id_index_map(pro_id);
    
    gal_dir_name = all_id_class{gal_index};
    all_gal_img = dir([root_dir filesep gal_dir_name]);
    all_gal_img = all_gal_img(3:end);
    
    pro_dir_name = all_id_class{pro_index};
    all_pro_img = dir([root_dir filesep pro_dir_name]);
    all_pro_img = all_pro_img(3:end);
    max_score = -Inf;
    
    fprintf('i_a:%d   gallery_length:%d  probe_length:%d\n',i_a,length(all_gal_img),length(all_pro_img));
%     tic
    for i_g = 1:length(all_gal_img)
        gal_name = [gal_dir_name filesep all_gal_img(i_g).name];
        gal_feature = img_feature_map(gal_name);
        for i_p = 1:length(all_pro_img)
            pro_name = [pro_dir_name filesep all_pro_img(i_p).name];
            pro_feature = img_feature_map(pro_name);
            score = compute_cosine_score(gal_feature, pro_feature);
            max_score = max(max_score, score);
            count = count + 1;
            all_scores(count) = score;
            all_labels(count) = (all_class(gal_index) == all_class(pro_index));
%             all_scores = [all_scores score];
%             all_labels = [all_labels all_class(gal_index) == all_class(pro_index)];
        end
    end
%     toc
    all_scores_v2 = [all_scores_v2 max_score];
    all_labels_v2 = [all_labels_v2 class(gal_index) == class(pro_index)];
    
end

if count <pre_allocate_size
    all_scores(count+1:end)=[];
    all_labels(count+1:end)=[];
end

end
