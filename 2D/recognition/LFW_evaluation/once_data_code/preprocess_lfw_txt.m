


fid = fopen('origin_pairs.txt');
for i = 1:6000
    if mod(i-1,600) == 0
      out_fid = fopen(['verification_split_10/lfw_pos_neg_split_' num2str(floor((i-1)/600)+1) '.txt'],'wt');
    end
    
   tline = fgetl(fid);
   if ~ischar(tline), break, end
   split_res = regexp(tline, '\t', 'split');
   if length(split_res) == 3
       prefix = [split_res{1} filesep split_res{1} '_']; 
       gal = [prefix format_number(split_res{2}) '.jpg'];
       pro = [prefix format_number(split_res{3}) '.jpg'];
       fprintf(out_fid, '%s %s 1\n',gal,pro);
   else
       assert(length(split_res)==4,'neg txt error');
       gal = [split_res{1} filesep split_res{1} '_' format_number(split_res{2}) '.jpg'];
       pro = [split_res{3} filesep split_res{3} '_' format_number(split_res{4}) '.jpg'];
       fprintf(out_fid, '%s %s 0\n', gal, pro);
   end
end
fclose(fid);
fclose(out_fid);

function number = format_number(name)

number = num2str(str2double(name),'%04d');

end