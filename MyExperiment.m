close all;clear all;clc;
I = imread('C:\Users\cheng\Desktop\p.JPG');
I = rgb2gray(I);   %转化为灰度图像
% subplot(221);imshow(I);title('原图灰度图');
% subplot(222);imhist(I);title('原图灰度直方图');
% subplot(223);imshow(im2bw(I));title('原图二值图');

%直方图均衡化
hgram = 100:2:250;          %自定义行向量参数hgram
I = histeq(I,hgram);       %对图像按参数hgram进行直方均衡化
%subplot(224);imhist(J);title('均衡化灰度直方图');

% %对图像进行灰度阈值分割，取阈值为98
% image_1 = im2bw(I,98/255);
% %用二值形态学消除噪声
% image_1 = bwmorph(bwmorph(image_1,'open'),'close');
% figure;imshow(image_1);title('常规处理后的灰度阈值（98）分割图');

%对灰度均衡化的图像进行灰度阈值分割，取阈值为214
bw = im2bw(I,219/255);
%用二值形态学消除噪声
bw = bwmorph(bwmorph(bw,'open'),'close');
%figure;imshow(image_2);title('灰度均衡化后的灰度阈值（214）分割图');

%对图像用canny算子进行边缘检测
bw = edge(bw,'canny');
%imshow(bw1);title('Canny边缘检测');
%对二值图像进行填充处理
bw = imfill(bw,'holes');   %填充图像中的空洞区域
%将图像反色
% bw = uint8(bw2);
% for ii=1:4000
%     for jj = 1:3000
%         if bw(jj,ii)==0; 
%            bw(jj,ii) = 255;
%         else
%             bw(jj,ii) = 0;
%         end
%     end
% end
%figure;subimage(bw);title('填充图像');

%用函数bwareaopen去除图像中的小孔
bw = bwareaopen(bw, 50);
figure;subimage(bw);title('去孔图像');
%标记图像，并求各连通域的大小
% bw2 =bwlabel(bw2,4);  %标记图像
% stats = regionprops(logical(bw2),'Area'); %求各连通域的大小
% area = cat(1,stats.Area);
% [j,i] = size(area);
% for i = 1:i
%     if area(i,:)<30
%        index = find(area(i));
%        img = ismember(bw2,index);
%        bw2 = imadd(bw2,img);
%     end
% end
% figure;imshow(bw2);    

%对图像进行水平方向和垂直方向投影
X= sum(bw);
Y= sum(bw');
figure;
subplot(121);plot(X);title('像素垂直投影');
subplot(122);plot(Y);title('像素水平投影');

%统计图中的棒子数目
count = 0;  %棒子计数器
[i,j]=size(X);%计算X的大小，i为行，j为列
flag =0;  %标志
thresh = 300;
%设定阈值thresh为300
%每次进入垂直投影区且取值大于阈值的时候，将flag设置为1
%在小于阈值并且退出投影区时，计数器加1，且将flag置为0
for a = 1:j
    if X(1,a) >= thresh
        flag =1;
    else if X(1,a) <thresh && flag == 1
        count = count +1;
        flag =0;
        end
    end
end
fprintf('图中一共有%d个纱管',count);


    