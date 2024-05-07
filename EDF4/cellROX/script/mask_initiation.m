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

pos = ["s30" "s25" "s28" "s29"]; % well to process

for i = 1:length(pos)

    % set the filename of the output
    oname = "..\data\setting_"+pos(i)+".mat";

    % if the output file existed, load it; otherwise use default setting
    if exist(oname,'file')
        load(oname)
        isSave = 1;
    else
        % default setting
        % frame_index: frame of initiation
        % signal:
        % range_area: filter out the region whose area is outside the range
        % r_dilation/r_erosion: connect dead cells
        % th_mask: 
        % boundary_index:
        initiation = struct('frame_index',2,'signal',"cy5",'th_intensity',0.9,...
            'range_area',[20 1000],'r_dilation',15,'r_erosion',10, ...
            'th_mask',5000,'boundary_index',1);
        isSave = 1;
    end
    
    % load image
    imgname = "..\img\"+pos(i)+"_"+initiation.signal+"_ff1_10.tif";
    img = imread(imgname, initiation.frame_index, 'Info', imfinfo(imgname));
    
    % binarize image
    im_adjusted = imadjust(img,stretchlim(img));    
    mask = imbinarize(im_adjusted,initiation.th_intensity);
    mask = bwareafilt(mask,initiation.range_area);
    % imshow(BW)

    % dilate the threholding result to connect dead cells
    maskD = imfill(bwdist(mask)<initiation.r_dilation,'holes');    
    maskDS = bwdist(~maskD)>initiation.r_erosion;

    % remove small objects from the mask
    maskDS = bwareaopen(maskDS,initiation.th_mask);  

    % examine the boundary
    L = bwlabel(maskDS); 
    B = labeloverlay(im_adjusted,bwlabel(maskDS));

    figure('WindowState','maximized')
    tiledlayout(1,2,'TileSpacing','tight','Padding','tight')
    nexttile
    imshow(L,[0 max(L(:))],'Border','tight');
    title('Label matrix')    
    nexttile
    imshow(B)
    title('Image overlaid with the label matrix')
    
    % mark the initiation
    maskDS = L==initiation.boundary_index;    
    hold on
    stats = regionprops(maskDS,'Centroid');
    plot(stats(1).Centroid(1),stats(1).Centroid(2),'rx','MarkerSize',20)

    % save mask into setting
    initiation.mask = maskDS;
    if isSave
        save("..\data\"+oname,"initiation")
        exportgraphics(gcf,"..\img\initiation_"+pos(i)+".png","Resolution",600)
    end
    
    close all
end