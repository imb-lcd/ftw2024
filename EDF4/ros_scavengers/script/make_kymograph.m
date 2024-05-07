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

list = dir("./kymo_*.mat");
fname = arrayfun(@(s)string(s.name),list);
drug = extractBetween(fname,"_",".mat");
angle = [50 30 90 30 50];

speed = [];

figure;
tiledlayout(1,5)

for i = [5 4 1 3 2]%1:length(fname)

    load(fname(i))
    
    j = find(kymograph.angle==angle(i));
    
    % get speed
    speed = [speed;kymograph.speed{j}{1}(1)/60,kymograph.speed{j}{2}(1)/60];
    
    % retrieve kymograph
    maxR = kymograph.maxR{j};
    frame_range = 1:size(maxR,1);

    pxSize = 1.2602; % um/px
    frame_interval = 1; % hr
    frame_toshow = 1:size(maxR,1); % frame range to show

    xlimit = ([5 20]+[-0.5 0.5]).*frame_interval;
    ylimit = [0 2542*pxSize];

    % calculate the offset of x- and y-axis (spatial and temporal axis)
    offset_y = 0;%(size(maxR,2)-ceil(ylimit(2)/scale)).*scale;
    % offset_x = (min(frame_toshow)-1).*frame_interval;
    offset_x = 1;

    maxR = maxR(frame_toshow,1:ceil(ylimit(2)/pxSize));

    nexttile
    hold on
    plotKymo(maxR,frame_interval,pxSize)
    frame1_treat = 10;%kymograph.front{j}{1}.frame(end)+1;

    plot(frame1_treat-1,ylimit(2)*.5,'wv','markerfacecolor','w')
    plot([frame1_treat-1 frame1_treat-1],[ylimit(2) ylimit(2)*.5],'w--','LineWidth',1)

    % set axis range and labels
    set(gca,'Xlim',xlimit,'YLim',ylimit,'YTickLabel',0:floor(ylimit(2)/1000),'YTick',0:1000:floor(ylimit(2)/1000)*1000,...
        'fontsize',16,'tickdir','out','XColor','k','YColor','k',...
        'LineWidth',1,'Layer','top','PlotBoxAspectRatio',[1 1 1])
    xticks(5:5:20)
    xticklabels(0:5:15)

    % add top and left edge
    plot(xlimit,[ylimit(2) ylimit(2)],'k','LineWidth',1)
    plot([xlimit(2) xlimit(2)],ylimit,'k','LineWidth',1)

    xlabel('Time (hr)')
    ylabel('Distance (mm)')
    title(drug(i))

    hold off

    % exportgraphics(gcf,"..\fig\kymograph_"+drug(i)+".pdf")
    % close all
end
% exportgraphics(gcf,"..\fig\kymographs.pdf")