function result = is_big_angle(img_file)
result = false;
file_5pt = [img_file(1:end-3) '5pt'];

[lm, ~] = read_5pt(file_5pt);
f5pt = lm;
if (f5pt(1,1)<f5pt(3,1) && f5pt(2,1)<f5pt(3,1)) || (f5pt(1,1)>f5pt(3,1) && f5pt(2,1)>f5pt(3,1)) ...
        || (f5pt(5,1)<f5pt(3,1) && f5pt(4,1)<f5pt(3,1)) || (f5pt(4,1)>f5pt(3,1) && f5pt(2,1)>f5pt(3,1))
    result = true;
end

eye_slope = (f5pt(2,2) - f5pt(1,2))/(f5pt(2,1) -f5pt(1,1));
mouse_slope = (f5pt(5,2) - f5pt(4,2))/(f5pt(5,1) -f5pt(4,1));
if abs(eye_slope - mouse_slope) > 0.18
    result = true;
end
end