import json
import threading
def parse_json(output_ffp,ffp,key):
    with open(ffp,'rt') as f:
        data = json.load(f)
    all_paths = data[key]
    all_paths = [path+'\n' for path in all_paths]
    with open(output_ffp,'wt') as f:
        f.writelines(all_paths)

def parse_json_bbox_single(output_ffp,ffp,key):
    with open(ffp,'rt') as f:
        data = json.load(f)
    bbox = data[key]
    if bbox is None:
        return

    line =  '%f %f %f %f\n' %(bbox['x'], bbox['y'], bbox['width'], bbox['height'])
    with open(output_ffp,'wt') as f:
        f.writelines(line)

def parse_json_bbox(all_lines,output_ffp,key):
    for idx, iterm in enumerate(all_lines):
        ffp= img_dir + iterm.rstrip('\n')+'.json'
        output_ffp = ffp[0:-8]+'bbox'
        print('idx:%d  output_ffp:%s' %(idx, output_ffp))
        parse_json_bbox_single(output_ffp,ffp,key)
    print('end')

def parse_json_lm_single(output_ffp, ffp, key):
    with open(ffp,'rt') as f:
        data = json.load(f)
    lm = data[key]
    if len(lm) != 3:
        return 
    try:
        line = '%f %f\n%f %f\n%f %f\n'%(lm['0']['x'],lm['0']['y'],lm['1']['x'],lm['1']['y'],\
                lm['2']['x'],lm['2']['y'])
    except:
        return
    with open(output_ffp,'wt') as f:
        f.writelines(line)

def parse_json_lm(all_lines, img_dir, key):
    for idx, iterm in enumerate(all_lines):
        ffp= img_dir + iterm.rstrip('\n')+'.json'
        output_ffp = ffp[0:-8]+'3pt'
        print('idx:%d  output_ffp:%s' %(idx, output_ffp))
        parse_json_lm_single(output_ffp,ffp,key)
    print('end')   

if __name__ == '__main__':
    ffp='/home/brl/TRAIN/devkit/templatelists/facescrub_uncropped_features_list.json'
    output_ffp = 'faces.txt'
    key = 'path'
    parse_json(output_ffp,ffp,key)


    #ffp='/home/scw4750/Dataset/megaface/devkit/templatelists/facescrub_uncropped_features_list.json'
    #output_ffp='faceScrub.txt'
    #parse_json(output_ffp,ffp,key)

    #distractor_ffp= 'distractor_1k.txt'
    #img_dir = '/media/scw4750/pipa_IDcard/megaface/distractor_1m/' 
    #key='landmarks'
    #with open(distractor_ffp,'rt') as f:
    #    all_lines = f.readlines()
    #parse_json_lm(all_lines, img_dir, key)

    #key='bounding_box'
    #with open(distractor_ffp,'rt') as f:
    #    all_lines = f.readlines()
    #parse_json_bbox(all_lines, img_dir, key)



