function mean_value=compute_image_mean(img_dir,list_txt,is_gray)
%notices: if the number of the image is larger than 1.3344e+36,you should
%          change the type of mean_value to double or long and so on.
%            This code assumes that all images are gray or rgb; 
%
%input:img_dir    --the direcory contains images          
%      list_txt   --the txt contains lines such as *.png *.jpg.
%           Notices:gallery(probe)_dir+(lines in gallery(probe)_txt) should be the
%           full path of all images
%      is_gray    --the type of the images.
%
%output:
%       mean_value --the mean value. If the images are rgb,the mean_value
%                    is red green blue in order
%
%Jun Hu
%2017-4
fid=fopen(list_txt,'rt');
list=textscan(fid,'%s %d');
name=list{1};
if is_gray
    total_mean_value=0;
else
    total_mean_value=zeros(1,3);
end
total_mean_value=single(total_mean_value);

for i=1:length(name)
    img=imread([img_dir filesep name{i}]);
    height=size(img,1);
    width=size(img,2);
    if is_gray
        assert(size(img,3)==1)
        temp=single(sum(sum(img)))/height/width;
        total_mean_value=total_mean_value+temp(:);
    else
        assert(size(img,3)==3)
        temp=(single(sum(sum(img)))/height/width);
        total_mean_value(:)=total_mean_value(:)+temp(:); 
    end
end
mean_value=total_mean_value/length(name);

end