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

% set the parameter for visualizing kymograph
frame_interval = 1;
scale = 1.260;
frame_toshow = 7:24;% frame range to show
xlimit = ([0 frame_toshow(end)-frame_toshow(1)]+[-0.5 0.5]).*frame_interval;
color_sig = [255 255 255;254 212 57]./255; % white/yellow

%% plot kymograph for available speed
well = 20;   angle = 135; ylimit = [0 3800]; text_label = "MAPK1,s"+well+","+angle+"^\circ";
% well = 68;   angle = 135; ylimit = [0 3800]; text_label = "mch,s"+well+","+angle+"^\circ";

% pbaRatio = [length(frame_toshow)*(201+12)-12 ceil(ylimit(2)/scale) 1];
pbaRatio = [1 1.2 1];

load("kymograph_s"+well+".mat");
% angle = kymograph.angle';
%         figure('WindowState','maximized')
%         tiledlayout('flow','TileSpacing','compact','Padding','compact')
for j = 1:length(angle)
    index = find(kymograph.angle==angle(j),1);

    maxR = kymograph.maxR{index};
    frame_range = 1:size(maxR,1);

    offset_y = 0; % (size(maxR,2)-3180).*scale;
    offset_x = (min(frame_toshow)-1).*frame_interval;

    maxR = maxR(frame_toshow,:); % 1:ceil(ylimit(2)/scale)

    % plotting
    nexttile
    hold on
    plotKymo(maxR,frame_interval,scale)
    %             plot(kymograph.front{index}.time,kymograph.front{index}.mode_dist,'mv','MarkerFaceColor','m')
    ylimit = ylim;
    % fitting line - cy5
    F = polyval(kymograph.speed{index}{1},(frame_range-1).*frame_interval)-offset_y; % end points of the fitting line
    plot((frame_range-1).*frame_interval-offset_x,F,'LineWidth',2,'color',[color_sig(1,:) 0.7]) % cy5[color_sig(1,:) 0.7]
    
    % annotate the measured speed - cy5
    x = (frame_range-1).*frame_interval-offset_x;
    y = F;
    [xi,yi] = polyxpoly(xlimit,[mean(ylimit) mean(ylimit)],x,y);
    slope = kymograph.speed{index}{1}(1)/(diff(ylimit)/diff(xlimit))*(pbaRatio(2)/pbaRatio(1));
    alpha = atand(slope);
    text(xi-1,yi,round(kymograph.speed{index}{1}(1)/60,2)+"µm/min",...
        'color','w','HorizontalAlignment','center',...
        'Rotation',alpha,'FontSize',16,'VerticalAlignment','bottom')
    text(0,0.9*ylimit(2),text_label,'Color','w')


    % set axis range and labels
    set(gca,'Xlim',xlimit,'YLim',ylimit,'Ytick',0:1000:floor(ylimit(2)/1000)*1000,'YTickLabel',0:floor(ylimit(2)/1000),...
        'fontsize',14,'tickdir','out','XColor','k','YColor','k',...
        'LineWidth',1,'PlotBoxAspectRatio',pbaRatio,'Layer','top')

    % add top and left edge
    plot(xlimit,[ylimit(2) ylimit(2)],'k','LineWidth',1)
    plot([xlimit(2) xlimit(2)],ylimit,'k','LineWidth',1)

    xlabel('Time (hr)')
    ylabel('Distance (mm)')
  
end
