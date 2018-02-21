% lm2  51*2 matrix
right_eye_ind = [37:42]-17;
left_eye_ind = [43:48]-17;
nose_mouse_ind = [31 49 55]-17;
t_lm2 = [mean(lm2(right_eye_ind, :));mean(lm2(left_eye_ind, :);mean(nose_mouse_ind, :)))];
