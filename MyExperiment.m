close all;clear all;clc;
I = imread('C:\Users\cheng\Desktop\p.JPG');
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


    