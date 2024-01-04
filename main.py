from __future__ import division
import numpy as np

import scipy.misc
from skimage.color.adapt_rgb import adapt_rgb, each_channel
from PIL import Image

#曲率滤波
def update_gc(inputimg, i, j):
    #对二维数组（图片）进行操作
    #数组不取到最后一个像素点的原因，可以参考我后面画的图，因为在步长为2的情况下是取不到最后一个点的
    inputimg_ij = inputimg[i:-1:2, j:-1:2]
#求di（根据公式写程序，基点是[i:-1:2, j:-1:2]）
#d1中[i - 1:-2:2, j:-1:2] 也可以参考后面画的图，因为它是基点的左边一个点，是模块中心点正左方的点，所以取不到倒数第二个点
    d1 = (inputimg[i - 1:-2:2, j:-1:2] + inputimg[i + 1::2, j:-1:2])/2.0 - inputimg[i:-1:2, j:-1:2]
    d2 = (inputimg[i:-1:2, j - 1:-2:2] + inputimg[i:-1:2, j + 1::2])/2.0 - inputimg[i:-1:2, j:-1:2]
    d3 = (inputimg[i - 1:-2:2, j - 1:-2:2] + inputimg[i + 1::2, j + 1::2])/2.0  - inputimg[i:-1:2, j:-1:2]
    d4 = (inputimg[i - 1:-2:2, j + 1::2] + inputimg[i + 1::2, j - 1:-2:2])/2.0 - inputimg[i:-1:2, j:-1:2]
    d5 = (inputimg[i - 1:-2:2, j:-1:2] + inputimg[i:-1:2, j - 1:-2:2] -inputimg[i - 1:-2:2, j - 1:-2:2]) - inputimg[i:-1:2, j:-1:2]
    d6 = (inputimg[i - 1:-2:2, j:-1:2] + inputimg[i:-1:2, j + 1::2] - inputimg[i - 1:-2:2,j + 1::2])- inputimg[i:-1:2, j:-1:2]
    d7 = (inputimg[i:-1:2, j- 1:-2:2] + inputimg[i + 1::2, j:-1:2] - inputimg[i + 1::2, j - 1:-2:2])- inputimg[i:-1:2, j:-1:2]
    d8 = (inputimg[i:-1:2, j + 1::2] + inputimg[i + 1::2, j:-1:2] - inputimg[i + 1::2, j + 1::2])- inputimg[i:-1:2, j:-1:2]
#找到di最小值并赋值给d
    #条件满足则赋1不满足赋0，若d2<d1，则np.abs(d2) < np.abs(d1)为1，np.abs(d1) <= np.abs(d2)为0，d=d2
    d = d1 * (np.abs(d1) <= np.abs(d2)) + d2 * (np.abs(d2) < np.abs(d1))
    d = d * (np.abs(d) <= np.abs(d3)) + d3 * (np.abs(d3) < np.abs(d))
    d = d * (np.abs(d) <= np.abs(d4)) + d4 * (np.abs(d4) < np.abs(d))
    d = d * (np.abs(d) <= np.abs(d5)) + d5 * (np.abs(d5) < np.abs(d))
    d = d * (np.abs(d) <= np.abs(d6)) + d6 * (np.abs(d6) < np.abs(d))
    d = d * (np.abs(d) <= np.abs(d7)) + d7 * (np.abs(d7) < np.abs(d))
    d = d * (np.abs(d) <= np.abs(d8)) + d8 * (np.abs(d8) < np.abs(d))
#list.append(d)
    inputimg_ij[...] +=d


#找函数名，相当于路由
#字典类型  键值对 调用方法：updaterule.keys()调用键，updaterule.value()调用值
updaterule = { 'gc': update_gc}

@adapt_rgb(each_channel)
#定义一个带参数的函数
#inputimg调用的初始图片，filtertype是指调用的滤波器类型，total_iter迭代次数
def cf_filter(inputimg, filtertype, total_iter = 10, dtype = np.float32):
	#断言 如果不满足括号内条件系统报错并提示后一句
    assert(type(filtertype) is str), "input argument is not a string datatype!"
    #判断调用的滤波器是否在路由中
    assert(filtertype in updaterule.keys()), "filter type is not found!"
    #不对原图片进行修改  复制一份进行操作
    filteredimg = np.copy(inputimg.astype(dtype))
    #获取到函数名
    update = updaterule.get(filtertype)
    #遍历
    for iter_num in range(total_iter):
        update(filteredimg, 1, 1)
        update(filteredimg, 2, 2)
        update(filteredimg, 1, 2)
        update(filteredimg, 2, 1)
    return filteredimg
im = Image.open('2.tif').convert('L')
im.show()
#图片转数组对象
arr=np.array(im)
result=cf_filter(arr,'gc',total_iter = 50)
#array 反操作
pil_im = Image.fromarray(result)
pil_im.show()