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

prefix = ["day-6_5_whole_limb",...
    "day-6_5_zoomIn",...
    "day-7_whole_limb",...
    "day-7_zoomIn",...
    "day-7_8_whole_limb",...
    "day-7_8_zoomIn",...
    "day-8_whole_limb",...
    "day-8_zoomIn"];

%%
for i = [1 2 5 6]
    limb = imread("../fig/"+prefix(i)+".tif");
    mask_limb = imread("../img/"+prefix(i)+"_mask.tif");
    BW = double(mask_limb>=255);
    BW = double(imgaussfilt(BW,10)>0.3);
    [B,L] = bwboundaries(BW,8,'noholes');

    xy = [B{1}(:,2) B{1}(:,1)];
    xy(ismember(xy(:,1),[1 size(limb,2)]),1) = nan;
    xy(ismember(xy(:,2),[1 size(limb,1)]),2) = nan;

    figure
    imshow(limb)
    hold on
    plot(xy(:,1),xy(:,2),'y','LineWidth',2)
    hold off

    % exportgraphics(gcf,"../fig/"+prefix(i)+"_outline.pdf","ContentType","vector");

    % exportgraphics(gcf,prefix(i)+"_wo_outline.png","ContentType","image","Resolution",300,"BackgroundColor","k");

    close all
end

