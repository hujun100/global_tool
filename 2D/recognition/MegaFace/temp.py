import os
import shutil
with open('distractor_10k.txt','rt') as f:
    all_lines = f.readlines()
for idx, iterm in enumerate(all_lines):
    print(idx)
    iterm = iterm.rstrip('\n')
    des_file = os.path.join('/media/scw4750/pipa_IDcard/megaface/distractor_10K', iterm)
    des_dir = '/'.join(des_file.split('/')[0:-1])
    if os.path.exists(des_dir) is False:
       os.makedirs(des_dir)
    shutil.copy(os.path.join('/media/scw4750/pipa_IDcard/megaface/distractor_1m', iterm), \
            des_file)
    shutil.copy(os.path.join('/media/scw4750/pipa_IDcard/megaface/distractor_1m', iterm+'.json'), \
            des_file+'.json')