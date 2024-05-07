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

load("count_data_grp.mat")

color_grp = [0 0 0;1 0 0];

%%
close all
figure('Position',[680   458   344   356])
hold on
for i = 1:size(color_grp,1)
    s = swarmchart(grp(grp==i),total_count(grp==i),...
        'o','XJitter','density','XJitterWidth',0.2,...
        'MarkerFaceColor','w','MarkerEdgeColor',color_grp(i,:));
    row = dataTipTextRow('sample',strrep(samples(grp==i),'_','\_'));
    s.DataTipTemplate.DataTipRows(end+1) = row;

    errorbar(i+0.15,mean(total_count(grp==i)),...
    std(total_count(grp==i)),'o','LineWidth',1,...
    'MarkerFaceColor',color_grp(i,:),'Color',color_grp(i,:))
end

set(gca,'Layer','top','LineWidth',1,'FontSize',16,'TickDir','out','FontName','Arial')
xticks([1 2])
xticklabels(["Control" "UAMC-3203"])
ylabel("Fiber count")

axis padded
xlim
ylim
xlim([1 2]+[-1 1]*0.4)
ylim([30000 48000])

[p,tbl,stats] = kruskalwallis(total_count,grp,'off')