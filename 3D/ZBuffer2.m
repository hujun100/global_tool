function [depth_map] = ZBuffer2(shape, proj_land, face,vis)

% input:  proj_land   n*2
% Feng Liu   02-12-2017

V2 = proj_land;
Z = shape(:, 3);

UV(:, 1)    = V2(:, 1) ;	% orthographic projection for x
UV(:, 2)    = V2(:, 2) ;	% orthographic projection for y

% Get the triangle vertices
v1      = face(:, 1);
v2      = face(:, 2);
v3      = face(:, 3);
Nfaces  = size(face, 1);

% Compute bounding boxes for the projected triangles
x       = [UV(v1, 1), UV(v2, 1), UV(v3, 1)];
y       = [UV(v1, 2), UV(v2, 2), UV(v3, 2)];
minx    = ceil (min(x, [], 2));
maxx    = floor(max(x, [], 2));
miny    = ceil (min(y, [], 2));
maxy    = floor(max(y, [], 2));
clear x y
width = 640;
height = 480;
% Frustum culling
minx    = max(1,        minx);
maxx    = min(width,    maxx);
miny    = max(1,        miny);
maxy    = min(height,   maxy);

[rows, cols] = meshgrid(1: width, 1: height);

% Initialize the depth-, face- and weight-buffers
zbuffer     = zeros(height, width);
% For each triangle (can speed up by comparing the triangle depths to the z-buffer and priorly sorting the triangles by increasing depth)
for i = 1: Nfaces
    if vis(face(i,1))>0 || vis(face(i,2))>0 || vis(face(i,3))>0
        % If some pixels lie in the bounding box
        if minx(i) <= maxx(i) && miny(i) <= maxy(i)
            
            % Get the pixels lying in the bounding box
            px = rows(miny(i): maxy(i), minx(i): maxx(i));
            py = cols(miny(i): maxy(i), minx(i): maxx(i));
            px = px(:);
            py = py(:);
            
            % Compute the edge vectors
            e0 = UV(v1(i), :);
            e1 = UV(v2(i), :) - e0;
            e2 = UV(v3(i), :) - e0;
            
            % Compute the barycentric coordinates (can speed up by first computing and testing a solely)
            det     = e1(1) * e2(2) - e1(2) * e2(1);
            tmpx    = px - e0(1);
            tmpy    = py - e0(2);
            a       = (tmpx * e2(2) - tmpy * e2(1)) / det;
            b       = (tmpy * e1(1) - tmpx * e1(2)) / det;
            
            % Test whether the pixels lie in the triangle
            test = a >= 0 & b >= 0 & a + b <= 1;
            
            % If some pixels lie in the triangle
            if any(test)
                
                % Get the pixels lying in the triangle
                px = px(test);
                py = py(test);
                
                % Interpolate the triangle depth for each pixel
                w2 = a(test);
                w3 = b(test);
                w1 = 1 - w2 - w3;
                pz = Z(v1(i)) * w1 + Z(v2(i)) * w2 + Z(v3(i)) * w3;
                
                for j = 1: length(pz)
                    
                    %if pz(j) > zbuffer(py(j), px(j))
                    zbuffer(py(j), px(j))   = pz(j);
                    fbuffer(py(j), px(j))   = i;
                    
                    %end
                end
                
            end
            
        end
    else
        continue;
    end
end

depth_map = zbuffer;
