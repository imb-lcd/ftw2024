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
well = [1:5;10:-1:6;11:15;20:-1:16;21:25;30:-1:26;43:47;52:-1:48];
inhibitor = [repelem("zVAD",2,5);repelem("Fer-1",2,5);repelem("Nec-1",4,5)];
conc = [repmat([10 5 2.5 10 5],2,1);repmat([20 10 5 20 10],4,1);repmat([2.5 1.25 0.6 2.5 1.25],2,1)];
timing = [repelem("Before",8,3),repelem("After",8,2)];

tbl = table(well(:),inhibitor(:),conc(:),timing(:),'VariableNames',["well" "inhibitor" "conc" "timing"]);

well = [36:-1:31;37:42;58:-1:53];
inhibitor = [repmat(["zVAD","Fer-1","Nec-1","Control","Control","Control"],2,1);
    ["Fer-1",repelem("Control",1,5)]];
conc = [[2.5 5 5 0 0 0];[2.5 5 5 0 0 0];[10,zeros(1,5)]];
timing = [["After" "After" "After" "No" "No" "No"];...
    ["After" "After" "After" "No" "No" "No"];["After" "No" "No" "No" "No" "No"]];

tbl2 = table(well(:),inhibitor(:),conc(:),timing(:),'VariableNames',["well" "inhibitor" "conc" "timing"]);

tbl = [tbl;tbl2];
tbl(tbl.well==58,:) = [];
tbl = tbl(:,[1 2 4 3]);
tbl = sortrows(tbl,'well');
clearvars -except tbl

[G,TID] = findgroups(tbl(:,2:4));
TID.well = arrayfun(@(i)find(G==i),1:height(TID),'UniformOutput',0)';
TID = TID([1 5:7 2:4 13:18 8:12 22:24 19:21],:);

order = vertcat(TID.well{:});

%%
well = [56 35 25 7];
index_angle = [19 3 19 34];

cond = ["Ctrl" "Fer-1" "Nec-1" "zVAD"];
fname = "s"+well;
frame_interval = 1;
scale = 1.26;
frame_toshow = 4:11;
xlimit = ([0 frame_toshow(end)-frame_toshow(1)]+[-0.5 0.5]).*frame_interval; 
ylimit = [0 1800];
color_signal = [255 255 255;254 212 57]./255; % white/yellow

offset = min(frame_toshow)-1;
% pbaRatio = [length(frame_toshow)*(201+12)-12 ceil(ylimit(2)/scale) 1];
pbaRatio = [1618 1429 1];

close all
for i = 1:length(well)

    % load setting for setting and kymograph
    load("..\data\setting_"+fname(i)+".mat");
    load("..\data\kymograph_cy5_"+fname(i)+".mat");

    % get kymograph
