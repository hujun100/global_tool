function pc=pc_normalization(pc,de_dense)
% note: pc's shape should be 1*N*3
%
%
%
if nargin<2
  de_dense = false;
end
   pc=reshape(pc,3,length(pc)/3);
   me=mean(pc,2);
   for i_c =1:3
       pc(i_c,:)=pc(i_c,:)-me(i_c);
   end
   max_radius=sqrt(max(sum(pc.*pc)));
   pc=pc/max_radius;
   if de_dense
     r=randperm(size(pc,2));
     pc=pc(:,r);
   end
end
