import numpy as np

def parse_lst_line(line):
  line = line.rstrip('\n')
  vec = line.strip().split("\t")
  #print(vec)
  #print(len(vec))
  assert len(vec)>=2
  image_path = vec[0]
  label = int(vec[1])
  bbox = None
  landmark = None
  #print(vec)
  if len(vec)>3:
    bbox = np.zeros( (4,), dtype=np.int32)
    for i in xrange(3,7):
      bbox[i-3] = int(vec[i])
    landmark = None
    if len(vec)>7:
      _l = []
      for i in xrange(7,17):
        _l.append(float(vec[i]))
      landmark = np.array(_l).reshape( (2,5) ).T
  return image_path, label, bbox, landmark
