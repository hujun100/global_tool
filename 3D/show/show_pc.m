function show_pc(input,color)
if nargin<2
 color='.g';
end
input = squeeze(input);
if size(input, 1) == 1
   input = reshape(input, length(input)/3, 3); 
end
input = input';
plot3(input(1,:),input(2,:),input(3,:),color);
xlabel('x');
ylabel('y');
zlabel('z');
end
