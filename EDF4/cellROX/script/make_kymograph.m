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

pos = "s"+[30 25 28 29]; % well to process
% angle = [135 15 50 135]; % the directio to crop
angle = [135 45 45 135]; % the directio to crop

% set the parameter for visualizing kymograph
frame_interval = 1;
scale = 1.266;
frame_toshow = 1:14;
xlimit = ([0 frame_toshow(end)-frame_toshow(1)]+[-0.5 0.5]).*frame_interval; 
ylimit = [0 4000];

color_signal = [255 255 255;254 212 57]./255; % white/yellow
pbaRatio = [length(frame_toshow)*(201+12)-12 ceil(ylimit(2)/scale) 1];

%% plot kymograph
speed = [];
for i = 1:length(pos)

    % load setting for speed measurement and kymograph
    load("..\data\setting_"+pos(i)+".mat");
    load("..\data\kymograph_"+pos(i)+".mat");
    
    % get kymograph
    tmp = kymograph(ismember(kymograph.angle,angle(i)),:);

    % get speed
    speed = [speed;tmp.speed{1}{1}(1)/60 tmp.speed{2}{1}(1)/60];

    % retrieve kymograph
    maxR = tmp.maxR{2};
    frame_range = 1:size(maxR,1);
    
    % calculate the offset of x- and y-axis (spatial and temporal axis)
    offset_y = 0;%(size(maxR,2)-ceil(ylimit(2)/scale)).*scale;
    offset_x = (min(frame_toshow)-1).*frame_interval;

    maxR = maxR(frame_toshow,1:floor(ylimit(2)/scale));

    % plotting
    figure
    hold on
    plotKymo(maxR,frame_interval,scale)

    % fitting line - cy5
    F = polyval(tmp.speed{1}{1},(frame_range-1).*frame_interval)-offset_y;
    plot((frame_range-1).*frame_interval-offset_x,F,'LineWidth',2,'color',[color_signal(1,:) 0.7]) % cy5

    % annotate the measured speed - cy5
    x = (frame_range-1).*frame_interval-offset_x;
    y = F;
    [xi,yi] = polyxpoly(xlimit,[mean(ylimit) mean(ylimit)],x,y);
    slope = tmp.speed{1}{1}(1)/(diff(ylimit)/diff(xlimit))*(pbaRatio(2)/pbaRatio(1)); % /(diff(ylimit)/diff(xlimit))
    alpha = atand(slope);
    text(xi+1,yi,round(tmp.speed{1}{1}(1)/60,2)+"µm/min",...
        'color','w','HorizontalAlignment','center','Rotation',alpha,...
        'VerticalAlignment','middle','FontSize',16)

    % fitting line - ros
    F = polyval(tmp.speed{2}{1},(frame_range-1).*frame_interval)-offset_y;
    plot((frame_range-1).*frame_interval-offset_x,F,'LineWidth',2,'color',[1 1 0 0.7])

    % annotate the measured speed - ros
    x = (frame_range-1).*frame_interval-offset_x;
    y = F;
    [xi,yi] = polyxpoly(xlimit,[mean(ylimit) mean(ylimit)],x,y);
    slope = tmp.speed{2}{1}(1)/(diff(ylimit)/diff(xlimit))*(pbaRatio(2)/pbaRatio(1));
    alpha = atand(slope);
    text(0,ylimit(2)*0.9,pos(i),'color','w')
    text(xi-1,yi,round(tmp.speed{2}{1}(1)/60,2)+"µm/min",...
        'color','w','HorizontalAlignment','center','Rotation',alpha,...
        'VerticalAlignment','middle','FontSize',16)
    
    % set axis range and labels
    set(gca,'Xlim',xlimit,'YLim',ylimit,'YTickLabel',0:floor(ylimit(2)/1000),...
        'fontsize',16,'tickdir','out','XColor','k','YColor','k',...
        'LineWidth',1,'PlotBoxAspectRatio',pbaRatio)
    % add top and left edge
    plot(xlimit,[ylimit(2) ylimit(2)],'k','LineWidth',1)
    plot([xlimit(2) xlimit(2)],ylimit,'k','LineWidth',1)

    xlabel('Time (hr)')
    ylabel('Distance (mm)')

    hold off

%     if i==1
%         exportgraphics(gcf,"..\fig\kymograph.pdf")
%     else
%         exportgraphics(gcf,"..\fig\kymograph.pdf",'Append',true)
%     end

    close all

end
