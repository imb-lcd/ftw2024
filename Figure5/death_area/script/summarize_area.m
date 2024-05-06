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

load("summary.mat")

%% plot result
%%% white background
markerFaceColor1 = "w";
markerFaceColor2 = "w";
markerEdgeColor1 = "k";
markerEdgeColor2 = "r";
boxColor1 = "k";
boxColor2 = "r";
lineColor = "k";
bgColor = "w";

close all
for i = 1:height(pltTable)
    figure('Position',[680   558   320   420])
    hold on
    p1 = plot(pltTable.xCtrl{i},pltTable.yCtrl{i},...
        'o','MarkerFaceColor',markerFaceColor1,'MarkerEdgeColor',markerEdgeColor1);
    row = dataTipTextRow('label',strrep(pltTable.labCtrl{i},"_","\_"));
    p1.DataTipTemplate.DataTipRows(end+1) = row;

    p2 = plot(pltTable.xExp{i},pltTable.yExp{i},...
        'o','MarkerFaceColor',markerFaceColor2,'MarkerEdgeColor',markerEdgeColor2);
    row = dataTipTextRow('label',strrep(pltTable.labExp{i},"_","\_"));
    p2.DataTipTemplate.DataTipRows(end+1) = row;

    for j = 1:length(pltTable.yCtrl{i})
        p = plot([pltTable.xCtrl{i}(j) pltTable.xExp{i}(j)],...
            [pltTable.yCtrl{i}(j) pltTable.yExp{i}(j)],'-','Color',lineColor);
    end

    % mean and 1sd
    errorbar(0.85,pltTable.meanCtrl(i),pltTable.stdCtrl(i),'ko','MarkerFaceColor','auto','LineWidth',2)
    errorbar(2.15,pltTable.meanExp(i),pltTable.stdExp(i),'ro','MarkerFaceColor','auto','LineWidth',2)
    top1 = pltTable.meanCtrl(i)+pltTable.stdCtrl(i);
    top2 = pltTable.meanExp(i)+pltTable.stdExp(i);

    plot([0.85 0.85 2.15 2.15],[top1+0.02 0.48 0.48 top2+0.02],'Color',lineColor)
    plot([1.5 1.5],[0.48 0.49],'Color',lineColor)

    hold off
    set(gca,'Children',circshift(get(gca,'Children'),2))
    set(gca,'FontSize',16,'TickDir','out','Layer','top','LineWidth',1,...
        'XColor',lineColor,'YColor',lineColor,'Color',bgColor)
    xticks([1 2])
    xticklabels(["Control" pltTable.label(i)])
    xlim([0.5 2.5])
    ylabel("Death area/Limb area")
    ylim([-0.01 0.51])

    box off

    text(1.5,0.5,"p="+sprintf("%1.2g",pltTable.pVal(i)),'Color',lineColor,...
        'HorizontalAlignment','center','FontSize',14)
    set(gcf,'Color',bgColor)
    % copygraphics(gcf,'ContentType','image','BackgroundColor','current')
    % exportgraphics(gcf,pltTable.label(i)+".pdf",'ContentType','vector')

    % if i>1
    %     tbl_source_1 = table(pltTable.xCtrl{i},pltTable.yCtrl{i},...
    %         'VariableNames',["x","Death area/limb area"]);
    %     tbl_source_1.Condition = repmat("Control",height(tbl_source_1),1);
    %     tbl_source_2 = table(pltTable.xExp{i},pltTable.yExp{i},...
    %         'VariableNames',["x","Death area/limb area"]);
    %     tbl_source_2.Condition = repmat(pltTable.label(i),height(tbl_source_2),1);
    %     tbl_source = [tbl_source_1;tbl_source_2];
    % 
    %     writetable(tbl_source,"../../../ftw_paper_figures_v2/source_data/fig5.xlsx","Sheet","f_"+pltTable.label(i))
    % end
end
