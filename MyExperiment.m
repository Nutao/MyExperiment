close all;clear all;clc;
I = imread('C:\Users\cheng\Desktop\Experiment\test\p.JPG');
I = rgb2gray(I);   %ת��Ϊ�Ҷ�ͼ��
% subplot(221);imshow(I);title('ԭͼ�Ҷ�ͼ');
% subplot(222);imhist(I);title('ԭͼ�Ҷ�ֱ��ͼ');
% subplot(223);imshow(im2bw(I));title('ԭͼ��ֵͼ');

%ֱ��ͼ���⻯
hgram = 100:2:250;          %�Զ�������������hgram
I = histeq(I,hgram);       %��ͼ�񰴲���hgram����ֱ�����⻯
%subplot(224);imhist(J);title('���⻯�Ҷ�ֱ��ͼ');

% %��ͼ����лҶ���ֵ�ָȡ��ֵΪ98
% image_1 = im2bw(I,98/255);
% %�ö�ֵ��̬ѧ��������
% image_1 = bwmorph(bwmorph(image_1,'open'),'close');
% figure;imshow(image_1);title('���洦���ĻҶ���ֵ��98���ָ�ͼ');

%�ԻҶȾ��⻯��ͼ����лҶ���ֵ�ָȡ��ֵΪ214
bw = im2bw(I,219/255);
%�ö�ֵ��̬ѧ��������
bw = bwmorph(bwmorph(bw,'open'),'close');
%figure;imshow(image_2);title('�ҶȾ��⻯��ĻҶ���ֵ��214���ָ�ͼ');

%��ͼ����canny���ӽ��б�Ե���
bw = edge(bw,'canny');
%imshow(bw1);title('Canny��Ե���');
%�Զ�ֵͼ�������䴦��
bw = imfill(bw,'holes');   %���ͼ���еĿն�����
%��ͼ��ɫ
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
%figure;subimage(bw);title('���ͼ��');

%�ú���bwareaopenȥ��ͼ���е�С��
bw = bwareaopen(bw, 50);
figure;subimage(bw);title('ȥ��ͼ��');
%���ͼ�񣬲������ͨ��Ĵ�С
% bw2 =bwlabel(bw2,4);  %���ͼ��
% stats = regionprops(logical(bw2),'Area'); %�����ͨ��Ĵ�С
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

