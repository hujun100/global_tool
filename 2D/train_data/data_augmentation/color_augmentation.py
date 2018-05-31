from skimage import io, transform, color
import numpy as np
import matplotlib.pyplot as plt


def horizontalFlip(image):
  return image[:,::-1,:]

def blend(img1, img2, alpha):
  return img1 * alpha + (1 - alpha) * img2

def grayscale(img):
  assert len(img.shape) == 3 and img.shape[2] == 3, 'grayscale error: image should be h*w*3'
  out = np.zeros(img.shape)
  out[:,:,0] = 0.299 * img[:,:,0] + 0.587 * img[:,:,1] + 0.114 * img[:,:,2]
  out[:,:,1] = np.copy(out[:,:,0])
  out[:,:,2] = np.copy(out[:,:,0])
  return out

def saturation(image, var=0.4):
  image = image.astype(np.float32)
  gray_image = grayscale(image)
  alpha = 1.0 + np.random.uniform(-var, var)
  out = blend(image, gray_image, alpha)
  out[out<0] = 0.0
  out[out>1] = 1.0
  return out


def contrast(image, var=0.4):
  image = image.astype(np.float32)
  gray_image = grayscale(image)
  temp = np.ones(image.shape)
  temp = temp * gray_image.mean()
  alpha = 1.0 + np.random.uniform(-var, var)
  out = blend(image, temp, alpha)
  out[out<0] = 0.0
  out[out>1] = 1.0
  return out

def brightness(image, var=0.4):
  image = image.astype(np.float32)
  temp = np.zeros(image.shape)
  out = image * (1 + np.random.uniform(-var, var))
  out[out<0] = 0.0
  out[out>1] = 1.0
  return out

##this method will harm the performance
def randomOrder(image):
  temp = np.arange(3)
  np.random.shuffle(temp)
  image = image[:,:, temp]
  return image

##this method will harm the performance
def mod_RGB(img, var=0.5):
    ratio = np.random.uniform(-var, var,size=(3,1))
    for channel in range(3):
        img[:, :, channel] = img[:, :, channel] * (1.0 + ratio[channel])
    img[img < 0] = 0
    img[img > 1] = 1
    return img

def rotation(image, angle=5):
   ratio = np.random.uniform(-angle, angle) 
   return transform.rotate(image, ratio)

def PCA_jitter(image, eigval, eigvec, alphastd=0.5):
   alpha0 = np.random.normal(0, alphastd)
   alpha1 = np.random.normal(0, alphastd)
   alpha2 = np.random.normal(0, alphastd)
   v = np.transpose((alpha0*eigval[0], alpha1*eigval[1], alpha2*eigval[2]))
   add_num = np.dot(eigvec, v)
   print(add_num)
   for i in range(3):
       image[:,:,i] = image[:,:,i] + add_num[i]
   image[image < 0] = 0
   image[image > 1] = 1
   return image

eigval = np.array([0.2175, 0.0188, 0.0045]) 
eigvec = np.array([[-0.5675,  0.7192,  0.4009],
      [ -0.5808, -0.0045, -0.8140 ],
      [ -0.5836, -0.6948, 0.4203 ]])
def pre_process(img):
    img = img.astype(np.float32)
    if len(img.shape) == 2:
        img = img[:, :, np.newaxis]
        img = np.repeat(img, [3], 2)
    if np.random.random()>0.5: img = img[:,::-1,:]
    if np.random.random()>0.8:
        img = brightness(img, 0.4)
    if np.random.random()>0.8:
        img = contrast(img, 0.4)
    if np.random.random()>0.8:
        img = saturation(img, 0.4)
    if np.random.random()>0.8:
        img = mod_RGB(img, 0.2)
    if np.random.random()>0.8:
        img = rotation(img, 5)
    if np.random.random()>0.8:
        img = PCA_jitter(img, eigval, eigvec, 0.5)
    return img

def jpeg_compression():
    print('opencv -- imencode api')
if __name__ == '__main__':
  bright_var = 0.4
  contrast_var = 0.4
  saturation_var = 0.4



  img = io.imread('/home/brl/iFace-1.3-v1/distractors/10144262.jpg')
  img = img/255.0
  plt.subplot(1, 4, 1)
  plt.imshow(img)

  plt.subplot(1, 4, 2)
  saturationout = saturation(img, contrast_var)
  plt.imshow(saturationout)

  plt.subplot(1, 4, 3)
  brightnessout = brightness(img, bright_var)
  plt.imshow(brightnessout)

  plt.subplot(1, 4, 4)
  contrastout = mod_RGB(img)

  plt.imshow(contrastout)
  plt.show()

