%     Copyright (C) 2024  Chia-Chou Wu
%
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
%
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
%
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <https://www.gnu.org/licenses/>.

%% initialize environment
clc; clear; close all

load("cyanHot.mat")

imgs = tiffreadVolume("../img/rsl3_s3_nuc_BaSiC_cropped.tif");
imgs = imgs(:,:,13:2:end);

th_high = 800; % channel 1
th_area_lb = 20;
th_area_ub = 5000;
r_dilation = 20;
r_erosion = 15;

MASK = cell(size(imgs,3),1);
for j = 1:size(imgs,3) % for each frame, get a mask

    img = imgs(:,:,j);
    img = medfilt2(img);

    % binarize the image
    mask = imbinarize(img,th_high/2^16);
    mask = bwareafilt(mask,[th_area_lb th_area_ub]);

    % dilation
    maskD = bwdist(mask)<r_dilation;
    maskD = ~bwareaopen(~maskD,th_area_ub);

    % erosion
    maskDS = bwdist(~maskD)>r_erosion;

    % size filtering
    maskDS = bwareaopen(maskDS,3000);

    MASK{j} = maskDS;

end
landscape = uint8(cat(3,MASK{:}));
[a,Z]=max(landscape,[],3);
Z(a==0) = size(landscape,3)+1;

% imwrite(uint8(Z),"../img/landscape_"+list(i).name)
% end
%
%%
figure('WindowState','maximized')
tiledlayout(1,size(imgs,3),'TileSpacing','none','Padding','tight')
for i = 1:size(imgs,3)
    nexttile    
    imshow(imgs(:,:,i),[530 795],'border','tight')
    colormap(cyanHot)    
    mask = Z<=i;
    mask = imgaussfilt(double(mask),10)>0.3;
    B = bwboundaries(mask);
    for k = 1:length(B)
        x = B{k}(:,2);
        y = B{k}(:,1);
        x(x==1 | x==size(mask,2))=nan;
        y(y==1 | y==size(mask,1))=nan;
        hold on
        plot(x,y,'w','LineWidth',2)
        hold off
    end
    title("frame"+(11+i*2))
end
sgtitle("th = "+th_high)
% copygraphics(gcf,'ContentType','image')
% exportgraphics(gcf,"../fig/outline/outline_s3.pdf",'ContentType','vector')