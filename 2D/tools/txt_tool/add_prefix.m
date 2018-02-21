function add_prefix(out_ffp,ffp, prefix)

fid = fopen(ffp);
fout = fopen(out_ffp,'wt');
while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end;
    fprintf(fout,'%s%s\n',prefix,tline);
end

fclose(fid);
fclose(fout);

end