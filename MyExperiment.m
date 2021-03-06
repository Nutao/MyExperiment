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
% for c = 1:count
%     figure;imshow(MatOfPic_Crop{c});
% end
disp('已完成截图存图操作');
disp('现在开始矫正图像');

%将截出来的纱管进行旋转矫正，并垂直投影。
%终止条件是，垂直投影的像素宽度达到最小

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%判断纱管的偏斜情况，根据左右的偏斜方向进行正确地矫正
%方法：将纱管逆时针旋转并记录下垂直投影count1
%      再将纱管顺时针旋转并记录下垂直投影count2
%      比较count1和count2的大小，若count1小，则应进行逆时针旋转，否则进行顺时针旋转
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
angle = 1;  %定义纱管旋转的角度的每次分量数
a = zeros(2,6); %用来存放每次校正图的投影有效宽度，以作比对。第一行用于存放第一次投影数据，第二行用于第二次投影数据】

for c = 1:count
    flag = 0;   %循环终止条件
    width = 0;  %计数求投影有效区域的宽度
    figure;subplot(131);imshow(MatOfPic_Crop{c});title('矫正前');
    %=======================================================
    %此块用于判断图像中纱管的偏向
    %=======================================================
    X = sum(imrotate(MatOfPic_Crop{c},angle)); %将图【逆时针】旋转angle个角度，并投影
    [~,l] = size(X);
    for b = 1:l
        if X(1,b) ~= 0              %计数求宽度
           width = width + 1;
        end
    end
    a(3,c) = width;     %a数组第三行用于存储判断时进行测试性的【逆时针旋转】后旋转宽度
    width = 0;
    X = sum(imrotate(MatOfPic_Crop{c},-angle)); %将图【顺时针】旋转angle个角度，并投影
    [~,l] = size(X);
    for b = 1:l
        if X(1,b) ~= 0              %计数求宽度
           width = width + 1;
        end
    end
    a(4,c) = width;     %a数组第四行用于存储判断时进行测试性的【顺时针旋转】后旋转宽度
    width = 0;
    %=======================================================
    subplot(132);title('矫正曲线');hold on;
    %=======================================================
    %旋转
    %=======================================================
    if a(3,c) < a(4,c)    %右偏   
        while(flag ~= 1)
            %================================================
            %%%%第一次垂直投影
            %================================================
            X = sum(MatOfPic_Crop{c}); %第一次垂直投影
%             figure;plot(X);
            cla;plot(X);pause(0.1);cla;
            [~,l1] = size(X);
            for b = 1:l1
                if X(1,b) ~= 0              %计数求宽度
                    %  a(1,1) = a(1,1) + 1;
                    width = width + 1;
                end
            end
            a(1,c) = width;
            width = 0;
            %==========================================================
            MatOfPic_Crop{c} = imrotate(MatOfPic_Crop{c},angle);  %将图【逆时针】旋转angle个角度
            %==========================================================
            %%%%第二次垂直投影
            %==========================================================
            Y = sum(MatOfPic_Crop{c}); %第二次垂直投影
%             figure;plot(Y);
            plot(Y);pause(0.1);
            [~,l2] = size(Y);
            for b = 1:l2
                if Y(1,b) ~= 0              %计数
                    %    a(2,1) = a(2,1) + 1;
                    width = width + 1;
                end
            end
            a(2,c) = width;
            %==========================================================
            %判断
            if a(2,c) >= a(1,c)
                flag = 1;
                MatOfPic_Crop{c} = imrotate(MatOfPic_Crop{c},-angle);
            else
                width = 0;
            end
        end
    else  %向左偏的时候
        while(flag ~= 1)
            %================================================
            %%%%第一次垂直投影
            %================================================
            X= sum(MatOfPic_Crop{c}); %第一次垂直投影
%             figure;plot(X);
            cla;plot(X);pause(0.1);cla;
            [~,l1] = size(X);    %X位一行l1列的矩阵
            for b = 1:l1
                if X(1,b) ~= 0              %计数求宽度
                    width = width + 1;
                end
            end
            a(1,c) = width;
            width = 0;
            %==========================================================
            MatOfPic_Crop{c} = imrotate(MatOfPic_Crop{c},-angle);  %将图【顺时针】旋转angle个角度
            %==========================================================
            %%%%第二次垂直投影
            %==========================================================
            Y= sum(MatOfPic_Crop{c}); %第二次垂直投影
