function [pts, bbox, num_pts] = read_multi_5pt(ffp_fn)
%pts: 
%  size:2*5
%  [left-eye-center-x  right-eye-center-x  nose-x   left-mouse-center-x right-mouse-center-x  
%   left-eye-center-y  right-eye-center-y  nose-y   left-mouse-center-y right-mouse-center-y]
%bbox: 
%  left-upper-x left-upper-y height width
%

fid = fopen(ffp_fn);
cou = 1;
pts_cou = 1;
bbox_cou = 1;
while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end;
    tline_split = regexp(tline, ' ', 'split');
    if mod(cou,6) == 0
        assert(length(tline_split) == 5, 'bbox in 5pt is wrong');
        for i_b = 1:4
            bbox(bbox_cou, i_b) = str2double(tline_split{i_b});
        end
        bbox_cou = bbox_cou + 1;
    else
        for i_p = 1:2
            pts(pts_cou, i_p) = str2double(tline_split{i_p});
        end
        pts_cou = pts_cou + 1;
    end
    cou = cou + 1;
end
num_pts = bbox_cou - 1;
assert( mod(cou -1, 6) == 0 , 'wrong in 5pt');
end
