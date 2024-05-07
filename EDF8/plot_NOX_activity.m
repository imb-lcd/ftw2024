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
tbl1 = readmatrix(".\NOX activity-final data.xlsx","Sheet","Experiment 1");
act1 = tbl1(2:5,2:9);
act6 = tbl1(2:5,12:19);
protein = repmat(tbl1(7,2:9),4,1);
era = repmat(tbl1(1,2:9),4,1);
exp = ones(4,8);

tbl2 = readmatrix(".\NOX activity-final data.xlsx","Sheet","Experiment 2");
act1 = [act1;tbl2(2:4,2:9)];
act6 = [act6;tbl2(2:4,12:19)];
protein = [protein;repmat(tbl2(7,2:9),3,1)];
era = [era;repmat(tbl2(1,2:9),3,1)];
exp = [exp;2.*ones(3,8)];

tbl3 = readmatrix(".\NOX activity-final data.xlsx","Sheet","Experiment 3");
act1 = [act1;tbl3(2:3,2:9)];
act6 = [act6;tbl3(2:3,12:19)];
protein = [protein;repmat(tbl3(7,2:9),2,1)];
era = [era;repmat(tbl3(1,2:9),2,1)];
exp = [exp;3.*ones(2,8)];

tbl = table(exp(:),era(:),act1(:),act6(:),protein(:),'VariableNames',...
    ["Exp" "Erastin" "Time1" "Time6" "protein"]);

