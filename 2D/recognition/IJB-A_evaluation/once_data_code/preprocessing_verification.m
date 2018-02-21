clear;

% %%%%get template ID and image file mapping
% %%%%% get gallery and probe to calculate analysis matrix per split(they are same in verification)
%%%% get a txt file that contains all genuine and imposter pair






% %%%%get template ID and image file mapping
% root_dir = '/home/scw4750/Dataset/IJB-A/IJB-A_11_sets'
% cou = 0;
% for i = 1:10
%    csv_name = [root_dir filesep 'split' num2str(i) filesep 'verify_metadata_' num2str(i) '.csv'];
%    ID_file_map = get_ID_file_map(csv_name);
%    save(['split_10_verification' filesep 'split_' num2str(i) '_ID_file_map.mat'], 'ID_file_map');
% end
% %%%% end

% %%%%% get gallery and probe to calculate analysis matrix per split(they are same in verification)
% for i = 1:10
%     gal_fid = fopen([root_dir filesep 'split' num2str(i) filesep 'verify_metadata_' num2str(i) '.csv']);
%     gal_fout = fopen(['split_10_verification' filesep 'split_' num2str(i) '_gal.txt'], 'wt');
%     pro_fout = fopen(['split_10_verification' filesep 'split_' num2str(i) '_pro.txt'], 'wt');
%     tline = fgetl(gal_fid);
%     while 1
%         cou = cou + 1
%         tline = fgetl(gal_fid);
%         if ~ischar(tline), break, end;
%         line_split = regexp(tline, ',', 'split');
%         fprintf(gal_fout,'%s %s\n', line_split{3}, line_split{2});
%         fprintf(pro_fout,'%s %s\n', line_split{3}, line_split{3});
%     end
%     fclose(gal_fout); fclose(pro_fout);
% end
% %%%%%%end

%%%% get a txt file that contains all genuine and imposter pair
root_dir = '/home/scw4750/Dataset/IJB-A';
cou = 0;
for i = 1:10
    fid = fopen([root_dir filesep 'IJB-A_11_sets/split' num2str(i) '/verify_metadata_' num2str(i) '.csv']);
    all_pair =importdata([root_dir filesep 'IJB-A_11_sets/split' num2str(i) '/verify_comparisons_' num2str(i) '.csv']);
    fout = fopen(['split_10_verification/split_' num2str(i) '_genuine_imposter_pair.txt'],'wt');
    tline=fgetl(fid);
    while 1
        cou = cou + 1
        tline = fgetl(fid);
        if ~ischar(tline), break,end;
        line_split = regexp(tline,',','split');
        metadata(cou,1) = str2double(line_split{1});
        metadata(cou,2) = str2double(line_split{2});
        metadata_file{cou} = line_split{3};
        %         all_template_id = [all_template_id ];
        %                 all_template_id = unique(all_template_id);
        %         all_files = [all_files ];
        %         all_files = unique(all_files);
        %         all_sub_id = [all_sub_id ];
        %         all_sub_id = unique(all_sub_id);
    end
    pos_cou = 0;
    neg_cou = 0;
    for i_a = 1: size(all_pair,1)
        i_a
        gal_idx = find(metadata(:,1) == all_pair(i_a,1));
        pro_idx = find(metadata(:,1) == all_pair(i_a,2));
        for i_g = 1:length(gal_idx)
            for i_p = 1:length(pro_idx)
                sing_gal_idx = gal_idx(i_g);
                sing_pro_idx = pro_idx(i_p);
                if metadata(sing_gal_idx,2) == metadata(sing_pro_idx,2)
                    pos_cou = pos_cou + 1;
                    fprintf(fout, '%s %s 1\n', metadata_file{sing_gal_idx}, metadata_file{sing_pro_idx});
                else
                    neg_cou = neg_cou + 1;
                    fprintf(fout, '%s %s 0\n', metadata_file{sing_gal_idx}, metadata_file{sing_pro_idx});
                end
            end
        end
        
        sing_gal_idx = gal_idx(randi(length(gal_idx)));
        sing_pro_idx = pro_idx(randi(length(pro_idx)));
        if metadata(sing_gal_idx,2) == metadata(sing_pro_idx,2)
            pos_cou = pos_cou + 1;
            fprintf(fout, '%s %s 1\n', metadata_file{sing_gal_idx}, metadata_file{sing_pro_idx});
        else
            neg_cou = neg_cou + 1;
            fprintf(fout, '%s %s 0\n', metadata_file{sing_gal_idx}, metadata_file{sing_pro_idx});
        end
        
    end
    fclose(fout);
end