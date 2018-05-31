function trans = get_similarity_trans()

coord = [30, 65, 48, 33, 62; ...
    51, 51., 71, 92, 92];

face(1,1:5) = [466,617,511,428,571];
face(2,1:5) = [365,415,496,518,562];
c1 = mean(face, 2);
c2 = mean(coord, 2);
face = face - c1;
coord = coord - c2;
s1 = std(face(:));
s2 = std(coord(:));

face = face / s1;
coord = coord / s2;

[u, s, vt] = svd(face * coord');
r = (u *vt)';
trans = [r * s2/s1, c2 - (s2/s1)*r*c1];

end