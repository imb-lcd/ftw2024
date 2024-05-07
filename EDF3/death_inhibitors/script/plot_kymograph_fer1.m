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

% s = "s1"; ybase = 0.4;
s = "s2"; ybase = 0.4; time_range = [-3 10]; dist_range = [0 2.5];
% s = "s3"; ybase = 0.9;
load("kymo_"+s+".mat")

%% make kymograph
speed = [];
close all

for j = 1
    % get speed
    speed = [speed;kymograph.speed{j}{1}(1)/60,kymograph.speed{j}{2}(1)/60];

    % retrieve kymograph
    maxR = kymograph.maxR{j};
    frame_range = 1:size(maxR,1);

    % set parameters for showing kymograph
    pxSize = scale;    
    frame_toshow = 1:size(maxR,1); % frame range to show
    xlimit = [min(time)-0.5 max(time)];
    ylimit = [0 (size(maxR,2)-1)*pxSize];
    
    % calculate the offset of x- and y-axis (spatial and temporal axis)
    offset_y = 0;%(size(maxR,2)-ceil(ylimit(2)/scale)).*scale;
    offset_x = 0;%(min(frame_toshow)-1).*frame_interval;

    maxR = maxR(frame_toshow,1:ceil(ylimit(2)/pxSize));

    figure
    hold on
    plotKymo(maxR,time,pxSize)
    frame1_treat = 5;

    for k = 1:2        
        x = time(kymograph.front{j}{k}.frame);
        
        % fitting line - cy5
        F = polyval(kymograph.speed{j}{k},x)-offset_y;
        
        % annotate the measured speed - cy5
        x = x-offset_x;
        y = F;
        [xi,yi] = polyxpoly(xlimit,[mean(y(y>0&y<ylimit(2))) mean(y(y>0&y<ylimit(2)))],x,y);

        slope = kymograph.speed{j}{k}(1)/(diff(ylimit)/diff(xlimit));
        alpha = atand(slope);

        % text(xi,yi,round(kymograph.speed{j}{k}(1)/60,2)+"µm/min",...
        %     'color','w','HorizontalAlignment','left','Rotation',alpha,...
        %     'VerticalAlignment','bottom','FontSize',16)
    end
    % text(0,ylimit(2)*.95,drug+"\_24\_s"+well,'color','w')
    % plot(time(frame1_treat),ylimit(2)*.9,'wv','markerfacecolor','w')

    % set axis range and labels
    set(gca,'Xlim',xlimit,'YLim',ylimit,'YTickLabel',0:floor(ylimit(2)/1000),'YTick',0:1000:floor(ylimit(2)/1000)*1000,...
        'fontsize',16,'tickdir','out','XColor','k','YColor','k',...
        'LineWidth',1,'Layer','top','PlotBoxAspectRatio',[1 1 1])

    % add top and left edge
    plot(xlimit,[ylimit(2) ylimit(2)],'k','LineWidth',1)
    plot([xlimit(2) xlimit(2)],ylimit,'k','LineWidth',1)

    xlabel('Time (h)')
    ylabel('Distance (mm)')    

    hold off

    %         if j==1
    %             exportgraphics(gcf,"..\fig\kymograph_"+drug+"_24.pdf")
    %         else
    %             exportgraphics(gcf,"..\fig\kymograph_"+drug+"_24.pdf",'Append',true)
    %         end
    % close all
end

% hold on
% plot(time(frame1_treat)+[-3 5 5 -3 -3],(0.9+[0 0 1.8 1.8 0])*1000,'y-')
% hold off

xlim(time(frame1_treat)+time_range)
ylim((ybase+dist_range)*1000)
ylimit = ylim;
hold on
plot(time(frame1_treat),800+ylimit(1),'wv','markerfacecolor','w')
hold off
xticks(0:2:16)
xticklabels(-2:2:14)
yticks(ylimit(1)+(0:0.5:dist_range(end))*1000)
yticklabels(0:0.5:dist_range(end))

% exportgraphics(gcf,"..\fig\"+s+"_kymograph.pdf")