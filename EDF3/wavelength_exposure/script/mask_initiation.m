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

% prefix = "Intensity10X";
% pos = "s"+(1:60); % well to process
% pos = "s"+[11 44 53]; % well to process

prefix = "Wavelength10X";
pos = "s"+(49:84); % well to process
pos = "s"+[56 82 84]; % well to process


%% for each well, identify one initiation
for i = 1:length(pos)

    % set the filename of the output
    oname = "..\data\setting_"+prefix+"_"+pos(i)+".mat";

    % if the output file existed, load it; otherwise use default setting
    if exist(oname,'file')
        load(oname)
        isSave = 0;
    else
        % default setting
        % frame_index: frame of initiation
        % signal:
        % range_area: filter out the region whose area is outside the range
        % r_dilation/r_erosion: connect dead cells
        % th_mask: 
        % boundary_index:
        initiation = struct('frame_index',3,'signal',"cy5",'th_intensity',0.9,...
            'range_area',[20 2000],'r_dilation',15,'r_erosion',10, ...
            'th_mask',5000,'boundary_index',2);
        isSave = 1;
    end
    
    % load image
    imgname = "..\img\"+prefix+"_"+pos(i)+"_"+initiation.signal+"_ff1_10.tif";
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
    
    % check initiation
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
    if ~isempty(stats)
        plot(stats(1).Centroid(1),stats(1).Centroid(2),'rx','MarkerSize',20)
    

    % save mask into setting
    initiation.mask = maskDS;
    if isSave
        save("..\data\"+oname,"initiation")
        exportgraphics(gcf,"..\img\check_mask_initiation\initiation_"+prefix+"_"+pos(i)+".jpg","Resolution",300)
    end
    end

    close all
end

%%
% pos = "s"+[19,4,8,9,10,21,22,23]; % well to process
% clear
% load('..\data\setting_s23.mat')
% new = initiation;
% load('..\data\v1\setting_s23.mat')
% old = initiation;
% imshowpair(old.mask,new.mask)