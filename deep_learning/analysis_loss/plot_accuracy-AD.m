filename = 'D:\HFX\RealSense_station_EXP_0730\Exp_dengzp_4\INFO2016-08-08T13-41-02.txt';
fid=fopen(filename,'r');
regpat_test = 'Test net output #0: accuracy = [0-9\.]+';
% regpat_train = 'Train net output #0: loss = [0-9\.]+';
accuracy_test = [];
% accuracy_train = zeros(401,1);
p = 1;
q=1;
while ~feof(fid)
    newline=fgetl(fid);
    o3_test=regexpi(newline,regpat_test,'match');
%     o3_train=regexpi(newline,regpat_train,'match');
    if ~isempty(o3_test)
        iterloss_test = sscanf(o3_test{1},'Test net output #0: accuracy = %f');
        accuracy_test(p) = iterloss_test(1);
         p = p+1;
    end;
   
end;


fclose(fid);
p=p-1;
accuracy_test = accuracy_test(1:p);
x_n=p;
x=[0:x_n-1]*1000;
% accuracy_train=[accuracy_train ;0.226259];
hold on
plot(x,accuracy_test);
% hold on 
% plot(x,accuracy_train);
