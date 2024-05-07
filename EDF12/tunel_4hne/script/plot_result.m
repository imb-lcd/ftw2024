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


a = load("data_4hne.mat");
b = load("data_tunel.mat");

color_signal = lines(2);

figure
hold on
y = vertcat(a.data{:,2});
y = y(:,1);
s1 = swarmchart((1-0.2).*ones(size(y)),y,'XJitterWidth',0.2,'XJitter','randn',...
    'MarkerEdgeColor',color_signal(1,:));

y = vertcat(b.data{:,2});
y = y(:,1);
s2 = swarmchart((1+0.2).*ones(size(y)),y,'XJitterWidth',0.2,'XJitter','randn', ...
    'MarkerEdgeColor',color_signal(2,:));

y = vertcat(a.data{:,2});
y = y(:,2);
swarmchart((2-0.2).*ones(size(y)),y,'XJitterWidth',0.2,'XJitter','randn', ...
    'MarkerEdgeColor',color_signal(1,:))

y = vertcat(b.data{:,2});
y = y(:,2);
swarmchart((2+0.2).*ones(size(y)),y,'XJitterWidth',0.2,'XJitter','randn', ...
    'MarkerEdgeColor',color_signal(2,:))
hold off

xticks(1:2)
xticklabels(["central" "lateral"])
ylabel("Normalized intensity (median)")
set(gca,'FontSize',16,'LineWidth',1,'layer','top','TickDir','out')

legend([s1,s2],["4HNE","TUNEL"],'Location','best')

%%
close all
figure
hold on
y = vertcat(a.data{:,1});
y = y(1:3,1);
s1 = swarmchart((1-0.15).*ones(size(y)),y,'XJitterWidth',0.2,'XJitter','randn',...
    'MarkerEdgeColor',color_signal(1,:));

y = vertcat(b.data{:,1});
y = y(2:4,1);
s2 = swarmchart((1+0.15).*ones(size(y)),y,'XJitterWidth',0.2,'XJitter','randn', ...
    'MarkerEdgeColor',color_signal(2,:));

y = vertcat(a.data{:,1});
y = 100-y(1:3,1);
swarmchart((2-0.15).*ones(size(y)),y,'XJitterWidth',0.2,'XJitter','randn', ...
    'MarkerEdgeColor',color_signal(1,:))

y = vertcat(b.data{:,1});
y = 100-y(2:4,1);
swarmchart((2+0.15).*ones(size(y)),y,'XJitterWidth',0.2,'XJitter','randn', ...
    'MarkerEdgeColor',color_signal(2,:))
hold off

xticks(1:2)
xticklabels(["central" "lateral"])
ylabel("Normalized intensity (area)")
set(gca,'FontSize',16,'LineWidth',1,'layer','top','TickDir','out')
legend([s1,s2],["4HNE","TUNEL"],'Location','best')

% axis square
axis padded

% exportgraphics(gcf,"../fig/statistics.pdf","ContentType","vector")
tbl_source1 = table(repelem(["4HNE","TUNEL"]',3),repelem("Central",6,1),...
    [a.data{1:3,1}, b.data{1:3,1}]');
tbl_source2 = table(repelem(["4HNE","TUNEL"]',3),repelem("Lateral",6,1),...
    100-[a.data{1:3,1}, b.data{1:3,1}]');
tbl_source = [tbl_source1;tbl_source2]';
tbl_source.Properties.VariableNames = ["Signal","Position","Relative signal intensity"];
% writetable(tbl_source,"../../../../ftw_paper_figures_v2/source_data/figS19.xlsx","Sheet","c")