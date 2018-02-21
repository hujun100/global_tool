clear;
fid = fopen('splits_corrected.txt');
tline = fgetl(fid);
for i = 1:500*10
    i
    split_num = 1 + floor((i-1)/500);
    if mod(i-1,500) == 0
        if exist('fout','var')
            fclose(fout);
        end
        fout = fopen(['splits_10/splits_' num2str(split_num)],'wt');
    end
   tline = fgetl(fid);
%    if ~ischar(tline),break,end;
   exp_split = regexp(tline,',','split');
%    assert((str2double(exp_split{1}) == split_num),'error');
   exp_split{3} = [exp_split{3}(2:end) '.jpg'];
   exp_split{4} = [exp_split{4}(2:end) '.jpg'];
   fprintf(fout,'%s %s %s\n',exp_split{3}, exp_split{4}, exp_split{6});
end