%     tmp = kymograph{index_angle(i),:};

    % retrieve kymograph
    maxR = kymograph{index_angle(i),:};
    frame_range = 1:size(maxR,1);
    
    % calculate the offset of x- and y-axis (spatial and temporal axis)
    offset_y = 0;%(size(maxR,2)-ceil(ylimit(2)/scale)).*scale;
    offset_x = (min(frame_toshow)-1).*frame_interval;

    maxR = maxR(frame_toshow,1:ceil(ylimit(2)/scale));

    % kymograph
    len_px = max(size(maxR));
    B = imresize(maxR,[len_px len_px]);
    MotionBlur = imadjust(uint16(imfilter(B,fspecial('average',11),'replicate')));

    figure
    hold on
    h = imagesc([0-0.5 size(maxR,1)-1+0.5].*frame_interval,...
        [size(maxR,2)-1 0].*scale,MotionBlur');
    hold off
    colormap gray
    uistack(h,'bottom')
%     xlim(xlimit)
%     ylim(ylimit)
%     
% 
%     yticks(0:500:1800)
%     yticklabels(0:0.5:1.8)
    text(0,1600,cond(i)+",s"+well(i),'color','w')
%     title(cond(i))
%     title(kymograph{5,7}+"^\circ","Color",'k')
    hold off
%     axis square
    
    if ~isempty(kymograph{index_angle(i),5})
        p = kymograph{index_angle(i),5}{1};
%         slope = p(1)/ (diff(ylimit)/diff(xlimit));
%         xrange = [frame_strt,frame_stop]-1;
        F = polyval(p,(frame_range-1).*frame_interval)-offset_y;
        hold on
        plot((frame_range-1).*frame_interval-offset_x,F,'LineWidth',2,'color',[color_signal(1,:) 0.7])
        hold off

        x = (frame_range-1).*frame_interval-offset_x;
        y = F;
        [xi,yi] = polyxpoly(xlimit,[mean(ylimit) mean(ylimit)],x,y);
        slope = abs(p(1))/(diff(ylimit)/diff(xlimit))*(pbaRatio(2)/pbaRatio(1));
        alpha = atand(slope);
        text(xi-1,yi,round(abs(p(1))/60,2)+"µm/min",...
        'color','w','HorizontalAlignment','center','Rotation',alpha,...
        'VerticalAlignment','bottom','FontSize',16)

%         text(xrange(2)-offset,F(2),sprintf('%.4fum/s',abs(p(1))/3600),'color','w',...
%             'HorizontalAlignment','right','FontWeight','bold')
    end
    
    hold on
    plot(5.5-offset,800,'wv','MarkerFaceColor','w')
    % add top and left edge
    plot(xlimit,[ylimit(2) ylimit(2)],'k','LineWidth',1)
    plot([xlimit(2) xlimit(2)],ylimit,'k','LineWidth',1)
    hold off

    % set axis range and labels
    set(gca,'Xlim',xlimit,'YLim',ylimit,'YTickLabel',0:0.5:1.8,'layer','top',...
        'fontsize',16,'tickdir','out','XColor','k','YColor','k',...
        'LineWidth',1,'PlotBoxAspectRatio',pbaRatio)
    xlabel('Time (hr)')
    ylabel('Distance (mm)')

    % exportgraphics(gcf,"..\fig\kymograph_"+cond(i)+".pdf",'ContentType','vector')
end

%%
fname = "s"+(1:57);
% cd(old)
for well = order'%1:length(fname)
    if exist("..\data\setting_"+fname(well)+".mat")
        load("..\data\setting_"+fname(well)+".mat")
    else
        continue
    end

    setting = load("..\data\setting_"+fname(well)+".mat");
    cy5 = load("..\data\kymograph_cy5_"+fname(well)+".mat");
    %     ros = load("..\data\kymograph_ros_"+fname(well)+".mat");
    frame_interval = 1;
    scale = 1.26;
    offset = 0;

    figure('WindowState','maximized')
    for i = 1:size(cy5.kymograph,1) % number of angles

        maxR = cy5.kymograph{i,1};
        xlimit = [0-0.5 size(maxR,1)-1+0.5].*frame_interval;
        ylimit = [0 size(maxR,2)-1].*scale;

        % kymograph
        len_px = max(size(maxR));
        B = imresize(maxR,[len_px len_px]);
        MotionBlur = imadjust(uint16(imfilter(B,fspecial('average',11),'replicate')));

        nexttile
        hold on
        h = imagesc([0-0.5 size(maxR,1)-1+0.5].*frame_interval,...
            [size(maxR,2)-1 0].*scale,MotionBlur');
        hold off
        colormap gray
        uistack(h,'bottom')
        xlim(xlimit)
        ylim(ylimit)
        set(gca,'tickdir','out','XColor','k','YColor','k')
        xlabel('Time (hour)')
        ylabel('Distance (mm)')
        yticks([0 1000 2000])
        yticklabels(["0" "1" "2"])
        title(cy5.kymograph{i,7}+"^\circ","Color",'k')
        hold off
        axis square

        frame_strt = setting.speed.cy5.frame_strt(i);
        frame_stop = setting.speed.cy5.frame_stop(i);

        if ~isempty(cy5.kymograph{i,5})

            p = cy5.kymograph{i,5}{1};
            slope = p(1)/ (ylimit(2)./xlimit(2));
            xrange = [frame_strt,frame_stop]-1;
            F = polyval(p,xrange);
            hold on
            plot(xrange-offset,F+slope*0,...
                'LineWidth',2,'color',[0 1 1 0.7])
            hold off
            text(xrange(2),F(2),sprintf('%.4fum/s',abs(p(1))/3600),'color','w',...
                'HorizontalAlignment','left','FontWeight','bold')

        end

    end

    sgtitle(tbl.inhibitor(well)+", "+tbl.conc(well)+"uM, "+...
        tbl.timing(well)+" ("+fname(well)+")")
    exportgraphics(gcf,'myplots.pdf','Append',true);
    close all
end

