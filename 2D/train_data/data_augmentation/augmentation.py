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

  
  from imgaug import augmenters as iaa
from keras.preprocessing.image import *
import cv2
from tqdm import tqdm
from config import *

# rotate images
def rotate(image, angle, center=None, scale=1.0):
    (h, w) = image.shape[:2]
    if center is None:
        center = (w / 2, h / 2)
    M = cv2.getRotationMatrix2D(center, angle, scale)
    rotated = cv2.warpAffine(image, M, (w, h))
    return rotated

# load and preprocess images
def process(aug,model,width,fnames_test,n_test):
    X_test = np.zeros((n_test, width, width, 3), dtype=np.uint8)

    if (aug == 'default'):
        for i in tqdm(range(n_test)):
            img = cv2.resize(cv2.imread(TEST_IMG_DIR+'{0}'.format(fnames_test[i])), (width, width))
            X_test[i] = img[:, :, ::-1]
    elif (aug == 'flip'):
        for i in tqdm(range(n_test)):
            img = cv2.resize(cv2.imread(TEST_IMG_DIR+'{0}'.format(fnames_test[i])), (width, width))
            img = cv2.flip(img, 1)
            X_test[i] = img[:, :, ::-1]
    elif (aug == 'rotate1'):
        for i in tqdm(range(n_test)):
            img = cv2.resize(cv2.imread(TEST_IMG_DIR+'{0}'.format(fnames_test[i])), (width, width))
            img = rotate(img, 5)
            X_test[i] = img[:, :, ::-1]
    elif (aug == 'rotate2'):
        for i in tqdm(range(n_test)):
            img = cv2.resize(cv2.imread(TEST_IMG_DIR+'{0}'.format(fnames_test[i])), (width, width))
            img = rotate(img, -5)
            X_test[i] = img[:, :, ::-1]
    elif (aug == 'rotate3'):
        for i in tqdm(range(n_test)):
            img = cv2.resize(cv2.imread(TEST_IMG_DIR+'{0}'.format(fnames_test[i])), (width, width))
            img = cv2.flip(img, 1)
            img = rotate(img, 5)
            X_test[i] = img[:, :, ::-1]
    elif (aug == 'rotate4'):
        for i in tqdm(range(n_test)):
            img = cv2.resize(cv2.imread(TEST_IMG_DIR+'{0}'.format(fnames_test[i])), (width, width))
            img = cv2.flip(img, 1)
            img = rotate(img, -5)
            X_test[i] = img[:, :, ::-1]
    elif (aug == 'rotate5'):
        for i in tqdm(range(n_test)):
            img = cv2.resize(cv2.imread(TEST_IMG_DIR+'{0}'.format(fnames_test[i])), (width, width))
            img = rotate(img, 13)
            X_test[i] = img[:, :, ::-1]
    elif (aug == 'rotate6'):
        for i in tqdm(range(n_test)):
            img = cv2.resize(cv2.imread(TEST_IMG_DIR+'{0}'.format(fnames_test[i])), (width, width))
            img = rotate(img, -13)
            X_test[i] = img[:, :, ::-1]
    elif (aug == 'rotate7'):
        for i in tqdm(range(n_test)):
            img = cv2.resize(cv2.imread(TEST_IMG_DIR+'{0}'.format(fnames_test[i])), (width, width))
            img = cv2.flip(img, 1)
            img = rotate(img, 13)
            X_test[i] = img[:, :, ::-1]
    elif (aug == 'rotate8'):
        for i in tqdm(range(n_test)):
            img = cv2.resize(cv2.imread(TEST_IMG_DIR+'{0}'.format(fnames_test[i])), (width, width))
            img = cv2.flip(img, 1)
            img = rotate(img, -13)
            X_test[i] = img[:, :, ::-1]
    elif (aug == 'rotate9'):
        for i in tqdm(range(n_test)):
            img = cv2.resize(cv2.imread(TEST_IMG_DIR+'{0}'.format(fnames_test[i])), (width, width))
            img = rotate(img, 21)
            X_test[i] = img[:, :, ::-1]
    elif (aug == 'rotate10'):
        for i in tqdm(range(n_test)):
            img = cv2.resize(cv2.imread(TEST_IMG_DIR+'{0}'.format(fnames_test[i])), (width, width))
            img = rotate(img, -21)
            X_test[i] = img[:, :, ::-1]
    elif (aug == 'rotate11'):
        for i in tqdm(range(n_test)):
            img = cv2.resize(cv2.imread(TEST_IMG_DIR+'{0}'.format(fnames_test[i])), (width, width))
            img = cv2.flip(img, 1)
            img = rotate(img, 21)
            X_test[i] = img[:, :, ::-1]
    elif (aug == 'rotate12'):
        for i in tqdm(range(n_test)):
            img = cv2.resize(cv2.imread(TEST_IMG_DIR+'{0}'.format(fnames_test[i])), (width, width))
            img = cv2.flip(img, 1)
            img = rotate(img, -21)
            X_test[i] = img[:, :, ::-1]

    y_pred = model.predict(X_test, batch_size=32, verbose=1)
    del X_test
    return y_pred

