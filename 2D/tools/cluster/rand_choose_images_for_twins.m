
folder = dir('result');
folder = folder(3:end);
out_root = 'result_twins';
for i_f = 1:length(folder)
     folder_sub = dir([folder(i_f).folder filesep folder(i_f).name filesep '*.jpg']);
     r = randperm(length(folder_sub));
     for i_i = 1:3
         idx = r(i_i);
         out_sub_folder = [out_root filesep folder(i_f).name];
         if ~exist(out_sub_folder,'dir')
             mkdir(out_sub_folder);
         end
         copyfile([folder_sub(idx).folder filesep folder_sub(idx).name], ...
             [out_sub_folder filesep folder_sub(idx).name]);
     end
end