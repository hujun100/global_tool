clear;
 load('analysis.mat');
addpath(genpath('..'));
distance=analysis.distance_matrix;
gallery=analysis.gallery_info;
probe=analysis.probe_info;
num=1;
for i_r=1:size(distance,1)
   for i_c=1:size(distance,2)
      scores(num)=distance(i_r,i_c);
      labels(num)=(gallery(i_c).label==probe(i_r).label);
      num=num+1;
   end
end
ROC(scores,labels,1000,0);