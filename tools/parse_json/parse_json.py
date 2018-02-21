import json
def parse_json(output_ffp,ffp,key):
    with open(ffp,'rt') as f:
        data = json.load(f)
    all_paths = data[key]
    all_paths = [path+'\n' for path in all_paths]
    with open(output_ffp,'wt') as f:
        f.writelines(all_paths)

def parse_json_bbox(output_ffp,ffp,key):
    with open(ffp,'rt') as f:
        data = json.load(f)
    all_lms = data[key]
    with open(output_ffp,'wt') as f:
        print('haha')


if __name__ == '__main__':
    #ffp='/home/scw4750/Dataset/megaface/devkit/templatelists/megaface_features_list.json_1000_1'
    #output_ffp = 'distractor.txt'
    #key = 'path'
    #parse_json(output_ffp,ffp,key)
    #ffp='/home/scw4750/Dataset/megaface/devkit/templatelists/facescrub_uncropped_features_list.json'
    #output_ffp='faceScrub.txt'
    #parse_json(output_ffp,ffp,key)
    ffp='/media/scw4750/pipa_IDcard/megaface/ai/FlickrFinal2/001/001a02.JPG.json'
    key='landmarks'
    output_ffp = ffp[0:-4]+'5pt'
    parse_json_bbox(output_ffp,ffp,key)
    print('end')
