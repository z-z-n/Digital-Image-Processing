python使用matlab
https://blog.csdn.net/jcodery/article/details/118223812
报错 AttributeError: module 'scipy' has no attribute 'io
https://blog.csdn.net/qq_35860352/article/details/80209370
anaconda环境
https://www.cnblogs.com/brithToSpring/p/13494966.html
matlab添加函数到路径
https://blog.csdn.net/CRESPO_LYM/article/details/52061110
https://www.cnblogs.com/bpf-1024/p/12408197.html
警告：
WARNING: You should compile the MEX version of "pointOp.c",
         found in the MEX subdirectory of matlabPyrTools, and put it in your matlab path.  It is MUCH faster.
根据github里面提示：
A few functions are actually MEX interfaces to C code.  These are
contained in the subdirectory called MEX.  The MEX files have been
tested on Sun (Solaris), LinuX (on an Intel platform), and Macintosh
OSX (on PowerPC and Intel), but should not be difficult to compile on
most other platforms.  Source code is included in the MEX directory,
as well as Make files.  Pre-compiled versions are included for a
number of platforms.  To compile on your platform, simply run
compilePyrTools.m which is located in the MEX subdirectory.
运行compilePyrTools.m 
运行报错error : Index in position 3 exceeds array bounds (must not exceed 1).
灰度图不是3位RGB
https://www.mathworks.com/matlabcentral/answers/469858-error-index-in-position-3-exceeds-array-bounds-must-not-exceed-1

matlab写入文件
https://ww2.mathworks.cn/help/matlab/ref/writematrix.html

matlab 三通道 不要转为double
https://blog.csdn.net/Hubert321/article/details/104523371