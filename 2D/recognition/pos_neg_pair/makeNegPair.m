function negPair=makeNegPair(gal_txt,pro_txt,max_num,is_shuffle,output_txt)
%to build negtive pro by randomly choose the images in gal_txt and
%       pro_txt.The particular ratio of some specal class to some other
%       class is determined by the number of them in gal_txt and pro_txt.
%input:
%  gal_txt         --the gallery file that contains image name and its label 
%  pro_txt        --the probe file that contains image name and its label
%  max_num         --the max number of the final negitive pro;
%  is_shuflle      --randomly permute the negitive pro
%  output_txt      --if this parameter exists, this function writes negtive
%                    pro to txt.
%
%output:
%  posPair         --it has field gal_name,pro_name,label
%Jun Hu
%2017-3
fid=fopen(gal_txt,'rt');
gal=textscan(fid,'%s %d');
gal_name=gal{1};
gal_label=gal{2};
assert(length(gal_name)==length(gal_label));
fclose(fid);
fid=fopen(pro_txt,'rt');
pro=textscan(fid,'%s %d');
pro_name=pro{1};
pro_label=pro{2};
assert(length(pro_name)==length(pro_label));
fclose(fid);


total_neg_pro=0;
for i_o=1:length(gal_label)
    for i_p=1:length(pro_label)
        if gal_label(i_o)~=pro_label(i_p)
            total_neg_pro=total_neg_pro+1;
        end
    end
end
rand_thre=single(max_num+50)/total_neg_pro;
neg_pro_count=1;
for i_o=1:length(gal_label)
    for i_p=1:length(pro_label)
        if gal_label(i_o)~=pro_label(i_p)
            if rand()<rand_thre
                negPair(neg_pro_count).gal_name=gal_name{i_o};
                negPair(neg_pro_count).pro_name=pro_name{i_p};
                negPair(neg_pro_count).label=0;
                if neg_pro_count>= max_num
                    break; % we can acclerate by set a stop flag
                end
                neg_pro_count=neg_pro_count+1;
            end
        end
    end
end
if is_shuffle
    r=randperm(length(negPair));
    negPair=negPair(r);
end
if nargin>4
    fid=fopen(output_txt,'wt');
    for i=1:length(negPair)
        fprintf(fid,'%s %s %d\n',negPair(i).gal_name,negPair(i).pro_name,negPair(i).label);
    end
    fclose(fid);
end

end
