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

%% load tracking quantification result of cy5 and sytox
load("..\tracking\tracking_file\mat\sytox_tracking_rosMean_d7_Analyze4.mat"); % sytox
sytox = normalize(measurements_CFP.filledSingleCellTraces,2,'range');
t_sytox = repmat(1:22,20,1);

load("..\tracking\tracking_file\mat\sytox_tracking_cy5Mean_d7_Analyze4.mat");
cy5 = normalize(measurements_CFP.filledSingleCellTraces,2,'range');
t_cy5 = repmat(1:22,20,1);

% calculate mean and standard deviation of cy5 and sytox
msytox = mean(sytox,1);
ssytox = std(sytox,[],1);
shade_sytox = polyshape([1:22,fliplr(1:22)],[msytox-ssytox,fliplr(msytox+ssytox)]);
mcy5 = mean(cy5,1);
scy5 = std(cy5,[],1);
shade_cy5 = polyshape([1:22,fliplr(1:22)],[mcy5-scy5,fliplr(mcy5+scy5)]);

color_line = lines(7);
color_line = color_line([7 5],:); % [cy5;sytox]
color_line = lines(2);

%% identify the frame having the maximal change
[~,Icy5] = arrayfun(@(i)max(diff(cy5(i,:))),1:20);
[~,Isytox] = arrayfun(@(i)max(diff(sytox(i,:))),1:20);
tbl = array2table([Icy5',Isytox',(Isytox-Icy5)'],"VariableNames",["I_cy5" "I_sytox" "Delta_Int"]);

%% align the cy5 and sytox based on the frame having the maximal change
% offset relative to the frame 10
offset = 10-tbl.I_cy5;
f_cy5_shifted = t_cy5 + repmat(offset,1,22);

% offset relative to the frame 11
offset = 11-tbl.I_sytox;
f_sytox_shifted = t_sytox + repmat(offset,1,22);


%% Calculate the statistic for population (mean, std, median, Q1, Q3)
[B,BG,BC] = groupsummary(cy5(:),f_cy5_shifted(:),{'mean' 'std' 'median' @(x)prctile(x,25) @(x)prctile(x,75)});
tbl_cy5 = [table(BG,BC,'VariableNames',["time" "count"]),array2table(B,'VariableNames',["mean" "std" "median" "Q1" "Q3"])];
[B,BG,BC] = groupsummary(sytox(:),f_sytox_shifted(:),{'mean' 'std' 'median' @(x)prctile(x,25) @(x)prctile(x,75)});
tbl_sytox = [table(BG,BC,'VariableNames',["time" "count"]),array2table(B,'VariableNames',["mean" "std" "median" "Q1" "Q3"])];

%% plot aligned traces

% shade area defined by q1 and q3
time = (1:22)-1-5;
shade_cy5 = polyshape([time,fliplr(time)],[tbl_cy5.Q1(3:24)',fliplr(tbl_cy5.Q3(3:24)')]);
shade_sytox = polyshape([time,fliplr(time)],[tbl_sytox.Q1(4:25)',fliplr(tbl_sytox.Q3(4:25)')]);

close all
figure
hold on
plot(shade_cy5,'FaceColor',color_line(1,:),'EdgeColor','none','FaceAlpha',0.3)
plot(shade_sytox,'FaceColor',color_line(2,:),'EdgeColor','none','FaceAlpha',0.3)

p1 = plot(time,tbl_cy5.median(3:24),'linewidth',2,'Color',color_line(1,:));
p2 = plot(time,tbl_sytox.median(4:25),'linewidth',2,'Color',color_line(2,:));
hold off

ylim([-0.05 1.05])
xlim([0 21-10])

xlabel("Time (hr)")
ylabel("Normalized intensity")
set(gca,'fontsize',16,'Layer','top','LineWidth',1,'TickDir','out')
legend([p1 p2],["cy5" "sytox"],'Location','northwest','Box','off')

% exportgraphics(gcf,"..\fig\dynamics.pdf","ContentType","vector")
% tbl_source = table([time,time]',[tbl_cy5.median(3:24);tbl_sytox.median(4:25)]);
% tbl_source.Properties.VariableNames = ["Time (h)","Normalized Intensity"];
% tbl_source(tbl_source.("Time (h)")<0,:) = [];
% tbl_source(tbl_source.("Time (h)")>11,:) = [];
% writetable(tbl_source,"../../../ftw_paper_figures_v2/source_data/figS1.xlsx","Sheet","b")
