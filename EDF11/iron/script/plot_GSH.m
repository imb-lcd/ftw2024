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

%% organize data
tbl = readtable("..\data\Glutathione measurement-FINAL.xlsx",...
    'Sheet','8 h after','Range','B20:L27');
erastin = repmat(tbl.Var11,1,5);
GSH = table2array(tbl(:,1:5));
GSSG = table2array(tbl(:,6:10));

tbl = table(erastin(:),GSH(:),GSSG(:),'variablename',{'era','GSH','GSSG'});
tbl.conc = tbl.era+"uM";
tbl = sortrows(tbl,"era");
tbl.x = repelem((1:8)',5);

tbl(32,:) = [];

%% statistical test
close all
figure
[p,~,stats] = kruskalwallis(tbl.GSH,tbl.x,'off');
[c] = multcompare(stats);

PValues = nan(size(c,1),1);
for i = 1:length(PValues)
    x = tbl.GSH(tbl.x==c(i,1));
    y = tbl.GSH(tbl.x==c(i,2));
    PValues(i,1) = ranksum(x,y);
end
FDR = mafdr(PValues,'BHFDR',1);
c(:,7) = FDR;

% [fdr,q,priori,R2] = mafdr(PValues,'Showplot',true);

effect = "cohen"
Effect = cell(size(c,1),1);
x = tbl.x;
w = tbl.GSH;
for i = 1:size(c,1)
    Effect{i} = meanEffectSize(w(x==c(i,2)),w(x==c(i,1)),...
        Effect=effect,ConfidenceIntervalType="bootstrap");
    c(i,8) = Effect{i}.ConfidenceIntervals(1)*...
        Effect{i}.ConfidenceIntervals(2)>0;
    c(i,9) = Effect{i}.Effect;
end

figure
tmp = sparse(c(:,1),c(:,2),c(:,7),nnz(unique(x)),nnz(unique(x)));
heatmap(full(tmp+tmp'),'XDisplayLabels',string([0 0.15 0.3 0.6 1.25 2.5 5 10]),...
    'YDisplayLabels',string([0 0.15 0.3 0.6 1.25 2.5 5 10]),'title','Mann–Whitney U test, FDR','FontSize',16)

%%
close all
effect = "cohen"
Effect = arrayfun(@(i)meanEffectSize(tbl.GSH(tbl.x==1),tbl.GSH(tbl.x==i),...
    Effect=effect,ConfidenceIntervalType="exact"),2:8,'UniformOutput',0)

xx = []; y = []; neg = []; pos = [];
for i = 1:length(Effect)
    xx = [xx;i+1];
    y = [y;Effect{i}.Effect];
    neg = [neg;Effect{i}.Effect-Effect{i}.ConfidenceIntervals(1)];
    pos = [pos;-Effect{i}.Effect+Effect{i}.ConfidenceIntervals(2)];
end
xx = [xx;1]; y = [y;0]; neg = [neg;0]; pos = [pos;0];

tblG = groupsummary(tbl.GSH,tbl.x,{'mean' 'std'});

figure
swarmchart(tbl.x-0.2,tbl.GSH,20,[157,164,201]/255,'o',...
    'XJitterWidth',0.25,'XJitter','rand','MarkerFaceColor','w','LineWidth',0.25);
hold on
errorbar(1:8,tblG(:,1),tblG(:,2),'o','color','k','LineWidth',1,'MarkerFaceColor','k')
hold off
xlabel("Erastin (µM)")
ylabel('GSH (A.U.)')
set(gca,'Layer','top','LineWidth',1,'FontSize',16,'tickdir','out',...
    'XTick',1:8,'XTickLabel',string(unique(tbl.era)),'xlim',[0.5 8.5]) % ,'ylim',[475 600]
box off
ylim([-0.1 3.1])

% exportgraphics(gcf,"..\fig\priming_GSH.pdf","ContentType","vector")

