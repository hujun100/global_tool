
gal_txt =  '/home/scw4750/Dataset/huochezhan/railway_evaluation/v1/gallery.txt';
pro_txt =  '/home/scw4750/Dataset/huochezhan/railway_evaluation/v1/probe.txt';

rank = compute_rank_from_img_feature_map(gal_img_feature_map, pro_img_feature_map, ...
    gal_txt, pro_txt);