tbl.FC = tbl.Time6./tbl.Time1;
tbl.nTime6 = tbl.Time6./tbl.protein;
tbl.x = repelem((8:-1:1)',9);
tbl.FC_sub = tbl.Time6-tbl.Time1;
tbl.nFC_sub = tbl.nTime6-tbl.Time1./tbl.protein;

%%
feature = ["Time6" "nTime6" "FC" "FC_sub" "nFC_sub"];
ylabel_text = ["Activity @ Time_{Max}" "normalized Activity @ Time_{Max}" "FC" "FC sub" "nFC sub"];

close all
for i = 1:length(feature)
    figure
    % colormap lines
    hold on
    % s = swarmchart(tbl.x,tbl.Time6,[],tbl.Exp,'filled','XJitterWidth',0.25);
    s = swarmchart(tbl.x(tbl.Exp==1),tbl.(feature(i))(tbl.Exp==1),'filled','XJitterWidth',0.25);
    s = swarmchart(tbl.x(tbl.Exp==2),tbl.(feature(i))(tbl.Exp==2),'filled','XJitterWidth',0.25);
    s = swarmchart(tbl.x(tbl.Exp==3),tbl.(feature(i))(tbl.Exp==3),'filled','XJitterWidth',0.25);
    hold off

    set(gca,'Layer','top','FontSize',16,'LineWidth',1,'TickDir','out', ...
        'XTick',1:8,'XTickLabel',string(unique(tbl.Erastin)),'xlim',[0.5 8.5], ...
        'yscale','linear')
    ylabel(ylabel_text(i))
    xlabel("Erastin (µM)")
    legend("Exp"+[1:3],'Location','best')
end

%% statistical test
[p,~,stats] = kruskalwallis(tbl.nTime6,tbl.x,'off');
[c] = multcompare(stats);

PValues = nan(size(c,1),1);
for i = 1:length(PValues)
    xx = tbl.nTime6(tbl.x==c(i,1));
    yy = tbl.nTime6(tbl.x==c(i,2));
    PValues(i,1) = ranksum(xx,yy);
end
FDR = mafdr(PValues,'BHFDR',1);
c(:,7) = FDR;

figure
tmp = sparse(c(:,1),c(:,2),c(:,7),nnz(unique(tbl.x)),nnz(unique(tbl.x)));
heatmap(full(tmp+tmp'),'XDisplayLabels',string(fliplr([10 5 2.5 1.25 0.6 0.3 0.15 0])),...
    'YDisplayLabels',string(fliplr([10 5 2.5 1.25 0.6 0.3 0.15 0])),'title','Mann–Whitney U test, FDR','FontSize',16)

%%
close all
figure
% colormap lines
hold on
s = swarmchart(tbl.x,tbl.nTime6,[],[59, 73, 146]/255,'o','MarkerEdgeAlpha',0.3,'XJitter','rand','XJitterWidth',0.35);
hold off

tblG = groupsummary(tbl.nTime6,tbl.x,{'mean' 'std'});
hold on
errorbar(1:8,tblG(:,1),tblG(:,2),'o','color','k',...
    'LineWidth',1,'MarkerFaceColor','k')
hold off

set(gca,'Layer','top','FontSize',16,'LineWidth',1,'TickDir','out', ...
    'XTick',1:8,'XTickLabel',string(unique(tbl.Erastin)),'xlim',[0.5 8.5], ...
    'yscale','linear')
ylabel("normalized Activity (×10⁴)")
xlabel("Erastin (µM)")
ylim([3600 14400])
yticks(4000:2000:14000)
yticklabels([0.4:0.2:1.4])

tbl_source = table(tbl.x,tbl.nTime6/10^4,...
    'VariableNames',["Erastin (µM)","NOX activity (AU)"]);
tmp = unique(tbl.Erastin);
tbl_source.("Erastin (µM)") = tmp(tbl_source.("Erastin (µM)"))
% writetable(tbl_source,"../../ftw_paper_figures_v2/source_data/figS17.xlsx","Sheet","c")

tblG = groupsummary(tbl_source,"Erastin (µM)","mean","NOX activity (AU)")

% exportgraphics(gcf,"NOX_activity_erastin.pdf")
%%
effect = "cohen"
Effect = arrayfun(@(i)meanEffectSize(tbl.nTime6(tbl.x==i),tbl.nTime6(tbl.x==1),...
    Effect=effect,ConfidenceIntervalType="exact"),2:8,'UniformOutput',0)

xx = 1; y = 0; neg = 0; pos = 0;
for i = 1:length(Effect)
    xx = [xx;i+1];
    y = [y;Effect{i}.Effect];
    neg = [neg;Effect{i}.Effect-Effect{i}.ConfidenceIntervals(1)];
    pos = [pos;-Effect{i}.Effect+Effect{i}.ConfidenceIntervals(2)];
end

figure
errorbar(xx,y,neg,pos,'s','color','k','LineWidth',1,'MarkerFaceColor','k','CapSize',0,'Color',0.7.*[1 1 1],'MarkerSize',16)

xlabel("Erastin (µM)")
ylabel("Cohen's \itd\rm and 95% CI")
set(gca,'Layer','top','LineWidth',1,'FontSize',16,'tickdir','out',...
    'XTick',1:8,'XTickLabel',string(fliplr([10 5 2.5 1.25 0.6 0.3 0.15 0])),'xlim',[0.5 8.5]) % 
box off
ylim([-1.2 5.2])
yline(0,'--')
title('normalized Activity')
% exportgraphics(gcf,"NOX_activity_erastin_cohensD.pdf")
%%
% fit distribution for violin plot
vCurve = cell(8,1);
for i = 1:length(vCurve)
    [f,xi] = ksdensity(tbl.nTime6(tbl.x==i));
    vCurve{i,1} = [f',xi'];
end

close all
figure

hold on
for i = 1:size(vCurve,1)
%     plot(-0.325.*normalize(vCurve{i,1}(:,1),'range')+i,vCurve{i,1}(:,2),'k','linewidth',1)
%     plot(0.325.*normalize(vCurve{i,1}(:,1),'range')+i,vCurve{i,1}(:,2),'k','linewidth',1)

    x = [-0.325.*normalize(vCurve{i,1}(:,1),'range')+i;flipud(0.325.*normalize(vCurve{i,1}(:,1),'range')+i)];
    yy = [vCurve{i,1}(:,2);flipud(vCurve{i,1}(:,2))];
    pgon = polyshape(x,yy);
    plot(pgon,'EdgeColor','none','FaceColor',lines(1)) % [59, 73, 146]/255
end
hold off

tblG = groupsummary(tbl.nTime6,tbl.x,{'mean' 'std'});
hold on
errorbar(1:8,tblG(:,1),tblG(:,2),'o','color','k',...
    'LineWidth',1,'MarkerFaceColor','k')
hold off

set(gca,'Layer','top','FontSize',16,'LineWidth',1,'TickDir','out', ...
    'XTick',1:8,'XTickLabel',string(unique(tbl.Erastin)),'xlim',[0.5 8.5], ...
    'yscale','linear')
ylabel("normalized Activity (×10⁴)")
xlabel("Erastin (µM)")

ylim([1200 16800])
yticks(2000:2000:16000)
yticklabels([0.2:0.2:1.6])

% exportgraphics(gcf,"NOX_activity_erastin.pdf")