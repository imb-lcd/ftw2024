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

load("..\data\summary_wavelength.mat")

% set the parameter for visualizing kymograph
frame_interval = 1;
scale = 1.266;
frame_toshow = 1:16;% frame range to show
xlimit = ([0 frame_toshow(end)-frame_toshow(1)]+[-0.5 0.5]).*frame_interval; 
ylimit = [0 2000];

color_sig = [255 255 255;254 212 57]./255; % white/yellow

%% plot kymograph for available speed
for i = 1:28%height(platemap)
    if ~isempty(platemap.speed{i})
        pos = "s"+platemap.wells(i);
        load("..\data\kymograph_Wavelength10X_"+pos+".mat");

        angle= platemap.speed{i}(:,2);
%         figure('WindowState','maximized')
        for j = 1:length(angle)
            index = find(kymograph.angle==angle(j),1);

            maxR = kymograph.maxR{index};
            frame_range = 1:size(maxR,1);

            offset_y = 0; % (size(maxR,2)-3180).*scale;
            offset_x = 0; % (min(frame_toshow)-1).*frame_interval;

%             maxR = maxR(frame_toshow,:);

            % plotting
            figure
            hold on
            plotKymo(maxR,frame_interval,scale)
            plot(kymograph.front{index}.time,kymograph.front{index}.mode_dist,'mv','MarkerFaceColor','m')

            % fitting line - cy5
            F = polyval(kymograph.speed{index}{1},(frame_range-1).*frame_interval)-offset_y; % end points of the fitting line
            plot((frame_range-1).*frame_interval-offset_x,F,'LineWidth',2,'color',[color_sig(1,:) 0.7]) % cy5[color_sig(1,:) 0.7]
            % annotate the measured speed - cy5
            x = (frame_range-1).*frame_interval-offset_x;
            y = F;
            [xi,yi] = polyxpoly(xlimit,[mean(ylimit) mean(ylimit)],x,y);
            alpha = atand(kymograph.speed{index}{1}(1)/(diff(ylimit)/diff(xlimit)));
            text(xi,yi,sprintf('%.4fum/s',kymograph.speed{index}{1}(1)/3600),...
                'color','w','HorizontalAlignment','center','Rotation',alpha,'VerticalAlignment','bottom')
            title(platemap.light(i)+", s"+platemap.wells(i)+", "+angle(j)+"^\circ")

            % set axis range and labels
            % 'YLim',ylimit,'YTickLabel',0:0.5:2,
            set(gca,'Xlim',xlimit,...
                'fontsize',14,'tickdir','out','XColor','k','YColor','k',...
                'LineWidth',1,'PlotBoxAspectRatio',[14*(201+12)-12 3180 1])
            xlabel('Time (hr)')
            ylabel('Distance (um)')

            if i==1 && j==1
                exportgraphics(gcf,"..\fig\kymograph_wavelength.pdf")
            else
                exportgraphics(gcf,"..\fig\kymograph_wavelength.pdf",'Append',true)
            end
            close all
        end
    end
end

%% plot kymograph
for i = 1:length(pos)

    % load setting for setting and kymograph
    load("..\data\setting_"+pos(i)+".mat");
    load("..\data\kymograph_"+pos(i)+".mat");

    % retrieve kymograph
    maxR = kymograph.maxR{2};
    frame_range = 1:size(maxR,1);

    offset_y = (size(maxR,2)-3180).*scale;
    offset_x = (min(frame_toshow)-1).*frame_interval;

%     maxR = maxR(frame_toshow,end-3179:end); %

    maxR = maxR([min(frame_toshow)-1 frame_toshow],end-3179:end); % one more frame for differential
    maxR = diff(maxR,1,1);

    % plotting
    figure
    hold on
    plotKymo(maxR,frame_interval,scale)

    % fitting line - cy5
    F = polyval(kymograph.speed{1}{1},(frame_range-1).*frame_interval)-offset_y; % end points of the fitting line
    plot((frame_range-2).*frame_interval-offset_x,F,'LineWidth',2,'color',[color_sig(1,:) 0.7]) % cy5[color_sig(1,:) 0.7]
    % annotate the measured speed - cy5
    x = (frame_range-2).*frame_interval-offset_x;
    y = F;
    [xi,yi] = polyxpoly(xlimit,[mean(ylimit) mean(ylimit)],x,y);
    angle = atand(kymograph.speed{1}{1}(1)/(diff(ylimit)/diff(xlimit)));
    text(xi,yi,sprintf('%.4fum/s',kymograph.speed{1}{1}(1)/3600),...
        'color','w','HorizontalAlignment','center','Rotation',angle,'VerticalAlignment','bottom') 

    % fitting line - iron
    F = polyval(kymograph.speed{2}{1},(frame_range-1).*frame_interval)-offset_y;
    plot((frame_range-3).*frame_interval-offset_x,F,'LineWidth',2,'color',[color_sig(2,:) 0.7]) % ros
    % annotate the measured speed - iron
    x = (frame_range-3).*frame_interval-offset_x;
    y = F;
    [xi,yi] = polyxpoly(xlimit,[mean(ylimit) mean(ylimit)],x,y);
    angle = atand(kymograph.speed{1}{1}(1)/(diff(ylimit)/diff(xlimit)));
    text(xi,yi,sprintf('%.4fum/s',kymograph.speed{2}{1}(1)/3600),...
        'color','w','HorizontalAlignment','center','Rotation',angle,'VerticalAlignment','bottom') 

    % set axis range and labels
    set(gca,'Xlim',xlimit,'YLim',ylimit,'YTickLabel',0:0.5:2,...
        'fontsize',14,'tickdir','out','XColor','k','YColor','k',...
        'LineWidth',1,'PlotBoxAspectRatio',[14*(201+12)-12 3180 1])
    xlabel('Time (hr)')
    ylabel('Distance (mm)')

    hold off

    if i==1
        exportgraphics(gcf,"..\fig\kymograph.pdf")
    else
        exportgraphics(gcf,"..\fig\kymograph.pdf",'Append',true)
    end

    close all
end
