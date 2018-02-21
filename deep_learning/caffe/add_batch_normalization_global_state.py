import re
bn_key = 'use_global_stats'
layer_key = 'layer'
ffp = 'test.txt'
layer_pattern = re.compile(layer_key)
bn_pattern = re.compile(bn_key)
fout = open('out.txt','wt')

layer_begin = -1
layer_end = layer_begin
write_bn_test_flag = False
with open(ffp,'rt') as f:
    all_lines = f.readlines()
    all_write_lines=all_lines[:]
    accum_change = 0
    for idx in range(len(all_lines)):
        print(idx)
        line = all_lines[idx]
        if len(layer_pattern.findall(line)) != 0:
            layer_begin = layer_end
            layer_end = idx
            if write_bn_test_flag == True:
                for i_bn in range(layer_begin, global_stats_idx - 1):
                    all_write_lines.insert(layer_end+accum_change, all_lines[i_bn])
                    accum_change = accum_change + 1 
                all_write_lines.insert(layer_end+accum_change,'    batch_norm_param{ use_global_stats: true}\n')
                accum_change  = accum_change + 1
                all_write_lines.insert(layer_end+accum_change, '    include {phase: TEST}\n')
                accum_change = accum_change + 1
                for i_bn in range(global_stats_idx + 2,layer_end):
                    all_write_lines.insert(layer_end+accum_change, all_lines[i_bn])
                    accum_change = accum_change + 1
                write_bn_test_flag = False

        if len(bn_pattern.findall(line)) != 0:
            global_stats_idx = idx
            all_write_lines.insert(idx+2+accum_change,'    include {phase:TRAIN}\n')
            accum_change = accum_change + 1
            write_bn_test_flag = True

fout.writelines(all_write_lines)
fout.close()
