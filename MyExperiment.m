close all;clear all;clc;
I = imread('C:\Users\cheng\Desktop\Experiment\test\p.JPG');
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

%此模块用于判断各个纱筒的位置，并且精确截取每根纱管
%思想：根据垂直投影计算每一根纱管宽度，存入六个细胞数组中
%每个细胞数组中存入每根纱管的起始位置
MatOfPic_List = cell(1,count);   %创建一个细胞数组，一行六列
flag =0;
c = 1;
for a = 1:j
    if X(1,a) ~= 0
        MatOfPic_List{c} = [MatOfPic_List{c} a];
        flag = 1;
    else if X(1,a) == 0 && flag == 1
            flag =0;
            [row,list] = size(MatOfPic_List{c});   %row 为行，list为列
            if list > 200;   %如果列数大于200，才转入下一个细胞数组
                c = c + 1;
            else             %否则就在这个数组中执行下次循环。会过滤掉其中像素为0的点
                continue;   
            end
            if c > count   %当c超出纱管数目的时候，循环直接终止
                break;
            end
         end
    end
end

%利用上面垂直投影确定的每根纱管的范围
%截取出每一根纱管， 进行水平投影计算纱管高度
%然后确定每根纱管的位置
%========================================================
%测试第一根
%     [row_1,list] = size(MatOfPic_List{1});
%     xmin = MatOfPic_List{1}(1);
%     figure;subimage(bw);title('去孔图像');
%     %在指定位置上绘出矩形，Position有四个参数，分别为：起始点列、行，矩形宽，高
%     rectangle('Position',[xmin,0,list,3000],'EdgeColor','r');   
%========================================================
MatOfPic_Crop = cell(1,count);
% figure;subimage(bw);title('绘出确定边缘的图');
for c = 1:count
    [row_1,list] = size(MatOfPic_List{c});
    xmin = MatOfPic_List{c}(1);
    xmax = MatOfPic_List{c}(list);
    
    %将原图指定处的数据写入用于存储细胞矩阵
    MatOfPic_Crop{c} = bw(:,xmin:xmax);
%     %在原图上绘出标记
%     rectangle('Position',[xmin,0,list,3000],'EdgeColor','r');
end

%将截取出的纱管每一根写入一张图
% imwrite(MatOfPic_Crop{1},'C:\Users\cheng\Desktop\Experiment\test\1.jpg');
% imwrite(MatOfPic_Crop{2},'C:\Users\cheng\Desktop\Experiment\test\2.jpg');
% imwrite(MatOfPic_Crop{3},'C:\Users\cheng\Desktop\Experiment\test\3.jpg');
% imwrite(MatOfPic_Crop{4},'C:\Users\cheng\Desktop\Experiment\test\4.jpg');
% imwrite(MatOfPic_Crop{5},'C:\Users\cheng\Desktop\Experiment\test\5.jpg');
% imwrite(MatOfPic_Crop{6},'C:\Users\cheng\Desktop\Experiment\test\6.jpg');
% 显示截出的每一张图
for c = 1:count
    figure;imshow(MatOfPic_Crop{c});
end
disp('已完成截图存图操作');
disp('现在开始矫正图像');

%将截出来的纱管进行旋转矫正，并垂直投影。
%终止条件是，垂直投影的像素宽度达到最小
angle = 1;  %定义纱管旋转的角度的每次分量数
a = zeros(2,6); %用来存放每次校正图的投影有效宽度，以作比对

for c = 1:count
    flag = 0;   %循环终止条件
    count = 0;  %计数求投影有效区域的宽度
    while(flag ~= 1)
        %================================================
        %%%%第一次垂直投影
        %================================================
        X= sum(MatOfPic_Crop{c}); %第一次垂直投影
        figure;plot(X);
        [r1,l1] = size(X);
        for b = 1:l1
            if X(1,b) ~= 0              %计数求宽度
                %  a(1,1) = a(1,1) + 1;
                count = count + 1;
            end
        end
        a(1,c) = count;
        count = 0;
        %==========================================================
        MatOfPic_Crop{c} = imrotate(MatOfPic_Crop{c},angle);  %将图逆时针旋转angle个角度
        %==========================================================
        %%%%第二次垂直投影
        %==========================================================
        Y= sum(MatOfPic_Crop{c}); %第二次垂直投影
        figure;plot(Y);
        [r2,l2] = size(Y);
        for b = 1:l2
            if Y(1,b) ~= 0              %计数
                %    a(2,1) = a(2,1) + 1;
                count = count + 1;
            end
        end
        a(2,c) = count;
        %==========================================================
        %判断
        if a(2,1) >= a(1,1)
            flag = 1;
            MatOfPic_Crop{1} = imrotate(MatOfPic_Crop{1},-angle);
        else
            count = 0;
        end        
    end
    fprintf('第%d根纱管图像矫正完成：）\n',c);
    figure;imshow(MatOfPic_Crop{c});
end
    