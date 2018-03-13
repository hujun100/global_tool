
function [all_class_index, all_class_id]= get_class_index(all_labels)
%% Now, I'm so tired to modify the name and write annotation
%%
%%
u_label = unique(all_labels);
all_class_index = cell(length(u_label), 1);
all_class_id = zeros(length(u_label), 1);
for i_u = 1:length(u_label)
    i_u
    label = u_label(i_u);
    index = find(all_labels == label);
    all_class_index{i_u} = index;
    all_class_id(i_u) = label;
end

end
