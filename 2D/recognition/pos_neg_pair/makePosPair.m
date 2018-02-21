function posPair=makePosPair(gal_txt,pro_txt,max_num,is_shuffle,output_txt)
%to build negtive pro by randomly choose the images in gal_txt and
%       pro_txt.The particular ratio of some specal class to some other
%       class is determined by the number of them in gal_txt and pro_txt.
%input:
%  gal_txt         --the gallery file that contains image name and its label 
%  pro_txt        --the probe file that contains image name and its label
%  max_num         --the max number of the final positive pro;
%  is_shuflle      --randomly permute the positive pro
%  output_txt      --if this parameter exists, this function writes postive
%                    pro to txt.
%
%output:
%  posPair         --positive pro txt
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
total_pos_pro=0;
for i_o=1:length(gal_label)
    for i_p=1:length(pro_label)
        if gal_label(i_o)==pro_label(i_p)
            total_pos_pro=total_pos_pro+1;
        end
    end
end
rand_thre=single(max_num+50)/total_pos_pro;
pos_pro_count=1;
for i_o=1:length(gal_label)
    for i_p=1:length(pro_label)
        if gal_label(i_o)==pro_label(i_p)
            if rand()<rand_thre
                posPair(pos_pro_count).gal_name=gal_name{i_o};
                posPair(pos_pro_count).pro_name=pro_name{i_p};
                posPair(pos_pro_count).label=1;
                if pos_pro_count>= max_num
                    break; % user can acclerate by set a stop flag
                end
                pos_pro_count=pos_pro_count+1;
            end
        end
    end
end
if is_shuffle
    r=randperm(length(posPair));
    posPair=posPair(r);
end
if nargin>4
    fid=fopen(output_txt,'wt');
    for i=1:length(posPair)
        fprintf(fid,'%s %s %d\n',posPair(i).gal_name,posPair(i).pro_name,posPair(i).label);
    end
    fclose(fid);
end

end
