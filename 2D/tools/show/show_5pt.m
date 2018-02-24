function show_5pt(img_ffp)

img = imread(img_ffp);
[lm, bbox] = read_5pt([img_ffp '.5pt']);
imshow(img);
hold on;
plot(lm(:,1),lm(:,2),'.r', 'LineWidth',3);
rectangle('Position', bbox, 'edgecolor', 'g');
hold off;
end