%��ͼ�����ˮƽ����ʹ�ֱ����ͶӰ
X= sum(bw);
Y= sum(bw');
figure;
subplot(121);plot(X);title('���ش�ֱͶӰ');
subplot(122);plot(Y);title('����ˮƽͶӰ');

%ͳ��ͼ�еİ�����Ŀ
count = 0;  %���Ӽ�����
[i,j]=size(X);%����X�Ĵ�С��iΪ�У�jΪ��
flag =0;  %��־
thresh = 300;
%�趨��ֵthreshΪ300
%ÿ�ν��봹ֱͶӰ����ȡֵ������ֵ��ʱ�򣬽�flag����Ϊ1
%��С����ֵ�����˳�ͶӰ��ʱ����������1���ҽ�flag��Ϊ0
for a = 1:j
    if X(1,a) >= thresh
        flag =1;
    else if X(1,a) <thresh && flag == 1
        count = count +1;
        flag =0;
        end
    end
end
fprintf('ͼ��һ����%d��ɴ��',count);

%��ģ�������жϸ���ɴͲ��λ�ã����Ҿ�ȷ��ȡÿ��ɴ��
%˼�룺���ݴ�ֱͶӰ����ÿһ��ɴ�ܿ�ȣ���������ϸ��������
%ÿ��ϸ�������д���ÿ��ɴ�ܵ���ʼλ��
MatOfPic_List = cell(1,count);   %����һ��ϸ�����飬һ������
flag =0;
c = 1;
for a = 1:j
    if X(1,a) ~= 0
        MatOfPic_List{c} = [MatOfPic_List{c} a];
        flag = 1;
    else if X(1,a) == 0 && flag == 1
            flag =0;
            [row,list] = size(MatOfPic_List{c});   %row Ϊ�У�listΪ��
            if list > 200;   %�����������200����ת����һ��ϸ������
                c = c + 1;
            else             %����������������ִ���´�ѭ��������˵���������Ϊ0�ĵ�
                continue;   
            end
            if c > count   %��c����ɴ����Ŀ��ʱ��ѭ��ֱ����ֹ
                break;
            end
         end
    end
end

%�������洹ֱͶӰȷ����ÿ��ɴ�ܵķ�Χ
%��ȡ��ÿһ��ɴ�ܣ� ����ˮƽͶӰ����ɴ�ܸ߶�
%Ȼ��ȷ��ÿ��ɴ�ܵ�λ��
%========================================================
%���Ե�һ��
%     [row_1,list] = size(MatOfPic_List{1});
%     xmin = MatOfPic_List{1}(1);
%     figure;subimage(bw);title('ȥ��ͼ��');
%     %��ָ��λ���ϻ�����Σ�Position���ĸ��������ֱ�Ϊ����ʼ���С��У����ο���
%     rectangle('Position',[xmin,0,list,3000],'EdgeColor','r');   
%========================================================
MatOfPic_Crop = cell(1,count);
% figure;subimage(bw);title('���ȷ����Ե��ͼ');
for c = 1:count
    [row_1,list] = size(MatOfPic_List{c});
    xmin = MatOfPic_List{c}(1);
    xmax = MatOfPic_List{c}(list);
    
    %��ԭͼָ����������д�����ڴ洢ϸ������
    MatOfPic_Crop{c} = bw(:,xmin:xmax);
%     %��ԭͼ�ϻ�����
%     rectangle('Position',[xmin,0,list,3000],'EdgeColor','r');
end

%����ȡ����ɴ��ÿһ��д��һ��ͼ
% imwrite(MatOfPic_Crop{1},'C:\Users\cheng\Desktop\Experiment\test\1.jpg');
% imwrite(MatOfPic_Crop{2},'C:\Users\cheng\Desktop\Experiment\test\2.jpg');
% imwrite(MatOfPic_Crop{3},'C:\Users\cheng\Desktop\Experiment\test\3.jpg');
% imwrite(MatOfPic_Crop{4},'C:\Users\cheng\Desktop\Experiment\test\4.jpg');
% imwrite(MatOfPic_Crop{5},'C:\Users\cheng\Desktop\Experiment\test\5.jpg');
% imwrite(MatOfPic_Crop{6},'C:\Users\cheng\Desktop\Experiment\test\6.jpg');
% ��ʾ�س���ÿһ��ͼ
for c = 1:count
    figure;imshow(MatOfPic_Crop{c});
end
disp('����ɽ�ͼ��ͼ����');
disp('���ڿ�ʼ����ͼ��');

%���س�����ɴ�ܽ�����ת����������ֱͶӰ��
%��ֹ�����ǣ���ֱͶӰ�����ؿ�ȴﵽ��С
angle = 1;  %����ɴ����ת�ĽǶȵ�ÿ�η�����
a = zeros(2,6); %�������ÿ��У��ͼ��ͶӰ��Ч��ȣ������ȶ�

for c = 1:count
    flag = 0;   %ѭ����ֹ����
    count = 0;  %������ͶӰ��Ч����Ŀ��
    while(flag ~= 1)
        %================================================
        %%%%��һ�δ�ֱͶӰ
        %================================================
        X= sum(MatOfPic_Crop{c}); %��һ�δ�ֱͶӰ
        figure;plot(X);
        [r1,l1] = size(X);
        for b = 1:l1
            if X(1,b) ~= 0              %��������
                %  a(1,1) = a(1,1) + 1;
                count = count + 1;
            end
        end
        a(1,c) = count;
        count = 0;
        %==========================================================
        MatOfPic_Crop{c} = imrotate(MatOfPic_Crop{c},angle);  %��ͼ��ʱ����תangle���Ƕ�
        %==========================================================
        %%%%�ڶ��δ�ֱͶӰ
        %==========================================================
        Y= sum(MatOfPic_Crop{c}); %�ڶ��δ�ֱͶӰ
        figure;plot(Y);
        [r2,l2] = size(Y);
        for b = 1:l2
            if Y(1,b) ~= 0              %����
                %    a(2,1) = a(2,1) + 1;
                count = count + 1;
            end
        end
        a(2,c) = count;
        %==========================================================
        %�ж�
        if a(2,1) >= a(1,1)
            flag = 1;
            MatOfPic_Crop{1} = imrotate(MatOfPic_Crop{1},-angle);
        else
            count = 0;
        end        
    end
    fprintf('��%d��ɴ��ͼ�������ɣ���\n',c);
    figure;imshow(MatOfPic_Crop{c});
end
    