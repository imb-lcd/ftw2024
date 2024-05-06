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

%% load result
load("..\data\ros\quantification_steadystate.mat")
tbl = tbl_cell(~(isnan(tbl_cell.ss_before)|isnan(tbl_cell.ss_after)),:);
G = groupsummary(tbl,'era','median',{'ss_after'});

% sample 80 results for each erastin levels
s = RandStream('mlfg6331_64','Seed',84); 
isSampled = false(height(tbl),1);
for i = 1:height(G)
    index = find(tbl.era==G.era(i));
    y = randsample(s,1:length(index),80);
    y = sort(y);
    index = index(y);
    isSampled(index) = 1;
end
tbl.isSampled = isSampled;
tbl = tbl(tbl.isSampled==1,:);

%% visualize result
close all

figure('Position',[680   558   960   420])
t = tiledlayout(1,2,'TileSpacing','none');

% before photoinduction
ax1 = nexttile;
swarmchart(tbl.x,(tbl.ss_before),20,'k','.','XJitterWidth',0.65,'XJitter','randn') % [59,73,146]./255
xlim([0.5 8.5])
ylim(([1e-2 5e2/2]))
set(ax1,'fontsize',16,'xtick',1:8,'XTickLabel',string(unique(tbl.era)),...
    'XTickLabelRotation',0,'YScale','log','LineWidth',1,'TickDir','both')
title("{\it Before photoinduction}",'fontsize',16)
box on

% after photoinduction
ax2 = nexttile;
swarmchart(tbl.x,(tbl.ss_after),20,'k','.','XJitterWidth',0.65,'XJitter','randn') % [255,201,0]./255
xlim([0.5 8.5])
ylim(([1e-2 5e2/2]))
set(ax2,'fontsize',16,'xtick',1:8,'XTickLabel',string(unique(tbl.era)),...
    'XTickLabelRotation',0,'YScale','log','LineWidth',1,'YTickLabel',"",'TickDir','both')
box on
title("{\it After photoinduction}",'fontsize',16)

ylabel(t, 'ROS steady state (A.U.)','fontsize',16)
xlabel(t, 'Erastin (µM)','fontsize',16)

tbl1 = table(tbl.x,tbl.ss_before,repelem("before photoinduction",length(tbl.x),1),'VariableNames',["Erastin (uM)","ROS steady state (AU)","condition"]);
tbl2 = table(tbl.x,tbl.ss_after,repelem("after photoinduction",length(tbl.x),1),'VariableNames',["Erastin (uM)","ROS steady state (AU)","condition"]);
tbl3 = [tbl1;tbl2];
tmp = [0 0.15 0.31 0.63 1.25 2.5 5 10];
tbl3.("Erastin (uM)") = tmp(tbl3.("Erastin (uM)"))';
% writetable(tbl3,"../../source_data/fig4.xlsx","Sheet","c")

% exportgraphics(gcf,"..\fig\steadystate_ros.pdf","ContentType","vector")
