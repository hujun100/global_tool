import re
layer_key = 'type: "Convolution"'
ffp = '/home/scw4750/ic/analysis/sphereface/sphereface_model.prototxt'
layer_pattern = re.compile(layer_key)
fout = open('out.txt','wt')

with open(ffp,'rt') as f:
    all_lines = f.readlines()
    all_write_lines=all_lines[:]
    accum_change = 0
    for idx in range(len(all_lines)):
        print(idx)
        line = all_lines[idx]
        if len(layer_pattern.findall(line)) != 0:
                all_write_lines.insert(idx+1+accum_change,'    param {   \n \
        lr_mult: 0 \n \
        decay_mult: 0 \n \
    } \n \
    param {   \n \
        lr_mult: 0 \n \
        decay_mult: 0 \n \
    } \n')
                accum_change  = accum_change + 1

fout.writelines(all_write_lines)
fout.close()
