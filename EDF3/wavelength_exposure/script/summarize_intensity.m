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

%% intensity, plate map
wells = reshape(1:60,12,[])';
wells(2,:) = fliplr(wells(2,:));
wells(4,:) = fliplr(wells(4,:));
wells = wells(:);

intensity = repmat(repelem([1 1/2 1/4 1/8].*100,3),5,1);
intensity = intensity(:);

duration = repmat(10.*[1/16 1/8 1/4 1/2 1]',1,12);
duration = duration(:);

platemap = table(duration,intensity,wells);
platemap = sortrows(platemap,["duration","intensity"]);
[G,ID] = findgroups(platemap(:,[1 2]));

%% intensity, speed
list = dir("..\data\kymograph_Intensity10X_s*.mat");
tbl = [];
for i = 1:length(list)
    well = extractBetween(list(i).name,"_s",".mat");
    well = str2double(well{1});
    result = nan(8,2);

    load(fullfile(list(i).folder,list(i).name))
    for j = 1:height(kymograph)
        if ~isempty(kymograph.speed{j})
            speed = kymograph.speed{j}{1}(1)/3600;

            if diff(kymograph.frame_range{j})>=3
                result(kymograph.index_angle(j),kymograph.index_img(j)) = speed;
            end
        end
    end
    result = [result,(0:45:359)'];
    result(sum(isnan(result),2)>0,:) = [];
    result = [result,abs(result(:,1)-result(:,2))];
    result = [well.*ones(size(result,1),1),result];
    result = array2table(result,'VariableNames',["well" "cy5" "ros" "angle" "diff"]);
    result(result.diff>0.01,:) = [];

    tbl = [tbl;result];
end
speed = tbl;
clearvars -except platemap G ID speed

platemap.speed = arrayfun(@(x)[speed.cy5(speed.well==x) speed.angle(speed.well==x)],...
    platemap.wells,'UniformOutput',0);

clearvars -except platemap G ID

%% intensity, ros
list = dir("..\data\Intensity20X_s*.csv");
tbl = [];
for i = 1:length(list)
    well = extractBetween(list(i).name,"_s",".csv");
    well = str2double(well{1});
    
    result = readtable(fullfile(list(i).folder,list(i).name));
    tbl(:,well) = result.Mean1;
end
% tbl(4,tbl(4,:) == 0) = nan;
tbl(4,:) = [];

for i = 1:height(platemap)
    platemap.ros{i} = tbl(:,platemap.wells(i))';
end

%% ros, intensity
tmp = platemap(platemap.intensity==100,:);
duration = 10.*[1/16 1/8 1/4 1/2 1];
tmp.x = repelem((1:5)',3);
frame_stop = 7;
frame_strt = 2;
frame_base = 3;
color_duration = flipud(turbo(6));
color_duration(1,:) = [];

x = [];
y = [];
for i = 1:height(tmp)
    y = [y;tmp.ros{i}(frame_strt:frame_stop)];
    x = [x;tmp.duration(i)];
end
y = y-repmat(y(:,frame_base-frame_strt+1),1,size(y,2));
x(8) = [];
y(8,:) = [];

tbl_source = array2table([repmat(x,6,1),repelem((0:15:75)',14,1),y(:)]);
tbl_source.Properties.VariableNames = ["Exposure (sec)","Time (min)","ROS (AU)"];
% writetable(tbl_source,"figS3.xlsx","Sheet","edf3i")

% summarize data based on wavelength
summary = cell(length(duration),3); % c1: mean, c2: std, c3: shade
for i = 1:length(duration)
    summary{i,1} = mean(y(x==duration(i),:));
    summary{i,2} = std(y(x==duration(i),:));
    summary{i,3} = polyshape([frame_strt:frame_stop,fliplr(frame_strt:frame_stop)],[summary{i,1}-summary{i,2},fliplr(summary{i,1}+summary{i,2})]);
end

close all
figure
hold on
arrayfun(@(i)plot(summary{i,3},'FaceColor',color_duration(i,:),'EdgeColor','none'),1:length(duration));
p = arrayfun(@(i)plot(frame_strt:frame_stop,summary{i,1},'color',color_duration(i,:),'linewidth',2),1:length(duration),'UniformOutput',0);
plot(3.5,-2,'k^','MarkerFaceColor','k')
hold off
ylim([-5 85])
xticks([frame_strt:frame_stop])
xticklabels(([frame_strt:frame_stop]-frame_strt).*15)
xlim([frame_strt-0.5 frame_stop+.5])
xlabel('Time (min)')
ylabel("Mean ROS")
set(gca,'FontSize',16,'LineWidth',1,'TickDir','out')
% xline(1.5,'--','color',[.7 .7 .7])

lgd = legend(fliplr([p{:}]),string(fliplr(duration)),'Location','northwest');
title(lgd,'Duration') 

% exportgraphics(gcf,'..\fig\intensity_ROS.pdf','ContentType','vector')

meanRos = horzcat(summary{:,1})';
Duration = repelem(duration,6)';
Time = repmat(0:15:75,1,5)';

tbl_source = table(Duration,Time,meanRos);
tbl_source.Properties.VariableNames = ["Duration (sec)","Time (min)","Mean ROS (AU)"];
% writetable(tbl_source,"figS4.xlsx","Sheet","i")

%% speed, intensity
tmp = platemap(platemap.intensity==100,:);
duration = 10.*[1/16 1/8 1/4 1/2 1];
tmp.x = repelem((1:5)',3);

x = [];
y = [];
for i = 1:height(tmp)
    y = [y;tmp.speed{i}(:,1)];
    x = [x;ones(length(tmp.speed{i}(:,1)),1).*tmp.x(i)];
end
tbl = table(x,y,'VariableNames',["cond","speed"]);
% writetable(tbl,"..\data\intensity_speed_available.csv")
tblG = groupsummary(tbl,"cond",{'mean' 'std'},{'speed'});
tblG.duration = duration(tblG.cond)';
tblG = movevars(tblG,"duration","After","cond");

figure
s = swarmchart(x-0.25,y.*60,24,[59, 73, 146]/255,'XJitterWidth',0.36);
xlim([0.5 5.5])
ylim([-0.3 8.3])
set(gca,'XTick',1:length(duration),'XTickLabel',string(duration),'TickDir','out','FontSize',16,'LineWidth',1);
ylabel("Speed (µm/min)")
xlabel('Duration (sec)')

[B,BG,BC] = groupsummary(y.*60,x,{'mean' 'std'});
hold on
errorbar(BG,B(:,1),B(:,2),B(:,2),'ko','LineWidth',1,'CapSize',9,'MarkerSize',6,'MarkerFaceColor','k')
hold off
% exportgraphics(gcf,'..\fig\intensity_speed.pdf','ContentType','vector')
tbl_source = table(x,y*60);
tbl_source.Properties.VariableNames = ["Exposure tume (sec)","Speed (µm/min)"];
tbl_source.("Exposure tume (sec)") = duration(tbl_source.("Exposure tume (sec)"))'
% writetable(tbl_source,"../../../ftw_paper_figures_v2/source_data/figS4.xlsx","Sheet","f")