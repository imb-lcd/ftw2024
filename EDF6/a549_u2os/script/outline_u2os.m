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

mask = tiffreadVolume("../img/MASK_u2os_erastin_fac.tif");

L = cell(size(mask,3),1);
for i = 1:size(mask,3)
    L{i} = bwlabel(squeeze(mask(:,:,i)));
end

%%
i = 7;
close all
figure
imagesc(L{i})
title(i)

wave_id = cell(size(L));
wave_id{2} = 35;
wave_id{3} = 31;
wave_id{4} = 19;
wave_id{5} = 7;
wave_id{6} = 3;
wave_id{7} = 1;

%%
load("cyanHot.mat")
img = tiffreadVolume("../img/u2os_erastin_fac.tif");
img = img(:,:,27:33);
BW = cell(size(L));

% tiledlayout(2,4,'TileSpacing','tight','Padding','tight')
for i = 1:length(L)
    if ~isempty(wave_id{i})
        BW{i} = ismember(L{i},wave_id{i});
    else
        BW{i} = zeros(size(L{i}));
    end
    [B,~] = bwboundaries(BW{i},8,'noholes');
    % nexttile
    close all
    imshow(img(:,:,i),[720 1280],'border','tight')
    colormap(cyanHot)
    hold on
    for j = 1:length(B)
        x = B{j}(:,2);
        y = B{j}(:,1);
        x(x==1 | x==size(img,2))=nan;
        y(y==1 | y==size(img,1))=nan;
        plot(x,y,'y','LineWidth',2)
    end
    hold off
    title(i)
    % exportgraphics(gcf,"../fig/u2os_erastin_fac_outline"+i+".pdf",'ContentType','vector')
end

close all
figure
% tiledlayout(2,4,'TileSpacing','tight','Padding','tight')
imshow(img(:,:,end),[720 1280],'border','tight')
    colormap(cyanHot)

for i = 1:length(L)
    if ~isempty(wave_id{i})
        BW{i} = ismember(L{i},wave_id{i});
    else
        BW{i} = zeros(size(L{i}));
    end
    [B,~] = bwboundaries(BW{i},8,'noholes');
    % nexttile
    
    hold on
    for j = 1:length(B)
        x = B{j}(:,2);
        y = B{j}(:,1);
        x(x==1 | x==size(img,2))=nan;
        y(y==1 | y==size(img,1))=nan;
        plot(x,y,'y','LineWidth',2)
    end
    hold off
    % title(i+19)
   
end
exportgraphics(gcf,"../fig/u2os_erastin_fac_outline_all.pdf",'ContentType','vector')
