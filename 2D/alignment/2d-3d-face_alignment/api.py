from __future__ import print_function
import os
import glob
import dlib
import torch
import torch.nn as nn
from torch.autograd import Variable
from enum import Enum
from skimage import io
import h5py
try:
    import urllib.request as request_file
except BaseException:
    import urllib as request_file

from .models import FAN, ResNetDepth
from .utils import *


class LandmarksType(Enum):
    _2D = 1
    _2halfD = 2
    _3D = 3


class NetworkSize(Enum):
    # TINY = 1
    # SMALL = 2
    # MEDIUM = 3
    LARGE = 4

    def __new__(cls, value):
        member = object.__new__(cls)
        member._value_ = value
        return member

    def __int__(self):
        return self.value


class FaceAlignment:
    """Initialize the face alignment pipeline

    Args:
        landmarks_type (``LandmarksType`` object): an enum defining the type of predicted points.
        network_size (``NetworkSize`` object): an enum defining the size of the network (for the 2D and 2.5D points).
        enable_cuda (bool, optional): If True, all the computations will be done on a CUDA-enabled GPU (recommended).
        enable_cudnn (bool, optional): If True, cudnn library will be used in the benchmark mode
        flip_input (bool, optional): Increase the network accuracy by doing a second forward passed with
                                    the flipped version of the image
        use_cnn_face_detector (bool, optional): If True, dlib's CNN based face detector is used even if CUDA
                                                is disabled.

    Example:
        >>> FaceAlignment(NetworkSize.2D, flip_input=False)
    """

    def __init__(self, landmarks_type, network_size=NetworkSize.LARGE,
                 enable_cuda=True, enable_cudnn=True, flip_input=False,
                 use_cnn_face_detector=False, use_mtcnn=False):
        if use_mtcnn:
          data = h5py.File('/home/scw4750/face-alignment/land_data_v2.mat')
          size = 491582
          self.all_imgs = []
          self.all_bboxes = np.zeros((size, 4))
          for i in range(size):
            print(i)
            char_list = data[data['all_imgs'][0,i]]
            img = ''.join([chr(ch) for ch in char_list])
            self.all_imgs.append(img)
            self.all_bboxes[i,:] = data['all_bboxs'][:,i]
          print('read data end')


        self.enable_cuda = enable_cuda
        self.use_cnn_face_detector = use_cnn_face_detector
        self.flip_input = flip_input
        self.landmarks_type = landmarks_type
        base_path = os.path.join(appdata_dir('face_alignment'), "data")

        if not os.path.exists(base_path):
            os.makedirs(base_path)

        if enable_cudnn and self.enable_cuda:
            torch.backends.cudnn.benchmark = True

        # Initialise the face detector
        if self.enable_cuda or self.use_cnn_face_detector:
            path_to_detector = os.path.join(
                base_path, "mmod_human_face_detector.dat")
            if not os.path.isfile(path_to_detector):
                print("Downloading the face detection CNN. Please wait...")

                request_file.urlretrieve(
                    "https://www.adrianbulat.com/downloads/dlib/mmod_human_face_detector.dat",
                    os.path.join(path_to_detector))

            self.face_detector = dlib.cnn_face_detection_model_v1(
                path_to_detector)

        else:
            self.face_detector = dlib.get_frontal_face_detector()

        # Initialise the face alignemnt networks
        self.face_alignemnt_net = FAN(int(network_size))
        if landmarks_type == LandmarksType._2D:
            network_name = '2DFAN-' + str(int(network_size)) + '.pth.tar'
        else:
            network_name = '3DFAN-' + str(int(network_size)) + '.pth.tar'
        fan_path = os.path.join(base_path, network_name)

        if not os.path.isfile(fan_path):
            print("Downloading the Face Alignment Network(FAN). Please wait...")

            request_file.urlretrieve(
                "https://www.adrianbulat.com/downloads/python-fan/" +
                network_name, os.path.join(fan_path))

        fan_weights = torch.load(
            fan_path,
            map_location=lambda storage,
            loc: storage)
        fan_dict = {k.replace('module.', ''): v for k,
                    v in fan_weights['state_dict'].items()}

        self.face_alignemnt_net.load_state_dict(fan_dict)

        if self.enable_cuda:
            self.face_alignemnt_net.cuda()
        self.face_alignemnt_net.eval()

        # Initialiase the depth prediciton network
        if landmarks_type == LandmarksType._3D:
            self.depth_prediciton_net = ResNetDepth()
            depth_model_path = os.path.join(base_path, 'depth.pth.tar')
            if not os.path.isfile(depth_model_path):
                print(
                    "Downloading the Face Alignment depth Network (FAN-D). Please wait...")

                request_file.urlretrieve(
                    "https://www.adrianbulat.com/downloads/python-fan/depth.pth.tar",
                    os.path.join(depth_model_path))

            depth_weights = torch.load(
                depth_model_path,
                map_location=lambda storage,
                loc: storage)
            depth_dict = {
                k.replace('module.', ''): v for k,
                v in depth_weights['state_dict'].items()}
            self.depth_prediciton_net.load_state_dict(depth_dict)

            if self.enable_cuda:
                self.depth_prediciton_net.cuda()
            self.depth_prediciton_net.eval()

    def detect_faces(self, image, input_image):
        """Run the dlib face detector over an image

        Args:
            image (``ndarray`` object or string): either the path to the image or an image previosly opened
            on which face detection will be performed.

        Returns:
            Returns a list of detected faces
        """
        return self.face_detector(image)



    def detect_faces_mtcnn(self, image, input_image):
        """Run the dlib face detector over an image

        Args:
            image (``ndarray`` object or string): either the path to the image or an image previosly opened
            on which face detection will be performed.

        Returns:
            Returns a list of detected faces
        """
        name = '_'.join(input_image.split(os.path.sep)[-2:])
        name = name[0:-4]
        if name not in self.all_imgs:
             return []
        index = self.all_imgs.index(name)
        mtcnn_bbox = self.all_bboxes[index,:]
        detected_face = dlib.rectangle(long(mtcnn_bbox[0]), long(mtcnn_bbox[1]), long(mtcnn_bbox[0]+mtcnn_bbox[2]), long(mtcnn_bbox[1]+mtcnn_bbox[3]))
        return [detected_face]

    def get_landmarks_mtcnn(self, input_image, all_faces=False):
        if isinstance(input_image, str):
            try:
                image = io.imread(input_image)
            except IOError:
                print("error opening file :: ", input_image)
                return None
        else:
            image = input_image

        detected_faces = self.detect_faces_mtcnn(image, input_image)
        #print('detected_faces%s: %d'%(input_image, len(detected_faces)))
        if len(detected_faces) > 0:
          try:
            landmarks = []
            for i, d in enumerate(detected_faces):
                if i > 1 and not all_faces:
                    break
                if self.enable_cuda or self.use_cnn_face_detector:
                    d = d
                center = torch.FloatTensor(
                    [d.right() - (d.right() - d.left()) / 2.0, d.bottom() -
                     (d.bottom() - d.top()) / 2.0])
                center[1] = center[1] - (d.bottom() - d.top()) * 0.1
                scale = (d.right() - d.left() + d.bottom() - d.top()) / 200.0

                inp = crop(image, center, scale)
                inp = torch.from_numpy(inp.transpose(
                    (2, 0, 1))).float().div(255.0).unsqueeze_(0)

                if self.enable_cuda:
                    inp = inp.cuda()

                out = self.face_alignemnt_net(
                    Variable(inp, volatile=True))[-1].data.cpu()
                if self.flip_input:
                    out += flip(self.face_alignemnt_net(Variable(flip(inp),
                                                                 volatile=True))[-1].data.cpu(), is_label=True)

                pts, pts_img = get_preds_fromhm(out, center, scale)
                pts, pts_img = pts.view(68, 2) * 4, pts_img.view(68, 2)

                if self.landmarks_type == LandmarksType._3D:
                    heatmaps = np.zeros((68, 256, 256))
                    for i in range(68):
                        if pts[i, 0] > 0:
                            heatmaps[i] = draw_gaussian(heatmaps[i], pts[i], 2)
                    heatmaps = torch.from_numpy(
                        heatmaps).view(1, 68, 256, 256).float()
                    if self.enable_cuda:
                        heatmaps = heatmaps.cuda()
                    depth_pred = self.depth_prediciton_net(
                        Variable(
                            torch.cat(
                                (inp, heatmaps), 1), volatile=True)).data.cpu().view(
                        68, 1)
                    pts_img = torch.cat(
                        (pts_img, depth_pred * (1.0 / (256.0 / (200.0 * scale)))), 1)

                landmarks.append(pts_img.numpy())
          except:
            print("Warning: a bug.")
            return None
        else:
            print("Warning: No faces were detected.")
            return None

        return landmarks, detected_faces[0]

    def get_landmarks(self, input_image, all_faces=False):
        if isinstance(input_image, str):
            try:
                image = io.imread(input_image)
            except IOError:
                print("error opening file :: ", input_image)
                return None
        else:
            image = input_image

        detected_faces = self.detect_faces(image, input_image)
        #print('detected_faces%s: %d'%(input_image, len(detected_faces)))
        if len(detected_faces) > 0:
          try:
            landmarks = []
            for i, d in enumerate(detected_faces):
                if i > 1 and not all_faces:
                    break
                if self.enable_cuda or self.use_cnn_face_detector:
                    d = d.rect
                center = torch.FloatTensor(
                    [d.right() - (d.right() - d.left()) / 2.0, d.bottom() -
                     (d.bottom() - d.top()) / 2.0])
                center[1] = center[1] - (d.bottom() - d.top()) * 0.1
                scale = (d.right() - d.left() + d.bottom() - d.top()) / 200.0

                inp = crop(image, center, scale)
                inp = torch.from_numpy(inp.transpose(
                    (2, 0, 1))).float().div(255.0).unsqueeze_(0)

                if self.enable_cuda:
                    inp = inp.cuda()

                out = self.face_alignemnt_net(
                    Variable(inp, volatile=True))[-1].data.cpu()
                if self.flip_input:
                    out += flip(self.face_alignemnt_net(Variable(flip(inp),
                                                                 volatile=True))[-1].data.cpu(), is_label=True)

                pts, pts_img = get_preds_fromhm(out, center, scale)
                pts, pts_img = pts.view(68, 2) * 4, pts_img.view(68, 2)

                if self.landmarks_type == LandmarksType._3D:
                    heatmaps = np.zeros((68, 256, 256))
                    for i in range(68):
                        if pts[i, 0] > 0:
                            heatmaps[i] = draw_gaussian(heatmaps[i], pts[i], 2)
                    heatmaps = torch.from_numpy(
                        heatmaps).view(1, 68, 256, 256).float()
                    if self.enable_cuda:
                        heatmaps = heatmaps.cuda()
                    depth_pred = self.depth_prediciton_net(
                        Variable(
                            torch.cat(
                                (inp, heatmaps), 1), volatile=True)).data.cpu().view(
                        68, 1)
                    pts_img = torch.cat(
                        (pts_img, depth_pred * (1.0 / (256.0 / (200.0 * scale)))), 1)

                landmarks.append(pts_img.numpy())
          except:
            print("Warning: a bug.")
            return None
        else:
            print("Warning: No faces were detected.")

            return None

        return landmarks, detected_faces[0]


    def process_folder(self, path, all_faces=False):
        with open(path,'rt') as f:
             images_list = f.readlines()
        #images_list = [img for img in images_list]
        predictions_lm = []
        predictions_bbox = []
        predictions_name = []
        for idx, iterm in enumerate(images_list):
            image_name = iterm.rstrip('\n')
            print('idx:%d %s'%(idx,image_name))
            re = self.get_landmarks_mtcnn(image_name, all_faces)
            if re is None:
                continue
            landmarks, bboxes = re
            predictions_name.append(image_name)
            predictions_lm.append(landmarks) 
            predictions_bbox.append(bboxes)

        return  predictions_name, predictions_lm, predictions_bbox

    def process_folder_hujun(self, ffp, all_faces=False):
        with open(ffp,'rt') as f:
             images_list = f.readlines()
        predictions_lm = []
        predictions_bbox = []
        predicions_name = []
        for idx, image_name in enumerate(images_list):
            image_name = image_name.rstrip('\n')
            print('idx:%d %s'%(idx,image_name))
            re= self.get_landmarks(image_name, all_faces)
            if re is None:
                continue
            landmarks, bboxes = re 
            predicions_name.append(image_name)          
            predictions_lm.append(landmarks) 
            predictions_bbox.append(bboxes)

        return predicions_name, predictions_lm, predictions_bbox
