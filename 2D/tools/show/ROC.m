function [Tps, Fps] = ROC(scores, ground_truth,interval,is_descend)  
%draw roc
%input:
%  scores      -- the score for positive and negative pair
%  ground_thre -- the corrosponding label the positive and negative pair
%  interval    -- the code will tell you its function
%  is_descend  -- if the larger the score is,the more similar the pair,then
%              is_descend should be false.   Otherwise it should be true.
if nargin == 2
    interval=5;
    is_descend=false;
end
if nargin == 3
    is_descend=false; 
end
m=length(scores);
pos_sum=0;
for i=1:m
   %scores(i)= dot(probe(i,:),gallery(i,:))/(norm(probe(i,:))*norm(gallery(i,:)));
   %ground_truth(i)=lines(i,2);
   if ground_truth(i)==1
       pos_sum=pos_sum+1;
   end
end
if is_descend
    [pre,Index] = sort(scores,'descend');  %
else
    [pre,Index] = sort(scores);  %
end
neg_sum=m-pos_sum;
for i=1:m
        temp(i)=ground_truth(Index(i));
end
ground_truth=temp;
    x=zeros(m+1,1);
    y=zeros(m+1,1);
    auc=0;
    x(1)=1;
    y(1)=1;
    
    for i=2:interval:m
        %TP=sum(ground_truth(i:m)==1);
        %FP=sum(ground_truth(i:m)==0);
        TP=0;FP=0;
        for j=i:m     
            if ground_truth(j)==1  %we think it is positive
                TP=TP+1;
            else
                FP=FP+1;
            end
        end
        x(i)=FP/neg_sum;
        y(i)=TP/pos_sum;
        auc=auc+(y(i)+y(i-1))*(x(i-1)-x(i))/2;
    end
    x(m+1)=0;
    y(m+1)=0;
    %auc=auc+y(m+1)*x(m+1)/2 
    plot(x,y,'.');
    hold on;
    xlabel('FPR');ylabel('TPR');
    title('ROC curve');
