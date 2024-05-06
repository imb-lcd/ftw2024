clc;clear;close all;

mask = imread("t1_c2_mask_cropped.tif");
BW = mask;
BW = imgaussfilt(BW,5)>0.3;
[B,L] = bwboundaries(BW,8,'noholes');
img  = imread("t1_c1_cropped_filtered.tif");
close all
imshow(img)
% colormap([abyss;flipud(sky)])
hold on
x = B{1}(:,2);
y = B{1}(:,1);
x(x==1 | x==size(img,2))=nan;
y(y==1 | y==size(img,1))=nan;
plot(x,y,'y','LineWidth',2)

plot([1931 1931+753 1931+753 1931 1931],[3300 3300 3300+1217 3300+1217 3300],'r-')
hold off
exportgraphics(gcf,"outline.pdf",'ContentType','vector')