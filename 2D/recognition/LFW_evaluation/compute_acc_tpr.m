% clear;
acc_count = 0;
tpr_count = 0;
for i = 1:10
    acc_count = acc_count + all_acc{i};
    all_info{i}.tpr001
    tpr_count = tpr_count + all_info{i}.tpr001;
end