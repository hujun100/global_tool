%  Copyright (c) 2014, Karen Simonyan
%  All rights reserved.
%  This code is made available under the terms of the BSD license (see COPYING file).

function [res, bestThresh] = eval_best(scores, gt, interval)
    
if nargin==2
  interval = 1;
end
    % finds an optimal threshold - the threshold which maximises the accuracy

    % threshold scores and get the sign
    gt(gt==0)=-1;
    res = -Inf;
    bestThresh = [];
    
    % thresh loop
    for i=1:interval:numel(scores)
         i
        curThresh = scores(i);
        class = 2 * (scores >= curThresh) - 1;
        
        % class-n accuracy
        acc = mean(class == gt);
        
        if acc > res
            
            res = acc;
            bestThresh = curThresh;            
        end
    end
    
    res = res * 100;
    
end
