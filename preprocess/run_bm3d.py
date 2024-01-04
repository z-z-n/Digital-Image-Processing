from matplotlib import pyplot as plt
from scipy import io
from matlab import engine

eng = engine.start_matlab()
# eng.bm3d("../images/cure-or-guassian-blur/01950.jpg", "data/01950_bm3d.mat", nargout=0)

data = io.matlab.loadmat("IQA_CURE_TSR_12percent.mat")
im_nl = data["IQA_CURE_TSR_Images"]

plt.imshow(im_nl, cmap="Greys")
plt.show()
