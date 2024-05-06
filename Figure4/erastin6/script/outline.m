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

isSave = 0;
well = "8"; % [21 16 8 24]
list = dir("..\img\s"+well+"\for_outline\ros*.tif");
% list = dir("..\img\s"+well+"\for_outline\cy5*.tif");

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
        isSave = 0;
    else
        % ros
        th_high = 400; % 18000 592
        th_area_lb = 20;
        th_area_ub = 6000;
        r_dilation = 20;
        r_erosion = 10;
        
        % cy5
%         th_high = 800;
%         th_area_lb = 20;
%         th_area_ub = 2000;
%         r_dilation = 60;
%         r_erosion = 40;
    end
    th_high = 475;

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
    maskDS = bwareaopen(maskDS,5000);
    maskDS = ~bwareaopen(~maskDS,100000);

    % smooth outlines
%     H = fspecial('average',60);
%     blurredImage = imfilter((maskDS),H,'replicate');
%     maskDS_smoothed = imfill(blurredImage > 0.2,'holes');
%     maskDS = maskDS_smoothed;
    % smooth outlines
    diskRadius = 30;
    se = strel('disk', diskRadius, 0);
    kernel = se.Neighborhood / sum(se.Neighborhood(:));
    blurredImage = cellfun(@(i)conv2(double(i), kernel, 'same'),{maskDS},'UniformOutput',0);
    maskDS_smoothed = cellfun(@(x)imfill(x > 0.2,'holes'),blurredImage,'UniformOutput',0);
    maskDS = maskDS_smoothed{1};

    % keep the biggest region
    L = bwlabel(maskDS);
    value = setdiff(min(L(:)):max(L(:)),0);
    if isempty(value)
        continue
    end
    area = arrayfun(@(v)nnz(L==v),value);
    [~,index] = max(area);
    maskDS = L==value(index);
    
    figure("Name","Initial vs final mask");imshowpair(mask,maskDS)

    bo = bwboundaries(maskDS);
    figure("Name","Outline");
    imshow(imadjust(img,stretchlim(img,0.0035/2)),'border','tight'); colormap(cyanHot)
    hold on
    arrayfun(@(j) plot(bo{j}(:,2),bo{j}(:,1),'y','LineWidth',0.1),1:length(bo));
    hold off

    MASK{i} = maskDS;
end

%% show contours
landscape = uint8(cat(3,MASK{:}));
[a,Z]=max(landscape,[],3);
Z(a==0) = size(landscape,3)+1;

close all
imshow(Z,[min(Z(:)) max(Z(:))],'border','tight')

%% plot outlines
i = 2
fname = fullfile(list(i).folder,list(i).name);
img = imread(fname);

close all
figure
imshow(imadjust(img),'Border','tight')
% imshow(img,[212 467],'Border','tight')
colormap(cyanHot)
hold on
for i = 1:max(Z(:))
    mask_ros = Z<=i;
    if any(mask_ros(:))
        outline_ros = bwboundaries(mask_ros);
        for j = 1:length(outline_ros)
            bdy = outline_ros{j};
            bdy(sum(ismember(bdy,[1 3000]),2)>0,:) = nan;

            plot(bdy(:,2),bdy(:,1),'w','linewidth',2)
        end
        
    end
end

load("..\data\setting_s"+well+".mat")

S = regionprops(initiation.mask,'centroid');
center = fix(S.Centroid);

viscircles(center,197,'Color','r')

% print('-painters',gcf,"..\fig\outline_s"+well+"_ros.svg",'-dsvg')
