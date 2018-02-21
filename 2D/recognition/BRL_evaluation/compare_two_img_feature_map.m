left = pro_75w;
right = pro_8w;
all_scores = [];
for i = 1:length(left)
    all_keys = left.keys();
    key = all_keys{i};
    left_feature = left(key);
    right_feature = right(key);
    score = compute_cosine_score(left_feature, right_feature);
    all_scores = [all_scores score];
end
min(min(all_scores))