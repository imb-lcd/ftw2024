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

scene = 1:12;
conc = repelem([0.25 0.06 0.03 0],3);
frame_strt = [6 7 7 7 11 6 8 6 7 7 11 7];
frame_stop = [9 10 11 10 14 9 11 10 10 11 15 12];
width =  [1012.56, -1256.22, 1471.66, 214.94, -685.10, -592.29, -329.32, -1048.30,  621.61,  176.13, 374.75, 1070.44];
height = [-834.54,   122.63, -902.34, 819.55, -742.37, -787.25,  775.96,   172.42, -722.03, 1034.84, 944.74,  -37.49];
len = [1650.188,1580.828,1969.918,1054.156,1227.934,1231.175,1010.022,1324.048,1149.103,1319.997,1252.791,1348.774]; % um
tbl = table(scene',conc',frame_strt',frame_stop',width',height',len');
tbl.Properties.VariableNames = ["scene","FSEN","frame_strt","frame_stop",'width','height','dist'];
tbl.img = "FSEN_"+pad(string(round(tbl.FSEN*100)),2,'left','0')+"_s"+pad(string(tbl.scene),2,'left','0');
clearvars -except tbl

%% determine initiation
initX = nan(height(tbl),1);
initY = nan(height(tbl),1);
i = 1; initX(i) = 302; initY(i)= 706;
i = 2; initX(i) = 1694; initY(i)= 1136;
i = 3; initX(i) = 253; initY(i)= 976;
i = 4; initX(i) = 622; initY(i)= 1570;
i = 5; initX(i) = 1620; initY(i)= 609;
i = 6; initX(i) = 2571; initY(i)= 442;
i = 7; initX(i) = 1375; initY(i)= 1213;
i = 8; initX(i) = 1437; initY(i)= 1905;
i = 9; initX(i) = 1030; initY(i)= 1579;
i =10; initX(i) = 214; initY(i)= 2072;
i =11; initX(i) = 475; initY(i)= 2840;
i =12; initX(i) = 702; initY(i)= 722;

tbl.initX = initX;
tbl.initY = initY;

%% make kymograph
close all
% tiledlayout(3,4)
% for i = [10 7 4 1 11 8 5 2 12 9 6 3]
yStrt = nan(height(tbl),1);
yStrt(10) = 133.581;
yStrt(11) = 221.795;
yStrt(12) = 0;
yStrt(1) = 459.973;
yStrt(2) = 168.867;
yStrt(3) = 192.811;
figure('position',[680   458   940   420])
% tiledlayout(2,3)
for i = [10 1]% [10 11 12 1 2 3]
    % i=12
    load("kymo"+i+".mat")
    speed = [];

    for j = 1%1:length(list)
        % fname = fullfile(list(j).folder,list(j).name);
        % load(fname)

        % get speed
        speed = [speed;kymograph.speed{j}{1}(1)/60];

        % retrieve kymograph
        maxR = kymograph.maxR{j};
        frame_range = 1:size(maxR,1);

        % set parameters for showing kymograph
        % well = extractBetween(list(j).name,"_s",".mat");
        % well = str2double(string(well));
        pxSize = scale;
        frame_interval = 1;
        frame_toshow = 1:5; % frame range to show

        xlimit = ([0 frame_toshow(end)-frame_toshow(1)]+[-0.5 0.5]).*frame_interval;
        ylimit = [0 (size(maxR,2)-1)*pxSize];
        ylimit = [0 1000];
        %         ylimit = [0 6000];
        %         pbaRatio = [length(frame_toshow)*(201+12)-12 ceil(ylimit(2)/pxSize) 1];

        % calculate the offset of x- and y-axis (spatial and temporal axis)
        offset_y = 0;%(size(maxR,2)-ceil(ylimit(2)/scale)).*scale;
        offset_x = 1;%(min(frame_toshow)-1).*frame_interval;

        maxR = maxR(frame_toshow,(1:ceil(ylimit(2)/pxSize))+round(yStrt(i)/pxSize));

        nexttile
        hold on
        plotKymo(maxR,frame_interval,pxSize)
        clim([0 5e4])
        % clim([5e3 3e4])
        % frame1_treat = 10;%kymograph.front{j}{1}.frame(end)+1;

        % add line and speed
        for k = 1
            x = (kymograph.front{j}{k}.frame-1).*frame_interval;
            % if k==1
            %     x = ((min(frame_range):(frame1_treat-1))-1).*frame_interval;
            % else
            %     x = (((frame1_treat+1):max(frame_range))-1).*frame_interval;
            % end
            % data_t = repelem(kymograph.front{1}{1}.time,cellfun('length',kymograph.front{1}{1}.data_dist));
            % data_x = [kymograph.front{1}{1}.data_dist{:}]';
            % plot(data_t-1,data_x,'o')


            %%% fitting line - cy5
            F = polyval(kymograph.speed{j}{k},x)-offset_y-yStrt(i);
            % plot(x-offset_x,F,'LineWidth',2,'color',[1 1 1 0.7]) % cy5
            x = x-offset_x;
            [xi1,~] = polyxpoly(x,F,xlimit,[200 200]);
            [xi2,~] = polyxpoly(x,F,xlimit,[800 800]);
            plot([xi1,xi2],[200,800],'LineWidth',2,'color',[1 1 1 0.7]) % cy5

            %%% annotate the measured speed - cy5
            x = x-offset_x;
            y = F;
            % [xi,yi] = polyxpoly(xlimit,[mean(y(y>0&y<ylimit(2))) mean(y(y>0&y<ylimit(2)))],x,y);
            [xi,yi] = polyxpoly(x,F,xlimit,[500 500]);

            slope = kymograph.speed{j}{k}(1)/(diff(ylimit)/diff(xlimit));
            alpha = atand(slope);

            text(xi+0.8,yi,round(kymograph.speed{j}{k}(1)/60,2)+" µm/min",...
                'color','w','HorizontalAlignment','center','Rotation',alpha,...
                'VerticalAlignment','bottom','FontSize',16)
        end

        % set axis range and labels
        set(gca,'Xlim',xlimit,'YLim',ylimit,'YTickLabel',0:floor(ylimit(2)/1000),'YTick',0:1000:floor(ylimit(2)/1000)*1000,...
            'fontsize',16,'tickdir','out','XColor','k','YColor','k',...
            'LineWidth',1,'Layer','top','PlotBoxAspectRatio',[1 1 1])

        % add top and left edge
        plot(xlimit,[ylimit(2) ylimit(2)],'k','LineWidth',1)
        plot([xlimit(2) xlimit(2)],ylimit,'k','LineWidth',1)

        xlabel('Time (hr)')
        ylabel('Distance (mm)')
        title("[FSEN]="+tbl.FSEN(i)+"µM, s"+extractAfter(tbl.img(i),"_s"))

        hold off

        %         if j==1
        %             exportgraphics(gcf,"..\fig\kymograph_"+drug+"_24.pdf")
        %         else
        %             exportgraphics(gcf,"..\fig\kymograph_"+drug+"_24.pdf",'Append',true)
        %         end
        % close all
    end
end

% exportgraphics(gcf,"..\fig\kymographs.pdf")
% disp([drug+": ";...
%     mean(speed(:,1))+"±"+std(speed(:,1))+"µm/min (before)";...
%     mean(speed(:,2))+"±"+std(speed(:,2))+"µm/min  (after)"])