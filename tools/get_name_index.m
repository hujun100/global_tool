
function [all_name_index, all_name_id]= get_name_index(all_name_input)
%% Nowadays, I'm so tired to modify the name and write annotation
%%
%%
reg_name = {};
u_name = unique(all_name_input);
all_name_index = cell(length(u_name), 1);
count = 0;
for i_l = 1:length(all_name_input)
    name = all_name_input{i_l};
    index = find(strcmp(reg_name, name));
    if isempty(index)
        reg_name = [reg_name(:);name];
        count = count + 1;
        all_name_index{count} = i_l;
        all_name_id{count} = name;
    else
        all_name_index{index} = [all_name_index{index} i_l];
    end
end
end
