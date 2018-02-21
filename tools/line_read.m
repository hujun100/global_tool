function all_lines = line_read(ffp, lines, param) 
%param.to_number
%param.regexp
%
%
%
if nargin < 3
    param = [];
end
fid = fopen(ffp);
cou = 0;
all_lines_cou = 0;
all_lines = cell(length(lines), 1);
%%% to resort the all_lines according to the order in lines
order_lines_map = zeros(length(lines), 1);
while 1
    cou = cou + 1;
    tline = fgetl(fid);
    if ~ischar(tline), break, end;
    if find(lines == cou)
        idx = find(lines == cou);
        all_lines_cou = all_lines_cou + 1;
        order_lines_map(idx) = all_lines_cou;
        if isfield(param, 'to_number') && isfield(param, 'regexp') && param.to_number
            tline_split = regexp(tline, param.regexp, 'split');
            splited_num = zeros(length(tline_split), 1);
            for i_s = 1:length(tline_split)
                 splited_num(i_s) = str2double(tline_split{i_s});
            end
            tline = splited_num;
        end
        all_lines{all_lines_cou} = tline;
    end
end
if isfield(param,'decell') && param.decell
    temp = zeros(length(all_lines), length(all_lines{1}));
    for i_t = 1:length(all_lines)
        temp(i_t,:) = all_lines{i_t}; 
    end
    all_lines = temp;
end

all_lines = all_lines(order_lines_map, :);

end
