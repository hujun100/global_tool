clear;
%%%%%%% to write map between template ID and image file name
%%%%%%% to write galllery and probe txt file


root_dir = '/home/scw4750/Dataset/IJB-A/IJB-A_1N_sets';

%%%%%%% to write map between template ID and image file name

for i = 1:10
    gal_ffp = [root_dir filesep 'split' num2str(i) '/search_gallery_' num2str(i) '.csv'];
    gal_ID_file_map = get_ID_file_map(gal_ffp);
    pro_ffp = [root_dir filesep 'split' num2str(i) '/search_probe_' num2str(i) '.csv'];
    pro_ID_file_map = get_ID_file_map(pro_ffp);
    save(['split_10_identification' filesep 'split_' num2str(i) '_gal_ID_file_map.mat'], ...
        'gal_ID_file_map', 'pro_ID_file_map');
end
%%%%% end


%%%%%%% to write galllery and probe txt file
% for i = 1:10
%     gal_fid = fopen([root_dir filesep 'split' num2str(i) '/search_gallery_' num2str(i) '.csv']);
%     gal_fout = fopen(['split_10_identification/split_' num2str(i) '_gal.txt'],'wt');
%     tline=fgetl(gal_fid);
%     cou = 0;
%     while 1
%         cou = cou + 1
%        tline  = fgetl(gal_fid);
%        if ~ischar(tline), break,end;
%        line_split = regexp(tline,',','split');
%        fprintf(gal_fout, '%s %s\n',line_split{3},line_split{2});
%     end
%     pro_fid = fopen([root_dir filesep 'split' num2str(i) '/search_probe_' num2str(i) '.csv']);
%     pro_fout = fopen(['split_10_identification/split_' num2str(i) '_pro.txt'],'wt');
%     tline = fgetl(pro_fid);
%     while 1
%        cou = cou +1
%        tline = fgetl(pro_fid);
%        if ~ischar(tline), break,end;
%        line_split = regexp(tline,',','split');
%        fprintf(pro_fout, '%s %s\n',line_split{3}, line_split{2});
%     end
%     fclose(gal_fid);
%     fclose(gal_fout);
%     fclose(pro_fout);
%     fclose(pro_fid);
% end
%%%%%% end
