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

list = dir("../img/landscape_h2o2_1204_s15*.tif");
% names = arrayfun(@(s)extractBetween(string(s.name),"k_",".mat"),list);
% imgnames = arrayfun(@(s)strsplit(s,"_"),names,'UniformOutput',0);
% imgnames = cellfun(@(s)strjoin([s(2),s(1)],"_"),imgnames);
% imgnames = strrep(imgnames,"c","_c");

% imgnames = imgnames(2:2:end);
% list = list(2:2:end);

% img = imread("../fig/image/h2o2_1204_s15_v2_BaSiC_frame10.tif");
img = imread("../fig/image/h2o2_1204_s15_BaSiC_frame10 (RGB).tif");
% img = imread("../fig/image/h2o2_1204_s15_v2_BaSiC_cropped_nuc_t5.tif");

for i = 2%:length(imgnames)
    
    landscape = imread("../img/"+list(i).name);
    % makeRectangle(2522, 4995, 4000, 2000);
    landscape = landscape(4996:4996+2000-1,2523:2523+4000-1);
    % makeRectangle(22, 0, 1300, 1300);
    % landscape = landscape(1:1+1300-1,23:23+1300-1);

    imshow(img)
    for j = 1:max(landscape(:))
        mask = landscape<=j;
        mask = imgaussfilt(double(mask),20)>0.3;
        B = bwboundaries(mask,'noholes');
        for k = 1:length(B)
            x = B{k}(:,2);
            y = B{k}(:,1);
            x(x==1 | x==size(mask,2))=nan;
            y(y==1 | y==size(mask,1))=nan;
            hold on
            plot(x,y,'y','LineWidth',2)
            hold off
        end
    end
    exportgraphics(gcf,"../fig/outline/1204_s15_v2_BaSiC_ros_outline.pdf",'ContentType','vector')
    % exportgraphics(gcf,"../fig/outline/1204_s15_v2_BaSiC_cropped_nuc_outline.pdf",'ContentType','vector')

    % imgs = tiffreadVolume("../img/h2o2_"+imgnames(i)+"_BaSiC.tif");

    % load(list(i).name,"MASK");
    % landscape = uint8(cat(3,MASK{:}));
    % [a,Z]=max(landscape,[],3); % find the first frame in the mask
    % Z(a==0) = size(landscape,3)+1;
    % 
    % imwrite(uint8(Z),"landscape_"+names(i)+".tif")

    % climit = [200 1200];
    % climit = [250 450];
    % cmap = flipud(sky);
    % if contains(imgnames(i),"c2")
    %     climit = [150 300];
    %     climit = [150 250];
    %     cmap = autumn;
    % end
    %
    % %%% outline for all frames
    % figure
    % imshow(imgs(:,:,end));
    % clim(climit)
    % colormap(cmap)
    % % color_time = flipud(turbo(length(MASK)));
    % B = cell(size(MASK));
    % for j = fliplr(1:length(MASK))
    %     mask = Z<=j;
    %     mask = imgaussfilt(double(mask),40)>0.3;
    %     B{j} = bwboundaries(mask);
    %     for k = 1:length(B{j})
    %         x = B{j}{k}(:,2);
    %         y = B{j}{k}(:,1);
    %         x(x==1|x==size(imgs,2)) = nan;
    %         y(y==1|y==size(imgs,1)) = nan;
    %         hold on
    %         plot(x,y,'LineWidth',2,'Color','y')
    %         hold off
    %     end
    % end

    %%% outline for individual frame
    % for j = 1:length(MASK)
    %     figure;
    %     imshow(imgs(:,:,j),climit); colormap(cyanHot)
    %
    %     mask = Z<=j;
    %     % figure;imagesc(mask)
    %     % figure;imagesc(imgaussfilt(double(mask),40)>0.3)
    %     mask = imgaussfilt(double(mask),40)>0.3;
    %     lm = bwlabel(mask);
    %     B = bwboundaries(mask);
    %     for k = 1:length(B)
    %         x = B{k}(:,2);
    %         y = B{k}(:,1);
    %         x(x==1|x==size(imgs,2)) = nan;
    %         y(y==1|y==size(imgs,1)) = nan;
    %         hold on
    %         plot(x,y,'y','LineWidth',2)
    %         hold off
    %     end
    %     % exportgraphics(gcf,"../fig/outline/"+imgnames(i)+"_frame"+pad(string(j),2,'left','0')+".pdf","ContentType","vector")
    %     close all
    % end

end

%%
clc; clear; close all

load("cyanHot.mat")

list = dir("../img/landscape_h2o2_1204_s15*.tif");
img = imread("../fig/image/h2o2_1204_s15_v2_BaSiC_cropped_nuc_t5.tif");

for i = 2%:length(imgnames)

    landscape = imread("../fig/image/h2o2_1204_s15_v2_BaSiC_cropped_nuc_t5_mask.tif");
    % makeRectangle(2522, 4995, 4000, 2000);
    % landscape = landscape(4996:4996+2000-1,2523:2523+4000-1);
    % makeRectangle(22, 0, 1300, 1300);
    % landscape = landscape(1:1+1300-1,23:23+1300-1);

    imshow(img)
    % for j = 1:max(landscape(:))
        mask = landscape>0;
        % mask = imgaussfilt(double(mask),20)>0.3;
        B = bwboundaries(mask,'noholes');
        for k = 1:length(B)
            x = B{k}(:,2);
            y = B{k}(:,1);
            x(x==1 | x==size(mask,2))=nan;
            y(y==1 | y==size(mask,1))=nan;
            hold on
            plot(x,y,'w','LineWidth',2)
            hold off
        end
    % end
    exportgraphics(gcf,"../fig/outline/1204_s15_v2_BaSiC_cropped_nuc_outline.pdf",'ContentType','vector')
end