function show_pc_with_shape(input,color)
%input should be N*3
%default show order ".ox+*"
%
%
if nargin<2
    color = '*.ox+'; 
end

for i = 1:size(input, 1)
    show_pc(input(i,:), ['r' color( 1 + mod(i, length(color)))]); 
    hold on;
end

end
