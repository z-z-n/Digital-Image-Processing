import dippykit
import os
import scipy
import numpy as np
import cv2

data_path = "../dataset/set12/"
gt_data_path = "../dataset/set12/gt/"
# image = cv2.imread("../dataset/set12/gt/01.png")
# channels = cv2.split(image)

# generate rayleigh
def generate_rayleigh_noise(image_shape, scale):
    noise = np.random.rayleigh(scale, image_shape)
    return noise

# generate periodic noise
def generate_periodic_noise(image_shape, frequency):
    x = np.arange(image_shape[1])
    y = np.arange(image_shape[0])
    xx, yy = np.meshgrid(x, y)
    noise = np.sin(2 * np.pi * frequency * xx / image_shape[1])
    return noise


for file in os.listdir(gt_data_path):
    gt_img_path = gt_data_path + file
    cur_image = cv2.imread(gt_img_path)
    # cv2.imshow(file,cur_image)
    for scale in ['1', '10', '30', '50']:
        noise_path = os.path.join(data_path, "rayleigh/level" + scale + "/")
        os.makedirs(noise_path, exist_ok=True)
        scale = int(scale)
        rayleigh_noise = generate_rayleigh_noise(cur_image.shape[:2], scale).astype('uint8')
        # 3 channels
        extend_noise = np.stack((rayleigh_noise,) * 3, axis=-1)
        noisy_image = cv2.add(cur_image, extend_noise)
        cv2.imwrite(noise_path+file, noisy_image)

    for scale in ['0.1', '0.5', '5', '10']:
        noise_path = os.path.join(data_path, "gamma/level" + scale.replace('.', '_') + "/")
        os.makedirs(noise_path, exist_ok=True)

        scale = float(scale)
        gamma_noise = np.random.gamma(10, scale, cur_image.shape).astype('uint8')
        noisy_image = cv2.add(cur_image, gamma_noise)
        cv2.imwrite(noise_path+file, noisy_image)