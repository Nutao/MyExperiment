function [width] = mytest(A)
%�Ծ���A���д�ֱͶӰ��Ȼ���������ЧͶӰ���
width = 0;
X = sum(A);
[~,l] = size(X);
for b = 1:l
    if X(1,b) ~= 0
        width = width + 1;
    end
end
end