# data augmentation
def customizedImgAug(input_img):
    rarely = lambda aug: iaa.Sometimes(0.1, aug)
    sometimes = lambda aug: iaa.Sometimes(0.25, aug)
    often = lambda aug: iaa.Sometimes(0.5, aug)

    seq = iaa.Sequential([
        iaa.Fliplr(0.5),
        often(iaa.Affine(
            scale={"x": (0.9, 1.1), "y": (0.9, 1.1)},
            translate_percent={"x": (-0.1, 0.1), "y": (-0.12, 0)},
            rotate=(-10, 10),
            shear=(-8, 8),
            order=[0, 1],
            cval=(0, 255),
        )),
        iaa.SomeOf((0, 4), [
            rarely(
                iaa.Superpixels(
                    p_replace=(0, 0.3),
                    n_segments=(20, 200)
                )
            ),
            iaa.OneOf([
                iaa.GaussianBlur((0, 2.0)),
                iaa.AverageBlur(k=(2, 4)),
                iaa.MedianBlur(k=(3, 5)),
            ]),
            iaa.Sharpen(alpha=(0, 0.3), lightness=(0.75, 1.5)),
            iaa.Emboss(alpha=(0, 1.0), strength=(0, 0.5)),
            rarely(iaa.OneOf([
                iaa.EdgeDetect(alpha=(0, 0.3)),
                iaa.DirectedEdgeDetect(
                    alpha=(0, 0.7), direction=(0.0, 1.0)
                ),
            ])),
            iaa.AdditiveGaussianNoise(
                loc=0, scale=(0.0, 0.05 * 255), per_channel=0.5
            ),
            iaa.OneOf([
                iaa.Dropout((0.0, 0.05), per_channel=0.5),
                iaa.CoarseDropout(
                    (0.03, 0.05), size_percent=(0.01, 0.05),
                    per_channel=0.2
                ),
            ]),
            rarely(iaa.Invert(0.05, per_channel=True)),
            often(iaa.Add((-40, 40), per_channel=0.5)),
            iaa.Multiply((0.7, 1.3), per_channel=0.5),
            iaa.ContrastNormalization((0.5, 2.0), per_channel=0.5),
            iaa.Grayscale(alpha=(0.0, 1.0)),
            sometimes(iaa.PiecewiseAffine(scale=(0.01, 0.03))),
            sometimes(
                iaa.ElasticTransformation(alpha=(0.5, 1.5), sigma=0.25)
            ),

        ], random_order=True),
        iaa.Fliplr(0.5),
        iaa.AddToHueAndSaturation(value=(-10, 10), per_channel=True)
    ], random_order=True)  # apply augmenters in random order

    output_img = seq.augment_image(input_img)
    return output_img

# generate data
class Generator():
    def __init__(self, X, y, batch_size=8, aug=False):
        def generator():
            while True:
                for i in range(0, len(X), batch_size):
                    X_batch = X[i:i + batch_size].copy()
                    y_barch = [x[i:i + batch_size] for x in y]
                    if aug:
                        for j in range(len(X_batch)):
                            X_batch[j] = customizedImgAug(X_batch[j])
                    yield X_batch, y_barch

        self.generator = generator()
self.steps = len(X) // batch_size + 1
