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
level = readtable(".\NOX isoform abundance in RPE.xlsx");
level.x = repelem((1:4)',3);
ref = mean(level.Cq(level.x==1));
level.y = log10(2.^(-1.*(level.Cq-ref)));
tblG = groupsummary(level,"x",{'mean' 'std'},'y');
tblG.grp = ["NOX"+(1:4)]';
tblG = movevars(tblG,"grp","After","x");

%%
close
figure

hold on
errorbar(1:4,tblG.mean_y,tblG.std_y,'o','color','k','LineWidth',1,'MarkerFaceColor','k')
hold off

ylabel("Abundance")
set(gca,'Layer','top','FontSize',16,'LineWidth',1,'TickDir','out', ...
    'XTick',1:4,'XTickLabel',"NOX"+(1:4),'xlim',[0.5 4.5], ...
    'yscale','linear','ylim',[-1.2 3.5])
yticklabels(["10^{-1}" "10^{0}" "10^{1}" "10^{2}" "10^{3}"])
% ax = gca;
% ax.Children = ax.Children([size(h,2)+1 setdiff(1:length(ax.Children),size(h,2)+1)]);
box off

hold on
swarmchart(level.x-0.2,level.y,30,[59, 73, 146]./255,'o','XJitter','rand','XJitterWidth',0.15)
hold off

% exportgraphics(gcf,"NOX_abundance.pdf")
tbl_source = table(level.x,level.y,'VariableNames',["Isoform","Relative mRNA level"]);
% writetable(tbl_source,"../../ftw_paper_figures_v2/source_data/figS10.xlsx","Sheet","mRNA_level")