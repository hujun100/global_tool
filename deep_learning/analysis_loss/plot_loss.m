
function plot_loss(filename,begin_num)
if nargin==1
  begin_num=10;
end
fid=fopen(filename,'r');
regpat = 'Iteration [0-9]+ ([0-9\.e-]+ iter/s, [0-9\.e-]+s/[0-9\.e-]+ iters\), loss = [0-9\.]+';
regpat2 = 'loss = [0-9\.]+';
iter = zeros(100000,1);
loss = zeros(100000,1);
p = 1;
while ~feof(fid)
    newline=fgetl(fid);
    o3=regexpi(newline,regpat,'match');
%     o4=regexpi(newline,regpat2,'match');
%     if ~isempty(o4)
% %         iterloss = sscanf(o3{1},'Iteration %d,.* loss = %f');
% %         iter(p) = iterloss(1);
% %         loss(p) = iterloss(2);
% %         p=p+1;
%     end;
    if ~isempty(o3)
        iterloss = sscanf(o3{1},'Iteration %f (%f iter/s, %fs/%f iters), loss = %f');
        iter(p) = iterloss(1);
        loss(p) = iterloss(5);
        p=p+1;
    end;
end;
fclose(fid);
iter = iter(begin_num:p-1);
loss = loss(begin_num:p-1);
plot(iter,loss);
