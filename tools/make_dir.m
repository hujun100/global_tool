function make_dir(ffp)
%
%
ffp_split = regexp(ffp, filesep, 'split');
folder = '';
for i = 1:length(ffp_split)-1
    folder = [folder ffp_split{i} filesep];
    if ~exist(folder, 'dir')
       mkdir(folder);
    end 
end
end
