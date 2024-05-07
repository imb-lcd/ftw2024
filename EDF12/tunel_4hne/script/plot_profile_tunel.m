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

tunel = load("tunel_4samples.mat");
ws = 55; center = [940,891,1062,918];
box{1} = [684, 2352, 2070, 1738];
box{2} = [306, 2202, 2082, 1738];
box{3} = [126, 1908, 2082, 1738];
box{4} = [216, 1884, 1998, 1738];
index_bd{1} = [500 872 1507 1683];
index_bd{2} = [982 1154 1780 2038]-box{2}(1);
index_bd{3} = [717 1046 1636 1844]-box{3}(1);
index_bd{4} = [756 1041 1738 1932]-box{4}(1);

%%
close all
ws = 55;

data = cell(4,2);
color_data = lines(4);
source = [];

figure

for i = 2:4    

    tmp = smoothdata(tunel.y{i},"movmean",ws);
    yy = tmp(index_bd{i}(1):index_bd{i}(end));
    yy = normalize(yy,'range');

    I = round(mean(index_bd{i}(2:3)))-index_bd{i}(1)+1;
    xx = tunel.x{i}(index_bd{i}(1):index_bd{i}(end));
    xx = xx-xx(I);
    hold on
    plot(xx,yy,'LineWidth',1)
    hold off
    source = [source;xx,yy,(i-1)*ones(size(xx))];

    idx_strt = find(xx>-288.18,1)-1;
    idx_stop = find(xx<288.18,1,'last');

    data{i,1} = sum(yy(idx_strt:idx_stop))/sum(yy)*100;
    data{i,2} = [median(yy(idx_strt:idx_stop)),median([yy(1:idx_strt-1);yy(idx_stop+1:end)])];
    text(0,0.5-i*0.1,string(sum(yy(idx_strt:idx_stop))/sum(yy)*100+"%"),'Color',color_data(i,:))

    xline(xx([idx_strt idx_stop]),'Color',color_data(i-1,:))
end
title("TUNEL")
set(gca,'layer','top','FontSize',16,'LineWidth',1,'TickDir','out')
xlabel("Position (μm)")
ylabel("Normalized intensity")
axis padded

% exportgraphics(gcf,"../fig/crosssection_tunel.pdf","ContentType","vector")
tbl_source = table(source(:,1),source(:,2),source(:,3),...
    'VariableNames',["Position (μm)","Relative","Sample id"]);
% writetable(tbl_source,"../../../../ftw_paper_figures_v2/source_data/figS19.xlsx","Sheet","b")