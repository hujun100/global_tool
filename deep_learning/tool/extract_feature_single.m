function [feature]=extract_feature_single(img_dir,img_file,img_size,data_key,feature_key,net,preprocess_param,is_gray,norm_type,averageImg)

img=imread([img_dir img_file]);
%Get facial points because we only know img_dir here
%facial points should be stored as left-eye-x left-eye-y right-eye-x right-eye-y ...
%                                   nose-x  nose-y left-mouse-x
%                                   left-mouse-y right-mouse-x
%                                   right-mouse-y

if isfield(preprocess_param,'do_alignment') && preprocess_param.do_alignment

    assert(isfield(preprocess_param,'align_param'),'align_param should be provided\n');
    align_param=preprocess_param.align_param;
    pts_postfix='5pt';
    if isfield(align_param,'pts_postfix')
        pts_posfix=align_param.pts_posfix;
    end
    idx=strfind(img_file,'.');

    assert(logical(exist([img_dir filesep img_file(1:idx(end)) pts_postfix],'file')),'feature points should be provided and stored aside images');
    fid=fopen([img_dir filesep img_file(1:idx(end)) pts_postfix],'rt');
    facial_point=textscan(fid,'%f');
    fclose(fid);
    facial_point=facial_point{1};
    preprocess_param.align_param.facial_point=facial_point;
end
feature=extract_feature_single_image(img,img_size,data_key,feature_key,net,preprocess_param,is_gray,norm_type,averageImg);
end
