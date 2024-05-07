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
well = "30";
% list = dir("..\img\s"+well+"\for_outline\ros*.tif");
list = dir("..\img\s"+well+"\for_outline\cy5*.tif");

%%
MASK = cell(size(list));

for th_high = 400:20:500
    for r_dilation = 10:5:60
        for radius = 5:5:15
            if radius>r_dilation
                continue
            end

for i = 8%1:length(list)
    close all

    % load image for outlining wave
    fname = fullfile(list(i).folder,list(i).name);
    img = flip(imread(fname),1);

    % if the outline exists, load the setting; otherwise use the default
    if exist("..\data\mask_s"+well+".mat","file")
        load("..\data\mask_s"+well+".mat","th_high","th_area_lb","th_area_ub","r_dilation","r_erosion")
        isSave = 0;
    else
        % ros
%         th_high = 181; % 18000 592
%         th_area_lb = 20;
%         th_area_ub = 6000;
%         r_dilation = 15;
%         r_erosion = 10;
        
        % cy5
%         th_high = 400;
        th_area_lb = 20;
        th_area_ub = 1000;
%         r_dilation = 15;
        r_erosion = r_dilation-radius;
    end

    % binarize the image
    mask = imbinarize(img,th_high/2^16);
    mask = bwareafilt(mask,[th_area_lb th_area_ub]);
    figure("Name","High threshold"); imshow(mask,'Border','tight')

    % dilation
    %     maskD = imfill(bwdist(mask)<r_dilation,'holes');
    maskD = bwdist(mask)<r_dilation;
    maskD = ~bwareaopen(~maskD,100000);

    % erosion
    maskDS = bwdist(~maskD)>r_erosion;

    % size filtering
    maskDS = bwareaopen(maskDS,5000);
    maskDS = ~bwareaopen(~maskDS,100000);

    % smooth outlines
%     H = fspecial('average',60);
%     blurredImage = imfilter((maskDS),H,'replicate');
%     maskDS_smoothed = imfill(blurredImage > 0.1,'holes');
%     maskDS = maskDS_smoothed;

    % smooth outlines
    diskRadius = 36;
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
    
%     figure("Name","Initial vs final mask");imshowpair(mask,maskDS)
% 
%     bo = bwboundaries(maskDS);
%     figure("Name","Outline");
%     imshow(imadjust(img,stretchlim(img,0.0035/2)),'border','tight'); colormap(cyanHot)
% %     imshow(img,[185 440],'Border','tight'); colormap(cyanHot)
%     hold on
%     arrayfun(@(j) plot(bo{j}(:,2),bo{j}(:,1),'w','LineWidth',2),1:length(bo));
%     hold off
%     xlim([867 867+1499])
%     ylim([611 611+1499])
% 
%     hold on
%     plot(ros(:,2),ros(:,1),'y','linewidth',2)

    MASK{i} = maskDS;
end

% if isSave
%     save("..\data\mask_s"+well+".mat","MASK","th_high","th_area_lb","th_area_ub","r_dilation","r_erosion")
% end

%% show landscape
landscape = uint8(cat(3,MASK{:}));
[a,Z]=max(landscape,[],3);
Z(a==0) = size(landscape,3)+1;

close all
imshow(Z,[min(Z(:)) max(Z(:))],'border','tight')

% cy5 = temp{1};
% ros = temp{2};
% imshow(cy5==1+ros==1,[0 2],'border','tight')

%%
i = 8
fname = fullfile(list(i).folder,list(i).name);
img = flip(imread(fname),1);
img = imread("..\fig\s30_composite_med2_wo_scaleBar.tif");
% fname = fullfile(list(i-1).folder,list(i-1).name);
% img2 = flip(imread(fname),1);
% img = img-img2;

close all
figure
% imshow(imadjust(img),'Border','tight')
% imshow(medfilt2(img,[2 2]),[285 440],'Border','tight')
imshow(img,'Border','tight')
colormap(cyanHot)
hold on
for i = 1:max(Z(:))
    mask_ros = Z<=i;
    if any(mask_ros(:))
        outline_ros = bwboundaries(mask_ros);
        for j = 1:length(outline_ros)
            bdy = outline_ros{j};
            bdy(sum(ismember(bdy,[1 3000]),2)>0,:) = nan;

            plot(bdy(:,2),bdy(:,1),'color','w','linewidth',4)
        end
        
    end
end
% xlim([1 4500])
% ylim([501 5000])

load("outline_ros_frame8.mat")
hold on
plot(bdy(:,2),bdy(:,1),'y','linewidth',4)
hold off

xlim([869 863+1499])
ylim([613 613+1499])

text(2000,700,"("+th_high+","+r_dilation+","+r_erosion+")",'color','w','FontSize',20,'FontWeight','bold')

exportgraphics(gcf,"s30_"+th_high+"_"+r_dilation+"_"+r_erosion+".jpg",'Resolution',300)

        end
    end
end
% S = regionprops(Z<=1,'centroid');
% center = fix(S.Centroid);
% 
% viscircles(center,197,'Color','r')
% % hold on
% % plot(cy5(:,2),cy5(:,1),'w','linewidth',2)
% 
% pgon = polyshape([869 869+1499 869+1499 869],...
%     [613 613 613+1499 613+1499]);
% hold on
% p = plot(pgon,'FaceColor','none','EdgeColor','y','LineWidth',2,'LineStyle','--');
% hold off
% 
% print('-painters',gcf,"..\fig\outline_s30_ros_global.svg",'-dsvg')
% 
% xlim([869 863+1499])
% ylim([613 613+1499])
% print('-painters',gcf,"..\fig\outline_s30_cy5_local.svg",'-dsvg')