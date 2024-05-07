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

%% load images to quantify
fname = "..\img\s30_ros_ff1_10.tif"; % ros
info = imfinfo(fname);
img = arrayfun(@(i)imread(fname,i,"Info",info),1:length(info),...
    'UniformOutput',0);
dimg = arrayfun(@(i)img{i}-img{i-1},2:length(img),'UniformOutput',0);

fname = "..\img\s30_cy5_ff1_10.tif"; % cy5
info = imfinfo(fname);
img = arrayfun(@(i)imread(fname,i,"Info",info),1:length(info),...
    'UniformOutput',0);

oname = "..\data\setting_s30.mat";
load(oname)
mask = initiation.mask;

%% crop images
rot_angle = 90;
maskRotated = imrotate(mask,rot_angle);
S = regionprops(maskRotated,'Centroid');
center = fix(S.Centroid);

for j = 1:length(img)
    imgRotated = imrotate(img{j},rot_angle);
    crop = imcrop(imgRotated,[center(1)-100,1,200,3000-1]);
    imagelist_cy5{j} = crop;

    if j<length(img)
        imgRotated = imrotate(dimg{j},rot_angle);
        crop = imcrop(imgRotated,[center(1)-100,1,200,3000-1]);
        imagelist_dcellrox{j} = crop;
    end
end

%% plot mean intensity
close all
figure('position',[680   558   560   200])
hold on
px_length = max(size(crop));
data = [];
color_sig = [0 126 255;254 212 57]./255;

for wSize = 40
for j = 9
    colororder(color_sig)

%     plot((1:px_length).*1.266,flipud(smoothdata(mean(imagelist_cy5{j},2),'movmean',wSize)))
    y = flipud(smoothdata(mean(imagelist_cy5{j},2),'movmean',wSize)) -...
        flipud(smoothdata(mean(imagelist_cy5{1},2),'movmean',wSize));
    y(y<0) = 0;
    y = normalize(y,1,'range');
    plot((1:px_length).*1.266,y,'color',color_sig(1,:),'linewidth',2)
ylim([-0.05 1.05])
    data = [(1:px_length)'.*1.266,y];

    yyaxis right
% %     plot(flipud(smoothdata(mean(imagelist_cellrox{j},2),'movmean',wSize)))
    y = flipud(smoothdata(mean(imagelist_dcellrox{j-1},2),'movmean',wSize));
%     y = y-min(y(3:end));
    y(y<0) = 0;
    y = normalize(y,1,'range');
    plot((1:px_length).*1.266,y,'color',color_sig(2,:),'linewidth',2)
%     ylabel('CellROX')
    ylim([-0.05 1.05])
    data = [data,y];
% %     ylim([5 20])

    xlim([0 (length(y)-1)*1.266])
    xticks(0:1000:3000)
    xticklabels(0:3)
    xlabel("Distance (um)")
%     title("Time = "+j)

%     legend(["Cell death" "Lipid Peroxidation"],...
%             'Orientation','horizontal','Location','northoutside',...
%             'Box','off')
end
hold off
% xlim([0 4000])

% xlabel("Distance (um)")
% title("wSize = "+wSize)
end
set(gca,'FontSize',16,'LineWidth',1,'TickDir','out','YColor','k')
% print('-painters',gcf,"..\fig\profile.pdf",'-dpdf')

%%
tbl_source = array2table(data,'VariableNames',["Distance (um)" "Cell death (AU)" "ROS (AU)"]);
% writetable(tbl_source,"edf4.xlsx","Sheet","edf4a")
% writetable(data,"..\data\s30_profile.csv")