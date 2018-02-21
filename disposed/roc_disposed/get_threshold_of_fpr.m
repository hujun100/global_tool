function threshold=get_threshold_of_fpr(scores,ground_truth,interval,is_descend,fpr)
%get threshold of fixed false positive rate for face verification
%input:
%  scores      -- the score for positive and negative pair
%  ground_thre -- the corrosponding label the positive and negative pair
%  interval    -- the code will tell you its function
%  is_descend  -- if the larger the score is,the more similar the pair,then
%              is_descend should be false.   Otherwise it should be true.
%  fpr         -- false positive rate
%
%Jun Hu
%2017-4
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
    [~,Index] = sort(scores,'descend');  %
else
    [~,Index] = sort(scores);  %
end
neg_sum=m-pos_sum;
for i=1:m
    temp(i)=ground_truth(Index(i));
end
ground_truth=temp;
x=zeros(m+1,1);
y=zeros(m+1,1);
x(1)=0;
y(1)=0;
cou=2;
for i=2:interval:m
%     i
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
    x(cou)=FP/neg_sum;
    if x(cou-1)>fpr && x(cou)<fpr
        threshold=scores(i);
        return;
    end
    cou=cou+1;
    
end

end