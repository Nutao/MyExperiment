# MyExperiment
PtternRcognition

# 预处理步骤：
1. 将rgb图像转化为灰度图像;
2. 将灰度图像的直方图均衡化;
3. 灰度阈值分割;
* 利用形态学消除噪声（图像先开运算，然后闭运算）;
* 用canny算子，检测图像的边缘;
* 填充闭区域;
* 去除图像中小的闭区域;
* 将图像水平、垂直投影;
* 根据投影图像，给棒子计数;

# 图像处理步骤
1. 判断图中有多少个目标物体；
* 截取每一个目标物体，存入工作路径；
* 对物体矫正处理；
* 依次分析每个物体的特征，并且与标准物体比对；
* 确定物体是否是符合要求；
