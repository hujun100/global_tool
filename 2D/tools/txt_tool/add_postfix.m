function add_prefix(out_ffp,ffp, postfix)

fid = fopen(ffp);
fout = fopen(out_ffp,'wt');
while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end;
    fprintf(fout,'%s%s\n',tline,postfix);
end

fclose(fid);
fclose(fout);

end