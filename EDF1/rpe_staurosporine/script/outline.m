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

isSave = 1;
well = "6";
list = dir("..\img\s"+well+"\for_outline\cy5*.tif");

%%
MASK = cell(size(list));

for i = 1:length(list)
    close all
    
    % load image for outlining wave
    fname = fullfile(list(i).folder,list(i).name);
    img = imread(fname);

    % if the outline exists, load the setting; otherwise use the default
    if exist("..\data\mask_s"+well+".mat","file")
        load("..\data\mask_s"+well+".mat","th_high","th_area_lb","th_area_ub","r_dilation","r_erosion")
        isSave = 1;
    else
        th_high = 700;
        th_area_lb = 10;
        th_area_ub = 3000;
        r_dilation = 7;
        r_erosion = 5;
    end    
    th_high = 700;
        th_area_lb = 10;
        th_area_ub = 3000;
        r_dilation = 7;
        r_erosion = 5;

    % binarize the image
    mask = imbinarize(img,th_high/2^16);
    mask = bwareafilt(mask,[th_area_lb th_area_ub]);
    figure("Name","High threshold"); imshow(mask,'Border','tight')
    
    % dilation
%     maskD = imfill(bwdist(mask)<r_dilation,'holes');
    maskD = bwdist(mask)<r_dilation;
    maskD = ~bwareaopen(~maskD,th_area_ub);
    
    % erosion
    maskDS = bwdist(~maskD)>r_erosion;

    % size filtering
%     maskDS = bwareaopen(maskDS,3000);
%     maskDS = ~bwareaopen(~maskDS,50000);

    figure("Name","Initial vs final mask");imshowpair(mask,maskDS)

    bo = bwboundaries(maskDS);
    figure("Name","Outline");
    imshow(imadjust(img,stretchlim(img,0.0035/2)),'border','tight'); colormap(cyanHot)
    hold on
    arrayfun(@(j) plot(bo{j}(:,2),bo{j}(:,1),'y','LineWidth',0.1),1:length(bo));
    hold off    
    
    MASK{i} = maskDS;
end

if isSave
    save("..\data\mask_s"+well+".mat","MASK","th_high","th_area_lb","th_area_ub","r_dilation","r_erosion")
end

%% show landscape
landscape = uint8(cat(3,MASK{:}));
[a,Z]=max(landscape,[],3);
Z(a==0) = size(landscape,3)+1;

close all
imshow(Z,[min(Z(:)) max(Z(:))],'border','tight')

