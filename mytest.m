function [width] = mytest(A)
%对矩阵A进行垂直投影，然后输出其有效投影宽度
width = 0;
X = sum(A);
[~,l] = size(X);
for b = 1:l
    if X(1,b) ~= 0
        width = width + 1;
    end
end
end
