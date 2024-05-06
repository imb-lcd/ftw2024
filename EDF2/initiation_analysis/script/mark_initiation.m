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

%%
fname = "..\img\s59_cy5_ff1.tif";
img = arrayfun(@(i) imread(fname,i),5:9,'UniformOutput',0);

% determine threshold using the third frame (why?)
I = 2;
im_adjusted = imadjust(img{I},stretchlim(img{I}));
mask = imbinarize(im_adjusted,0.9);
test = regionprops('table',(mask>0),img{I},'PixelValues');
th = prctile(vertcat(test.PixelValues{:}),50);

% binarize image
% im_adjusted = cellfun(@(I) imadjust(I,stretchlim(I)),img,'UniformOutput',0);
mask = cellfun(@(I) imbinarize(I,double(th)/2^16),img,'UniformOutput',0);
mask = cellfun(@(I) bwareafilt(I,[20 1000]),mask,'UniformOutput',0);

% dilate the threholding result to connect dead cells
maskD = cellfun(@(I) imfill(bwdist(I)<20,'holes'),mask,'UniformOutput',0);
maskDS = cellfun(@(I) bwdist(~I)>10,maskD,'UniformOutput',0);

% montage(maskDS)
%%
initiation{1} = ismember(bwlabel(maskDS{1}),[84 97]);
[r,c] = find(initiation{1}>0);
center{1} = [mean(c),mean(r)]; % [x,y]

%%
initiation{2} = ismember(bwlabel(maskDS{2}),[126]);
[r,c] = find(initiation{2}>0);
center{2} = [mean(c),mean(r)]; % [x,y]

%%
initiation{3} = ismember(bwlabel(maskDS{2}),[217]);
[r,c] = find(initiation{3}>0);
center{3} = [mean(c),mean(r)]; % [x,y]

%%
initiation{4} = ismember(bwlabel(maskDS{2}),[233 259]);
[r,c] = find(initiation{4}>0);
center{4} = [mean(c),mean(r)]; % [x,y]

%%
initiation{5} = ismember(bwlabel(maskDS{2}),[2 8 9 12 15 19]);
[r,c] = find(initiation{5}>0);
center{5} = [mean(c),mean(r)]; % [x,y]

%%
initiation{6} = ismember(bwlabel(maskDS{3}),[278]);
[r,c] = find(initiation{6}>0);
center{6} = [mean(c),mean(r)]; % [x,y]

%%
initiation{7} = ismember(bwlabel(maskDS{3}),[111]);
[r,c] = find(initiation{7}>0);
center{7} = [mean(c),mean(r)]; % [x,y]

%%
initiation{8} = ismember(bwlabel(maskDS{3}),[231]);
[r,c] = find(initiation{8}>0);
center{8} = [mean(c),mean(r)]; % [x,y]

%%
close all
figure
imshow(img{2},[330,680],'border','tight')
hold on
arrayfun(@(i) plot(center{i}(1),center{i}(2),'rx','markersize',20),1:length(center))
hold off

