
root_dir = '/home/scw4750/Dataset/IJB-A/IJB-A_11_sets';
save_dir = 'split_10_verification';
prefix = 'verify_metadata_';
convert_csv2mat(root_dir, save_dir, prefix);

% root_dir = '/home/scw4750/Dataset/IJB-A/IJB-A_1N_sets';
% save_dir = 'split_10_identification';
% prefix = 'search_gallery_';
% postfix = '_gallery';
% convert_csv2mat(root_dir, save_dir, prefix, postfix);
% 
% prefix = 'search_probe_';
% postfix = '_probe';
% convert_csv2mat(root_dir ,save_dir, prefix, postfix);

function convert_csv2mat(root_dir, save_dir, prefix, postfix)

if nargin<4
    postfix = '';
end

for i = 1 : 10
    ffp = [root_dir filesep 'split' num2str(i) filesep prefix num2str(i) '.csv'];
    fid = fopen(ffp);
    cou = 0;
    while 1
        cou = cou + 1
        tline = fgetl(fid);
        if ~ischar(tline), break, end;
        tline_split = regexp(tline, ',', 'split');
        for i_t = 1:length(tline_split)
            info{cou, i_t} = tline_split{i_t};
        end
    end
    save([save_dir filesep 'info_' num2str(i) postfix '.mat'], 'info');
    fclose(fid);
end

end