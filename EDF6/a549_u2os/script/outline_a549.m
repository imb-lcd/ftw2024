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

mask = tiffreadVolume("../img/MASK_a549_erastin_fac.tif");
L3 = bwlabeln(mask);

L = cell(size(mask,3),1);
for i = 1:size(mask,3)
    L{i} = bwlabel(squeeze(mask(:,:,i)));
    % L{i} = bwlabel(squeeze(L3(:,:,i))==21);
end

%%
i = 16;
% close all
figure
imagesc(L{i})
title(i)

wave_id = cell(size(L));
wave_id{2} = 1;
wave_id{3} = 1;
wave_id{4} = [1 2];
wave_id{5} = [1 2];
wave_id{6} = [1 7];
wave_id{7} = [1 3 7];
wave_id{8} = [1 2 3 5];

wave_id{9} = [1 2 3 4 6 7 13];
wave_id{10} = [1 2 3 9];
wave_id{11} = [1 2 10 13];
wave_id{12} = [1 2 3 7 22 15 24 25 17 5];
wave_id{13} = [1 2 3 15 18 14 16 21];
wave_id{14} = [1:3 18 16 17 22];
wave_id{15} = [1:3 6 14 16 20 18 19 21 22 25];
wave_id{16} = [1:4 14 15 18 19 13 16];

wave_id{17} = [1:4 9 11 13 15 17 18 23];
wave_id{18} = [1:3 5 9 15:19 24];
wave_id{19} = [1 2 3 5 6 10 11 12 18 19 24];
wave_id{20} = [1:4 8 10 14];
wave_id{21} = [1:4 8 10 17 21];
wave_id{22} = [1:4 15 17 20];
wave_id{23} = [1:4];

%%
load("cyanHot.mat")
img = tiffreadVolume("../img/a549_erastin_fac.tif");
img = img(:,:,20:42);
BW = cell(size(L));

close all
figure
% tiledlayout(2,4,'TileSpacing','tight','Padding','tight')
imshow(img(:,:,end),[720 1280],'border','tight')
    colormap(cyanHot)

for i = 1:2:20%length(L)
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
    % exportgraphics(gcf,"../fig/a549_erastin_fac_outline"+i+".pdf",'ContentType','vector')
end
exportgraphics(gcf,"../fig/a549_erastin_fac_outline_all.pdf",'ContentType','vector')