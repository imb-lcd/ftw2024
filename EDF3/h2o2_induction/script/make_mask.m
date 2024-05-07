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

list = dir("../img/h2o2*BaSiC.tif");

for i = 1:length(list) % for each channel

    imgs = tiffreadVolume("../img/"+list(i).name);

    th_high = 480; % channel 1
    if contains(list(i).name,"c2") % channel 2
        th_high = 250;
    end
    th_area_lb = 20;
    th_area_ub = 5000;
    r_dilation = 40;
    r_erosion = 20;
    
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
        maskDS = bwareaopen(maskDS,30000);

        MASK{j} = maskDS;

    end
    landscape = uint8(cat(3,MASK{:}));
    [a,Z]=max(landscape,[],3);
    Z(a==0) = size(landscape,3)+1;
        
    imwrite(uint8(Z),"../img/landscape_"+list(i).name)
end
