addpath(genpath('~/github/global_tool'));
labels = [ones(200,1);zeros(200,1)];
acc = zeros(10,1);
for i = 1:10
    begin_ind = (i-1)*400;
    end_ind = i*400-1;
    scores = [];
    for i_i = begin_ind:end_ind
        i_i
         left_name = [num2str(i_i, '%04d') '_0.jpg'];
         right_name = [num2str(i_i, '%04d') '_1.jpg'];
         left_feature = img_feature_map(left_name);
         right_feature = img_feature_map(right_name);
         scores = [scores; compute_cosine_score(left_feature, right_feature)];
    end
%     [~,~,info] = vl_roc(scores,labels);
    acc(i) = evaluation.accuracy.eval_best(scores,labels);
end
mean(acc)