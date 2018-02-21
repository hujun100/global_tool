% judge if this triangle cover the point
function [state] = triCpoint(point, pt)

point = point';
pt = pt';
pt1 = pt(:,1);
pt2 = pt(:,2);
pt3 = pt(:,3);
state = 1;

v0 = pt3 - pt1; %C - A
v1 = pt2 - pt1; %B - A 
v2 = point - pt1;

dot00 = v0' * v0;
dot01 = v0' * v1;
dot02 = v0' * v2;
dot11 = v1' * v1;
dot12 = v1' * v2;

inverDeno = 1 / (dot00 * dot11 - dot01 * dot01);

u = (dot11 * dot02 - dot01 * dot12) * inverDeno;

if(u < 0 || u > 1)
    state = 0;
    return;
end

v = (dot00 * dot12 - dot01 * dot02) * inverDeno;
if(v < 0 || v > 1)
    state = 0;
    return;
end

state = u + v <= 1;

end

