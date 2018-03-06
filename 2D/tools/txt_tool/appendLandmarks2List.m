addpath(genpath('~/github/global_tool'));
data = importdata('/home/brl/TRAIN/DataSet/morph2_complete/testList.txt');
data_dir = '/home/brl/TRAIN/DataSet/morph2_complete/alignedTestList';
out_ffp = '/home/brl/TRAIN/DataSet/morph2_complete/testListWithLandmarks.txt';
all_paths = data.textdata;
all_labels = data.data;
fid = fopen(out_ffp, 'wt');
for i = 1:length(all_paths)
    i
    path = all_paths{i};
    try
        [lm, ~] = read_5pt([fullfile(data_dir, path) '.5pt']);
    catch
        lm = [30.2946, 65.5318, 48.0252, 33.5493, 62.7299; ...
            51.6963, 51.5014, 71.7366, 92.3655, 92.2041]' + 3;
    end
    lm = int8(lm);
    if lm(1, 1) - 15 > 0 && lm(1, 1) +55 < 100 && lm(1, 2) - 10 > 0 && lm(1,2) +10 < 100
        fprintf(fid, '%s %d %d %d %d %d %d %d %d %d %d %d\n', path, all_labels(i),...
            lm(1,1),lm(1,2),lm(2,1),lm(2,2),lm(3,1),lm(3,2),lm(4,1),lm(4,2),...
            lm(5,1),lm(1,2));
    else
        %%% for test images which must be processed
%         fprintf('some images you should take care of. continue?');
%         pause;
%         lm = [30.2946, 65.5318, 48.0252, 33.5493, 62.7299; ...
%             51.6963, 51.5014, 71.7366, 92.3655, 92.2041]' + 3;
%         lm = int8(lm);
%         fprintf(fid, '%s %d %d %d %d %d %d %d %d %d %d %d\n', path, all_labels(i),...
%             lm(1,1),lm(1,2),lm(2,1),lm(2,2),lm(3,1),lm(3,2),lm(4,1),lm(4,2),...
%             lm(5,1),lm(1,2));
    end
end
fclose(fid);

