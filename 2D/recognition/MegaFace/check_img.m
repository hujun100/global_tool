data = importdata('faceScrub.txt');
root_dir = '/media/scw4750/pipa_IDcard/megaface/feature_FaceScrub/';
source_dir = '/media/scw4750/pipa_IDcard/megaface/ai/FlickrFinal2/';
for i = 1:length(data)
    i
    img_name = [data{i} '.bin'];
    if ~exist([root_dir img_name],'file')
%         img = imread([source_dir img_name]);
%         img = imresize(img, [256,256]);
%         imwrite(img, [root_dir img_name])
        fprintf('error\n')
    end
end