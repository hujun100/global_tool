function intersection=list_intersect(output_name,varargin)
%compute the intersection of two list(composed by image name and image label)
%input:
%  output_txt        --if the output_name is not 'NULL',the it indicates the output location of txt
%  varargin          --a series of list.
%output:
%  intersection
%
%exapmple:  list_intersect(list_a,list_b,list_c,list_d);
%           list_intersect(list_a,list_b);
%Jun Hu
%2017-4
fid=fopen(varargin{2});
a=textscan(fid,'%s %f');
a_name=a{1};
a_label=a{2};
fclose(fid);

inte=a_name;
for i_v=3:numel(varargin)
    fid=fopen(varargin{i_v});
    b=textscan(fid,'%s %f');
    b_name=b{1};
    inte=intersect(inte,b_name);
    fclose(fid);  
end
if strcmp(output_name,'NULL')
    for i=1:length(inte)
        intersection(i).name=inte{i};
        intersection(i).label=a_label(strcmp(a_name,inte{i}));
    end
else
    fid=fopen(output_name,'wt');
    for i=1:length(inte)
        intersection(i).name=inte{i};
        intersection(i).label=a_label(strcmp(a_name,inte{i}));
        fprintf(fid,'%s %d\n',intersection(i).name,intersection(i).label);
    end
end
end
