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

load("entropy_data_grp.mat")

B = groupsummary(data,grp_pooled,{'mean','std'});

%% pooled
close all

% histogram
color_grp = lines(2);
color_grp = [0 0 0;1 0 0];
source = [];
close all
for binSize = 0.1
    figure
    for i = 1:2
        hold on
        h = histogram(data(grp_pooled==i),'binwidth',binSize,'Normalization','probability',...
            'FaceColor',color_grp(i,:),...
            'EdgeColor',color_grp(i,:));
        hold off
        source = [source;h.BinEdges(1:end-1)'+h.BinWidth/2,h.Values'*100,i.*ones(length(h.Values),1)];
    end
    set(gca,'Layer','top','LineWidth',1,'TickDir','out','FontSize',16)
    % axis padded
    ylabel("Frequency (%)")
    xlabel("Entropy")
    xlim([-0.2368 4])
    legend(["Control" "UAMC-3203"],'Location','best')
end
ylim([0 0.1441])
% exportgraphics(gcf,'pooled_entropy.pdf','ContentType','vector')
% tbl_source = table(source(:,1),source(:,2),source(:,3),...
%     'VariableNames',["Entropy","Frequency ","Condition"]);
% tmp = ["Control" "UAMC-3203"];
% tbl_source.Condition = tmp(tbl_source.Condition)';
% writetable(tbl_source,"../../../ftw_paper_figures_v2/source_data/figS20.xlsx","Sheet","b")

[h,p] = kstest2(data(grp_pooled==1),data(grp_pooled==2))
[p,tbl,stat] = kruskalwallis(data,grp_pooled)