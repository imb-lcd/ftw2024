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

load("result_h2o2.mat");
data = tbl_cell;

data2 = data(:,[1:7,11:13]);
data2.Properties.VariableNames{8} = 'slope';
data2.Properties.VariableNames{9} = 'slope_strt_frame';
data2.Properties.VariableNames{10} = 'slope_stop_frame';
data2.h2o2 = zeros(height(data2),1);
data2.light_label = repelem("before",height(data2),1);
data2 = movevars(data2,'light_label','Before','isDead');
data2.Properties.VariableNames{6} = 'light';

before = load("before.mat");
after = load("after.mat");

tbl_cell = before.tbl_cell(:,1:6);
tbl_cell.light_label = repelem("before",height(before.tbl_cell),1);
tbl_cell.isDead = zeros(height(before.tbl_cell),1);
tbl_cell.slope = before.tbl_cell.slope;
tbl_cell.slope_strt_frame = ones(height(before.tbl_cell),1);
tbl_cell.slope_stop_frame = 2.*ones(height(before.tbl_cell),1);

tbl_cell = [tbl_cell;after.tbl_cell];

%%
tbl_cell.slope(tbl_cell.slope<0) = 0;
data1 = tbl_cell;
data1(data1.light_label=="before",:) = [];

data = [data1;data2];

clearvars -except data

%%
[G,TID] = findgroups(data(:,[5 6]));
text_ticks = [];

close all
figure
for i = 1:height(TID)
    index = find(G==i);
    if TID.light(i)==0
        rng(1)
        index = sort(index(randsample(1:length(index),40)));
    end

    tmp = data.slope(index);

    hold on
    s = swarmchart(i.*ones(size(tmp)),tmp,'k','.','XJitterWidth',0.65,'XJitter','randn');
    hold off
    row = dataTipTextRow('scene',data.well(index));
    s.DataTipTemplate.DataTipRows(end+1) = row;
    row = dataTipTextRow('cell',data.index(index));
    s.DataTipTemplate.DataTipRows(end+1) = row;

    if TID.light(i)==0
        s.MarkerFaceColor = 'k';
    end
    text_ticks = [text_ticks;data.light_label(index(1))];

    text(i,0.015,"n="+height(tmp),'HorizontalAlignment','center')
end

text_ticks = strrep(text_ticks,"mW*","*");
text_ticks = strrep(text_ticks,"0s","0");

xticks(1:8)
xticklabels(text_ticks)
ylabel("ROS steady state (slope)")
xlabel("Light energy (mW*sec)")
set(gca,'layer','top','linewidth',1,'tickdir','out','fontsize',16,'yscale','log')

set(gca,'layer','top','linewidth',1,'tickdir','out','fontsize',16,'yscale','log')
axis padded
ylim([0.01 250])
y_erastin = ylim;
y_erastin = y_erastin(end);
hold on
plot([1 4]+[-0.35 +0.35],[1 1].*y_erastin,'k-')
plot([5 8]+[-0.35 +0.35],[1 1].*y_erastin,'k-')
hold off
text(mean([1 4]),1.*y_erastin,"Erastin (0 µM)",'fontsize',16,...
    "HorizontalAlignment",'center','VerticalAlignment','bottom')
text(mean([5 8]),1.*y_erastin,"Erastin (10 µM)",'fontsize',16,...
    "HorizontalAlignment",'center','VerticalAlignment','bottom')

yticks(10.^(-1:2))
yticklabels(string("10^{"+(-1:2)+"}"))

% exportgraphics(gcf,"ros_steady_state_light.pdf",'ContentType','vector')
tbl_source = table(data.erastin,data.light,data.slope,...
    'VariableNames',["Erastin (µM)","Photoinduction intensity","ROS steady state (AU)"]);
tbl_source.("Photoinduction intensity") = discretize(tbl_source.("Photoinduction intensity"),[0 100 1000 5000 10000])-1;
% writetable(tbl_source,"../../../ftw_paper_figures_v2/source_data/figS16.xlsx","Sheet","ROS_steady_state")

tblG = groupsummary(tbl_source,{'Erastin (µM)','Photoinduction intensity'},"mean","ROS steady state (AU)")