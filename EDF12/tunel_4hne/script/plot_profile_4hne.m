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

%
tunel = load("4hne_4samples.mat");
ws = 55; center = [940,891,1062,918];
box{1} = [534, 2130, 2250, 1738];
box{2} = [564, 1950, 2394, 1738];
box{3} = [408, 2280, 2400, 1738];
box{4} = [618, 2328, 2400, 1738];
index_bd{1} = [1159 1444 2217 2459] - box{1}(1);
index_bd{2} = [1204 1522 2322 2532]-box{2}(1);
index_bd{3} = [1195 1449 2240 2402]-box{3}(1);
index_bd{4} = [1316 1549 2345 2513]-box{4}(1);


%%
close all
ws = 55;

data = cell(4,2);
color_data = lines(4);
source = [];

figure

for i = 1:3

    tmp = smoothdata(tunel.y{i},"movmean",ws);
    yy = tmp(index_bd{i}(1):index_bd{i}(end));
    yy = normalize(yy,'range');

    % [~,I] = max(yy);
    I = round(mean(index_bd{i}(2:3)))-index_bd{i}(1)+1;

    xx = tunel.x{i}(index_bd{i}(1):index_bd{i}(end));
    xx = xx-xx(I);
    hold on
    plot(xx,yy,'LineWidth',1)
    % plot(yy,'LineWidth',1)
    hold off
    source = [source;xx,yy,(i)*ones(size(xx))];

    idx_strt = find(xx>-366.45,1)-1;
    idx_stop = find(xx<360.92,1,'last');

    data{i,1} = sum(yy(idx_strt:idx_stop))/sum(yy)*100;
    data{i,2} = [median(yy(idx_strt:idx_stop)),median([yy(1:idx_strt-1);yy(idx_stop+1:end)])];
    text(0,0.5-i*0.1,string(sum(yy(idx_strt:idx_stop))/sum(yy)*100+"%"),'Color',color_data(i,:))

    xline(xx([idx_strt idx_stop]),'Color',color_data(i,:))


end
title("4HNE")
set(gca,'layer','top','FontSize',16,'LineWidth',1,'TickDir','out','LineWidth',1)
xlabel("Position (μm)")
ylabel("Normalized intensity")
axis padded

% ax = gca;
% legend([ax.Children(end),ax.Children(end-3),ax.Children(end-6)],["left" "center" "right"])

% exportgraphics(gcf,"../fig/crosssection_4hne.pdf","ContentType","vector")
tbl_source = table(source(:,1),source(:,2),source(:,3),...
    'VariableNames',["Position (μm)","Relative","Sample id"]);
% writetable(tbl_source,"../../../../ftw_paper_figures_v2/source_data/figS19.xlsx","Sheet","a")