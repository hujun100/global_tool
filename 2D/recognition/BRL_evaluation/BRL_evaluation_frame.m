
gal_txt_with_label = '/home/scw4750/Dataset/BRL/gallery.txt';
pro_txt_with_label = '/home/scw4750/Dataset/BRL/frame_probe.txt';
rank = compute_rank_from_img_feature_map(gal_img_feature_map, pro_img_feature_map, ...
    gal_txt_with_label, pro_txt_with_label);
