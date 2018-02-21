function img_cropped=centerloss_align_single(img,ffp_fn)  
        
        imgSize = [112, 96]; 
        fid=fopen(ffp_fn,'rt');
        facial_point=textscan(fid,'%f');
        facial_point=facial_point{1};
        fclose(fid);
        
        coord5points = [30.2946, 65.5318, 48.0252; ...
            51.6963, 51.5014, 71.7366];
        facial5points(1,1:3)=facial_point(1:2:6);
        facial5points(2,1:3)=facial_point(2:2:6);
        Tfm =  cp2tform(facial5points', coord5points', 'similarity');
        img_cropped = imtransform(img, Tfm, 'XData', [1 imgSize(2)],...
            'YData', [1 imgSize(1)], 'Size', imgSize);

end
