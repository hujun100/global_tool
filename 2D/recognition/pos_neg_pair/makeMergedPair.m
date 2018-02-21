function mergedPair=makeMergedPair(output_txt,gal_txt,pro_txt,pos_max_num,neg_max_num,is_shuffle)
%make merged postive and negative pro together
%input:
%  gal_txt         --the gallery file that contains image name and its label 
%  pro_txt        --the probe file that contains image name and its label
%  pos_max_num         --the max number of the final positive pro;
%  neg_max_num         --the max number of the final neg pro;
%  is_shuflle      --randomly permute the negitive pro
%  output_txt      --if this parameter exists, this function writes merged
%                    pro to txt.
%
%Jun Hu
%2017-4
if nargin <=5
    is_shuffle = false;
end
posPair=makePosPair(gal_txt,pro_txt,pos_max_num,0);
negPair=makeNegPair(gal_txt,pro_txt,neg_max_num,0);

mergedPair=[posPair,negPair];
if is_shuffle
    r=randperm(length(mergedPair));
    mergedPair=mergedPair(r);
end

fid=fopen(output_txt,'wt');
for i=1:length(mergedPair)
    fprintf(fid,'%s %s %d\n',mergedPair(i).gal_name,mergedPair(i).pro_name,mergedPair(i).label);
end
fclose(fid);


end