%             figure;plot(Y);
            plot(Y);pause(0.1);
            [~,l2] = size(Y);
            for b = 1:l2
                if Y(1,b) ~= 0              %计数
                    width = width + 1;
                end
            end
            a(2,c) = width;
            width = 0;
            %==========================================================
            %判断
            if a(2,c) >= a(1,c)
                flag = 1;
                MatOfPic_Crop{c} = imrotate(MatOfPic_Crop{c},angle);      
            end
        end
    end  
        
    fprintf('第%d根纱管图像矫正完成 :)\n',c);
    subplot(133);imshow(MatOfPic_Crop{c}); title('矫正后');%显示当前调整的图像
end
disp('图像矫正完成：）');

for c = 1:count
    [x,y] = find(MatOfPic_Crop{1,c}==1); %获取每一个矩阵中值为一的部分的矩阵。
    xmin = min(x(:));  %找行最小值
    xmax = max(x(:));  %找行最大值
    ymin = min(y(:));  %找列最小值
    ymax = max(y(:));  %找列最大值
    dx = xmax - xmin; %高
    dy = ymax - ymin; %宽
    
    %绘出原图
    figure;subimage(MatOfPic_Crop{1,c});title('确定图像位置');
    %在原图上绘出矩形标记
    rectangle('Position',[ymin,xmin,dy,dx],'EdgeColor','r');
    %将纱管精确地截取下来,放在 MatOfPic_Crop第二行
    MatOfPic_Crop{2,c} = MatOfPic_Crop{1,c}(xmin:xmax,ymin:ymax);
    %用MatOfPic_Crop的第三行存纱管的第一段
    MatOfPic_Crop{3,c} = MatOfPic_Crop{1,c}(xmin:xmin+(1/3)*dx,ymin:ymax);
    figure;subplot(131);imshow(MatOfPic_Crop{3,c});title('第一段');
    %用MatOfPic_Crop的第四行存纱管的第二段
    MatOfPic_Crop{4,c} = MatOfPic_Crop{1,c}(xmin+(1/3)*dx:xmin+(2/3)*dx,ymin:ymax);
    subplot(132);imshow(MatOfPic_Crop{4,c});title('第二段');
    %用MatOfPic_Crop的第五行存纱管的第三段
    MatOfPic_Crop{5,c} = MatOfPic_Crop{1,c}(xmin+(2/3)*dx:xmin+(3/3)*dx,ymin:ymax);
    subplot(133);imshow(MatOfPic_Crop{5,c});title('第三段');
    %将截取下来的每一段进行投影，然后将投影数据存入MatOfPic_Crop{6，1}
    MatOfPic_Crop{6,1}(1,c) = mytest(MatOfPic_Crop{3,c});
    MatOfPic_Crop{6,1}(2,c) = mytest(MatOfPic_Crop{4,c});
    MatOfPic_Crop{6,1}(3,c) = mytest(MatOfPic_Crop{5,c});
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     判断方式：
%         如果投影宽度最大值大于标准纱管，则表明其有尾纱
%         如果投影宽度最大值小于或等于标准纱管，则对截取部分投影宽度进行比对
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if max(MatOfPic_Crop{6,1}(:,c)) > max(MatOfPic_Crop{6,1}(:,1))
        fprintf('第%d根纱管表面有未除尽的纱线 :( \n',c );
    elseif MatOfPic_Crop{6,1}(1,c) > MatOfPic_Crop{6,1}(1,1) || MatOfPic_Crop{6,1}(2,c) > MatOfPic_Crop{6,1}(2,1) || MatOfPic_Crop{6,1}(3,c) > MatOfPic_Crop{6,1}(3,1)
             fprintf('第%d根纱管表面有未除尽的纱线 :( \n',c );
    else
            fprintf('第%d根纱管表面不含有卷曲的纱线 :) \n',c );
    end                 
end