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

%% organize result
clear;load("..\data\quantification_iron.mat")
tbl = tbl_cell(ismember(tbl_cell.site,[131 60 11 51 83 86 26 157]),:);
tbl = sortrows(tbl,"era");

[G,ID] = findgroups(tbl.era);
tbl.x = G;
y = false(height(tbl),1);
for i = 1:length(ID)
    tmp = tbl.mean_intensity(G==i);
    y(G==i) = isoutlier(tmp);
end
tbl(y==1,:) = [];

% vCurve
vCurve = cell(length(ID),1);
for i = 1:length(ID)
    [f,xi] = ksdensity(tbl.mean_intensity(tbl.x==i));
    vCurve{i,1} = [f',xi'];
end

%% statistical test
close all
figure
[p,~,stats] = kruskalwallis(tbl.mean_intensity,tbl.x,'off');
[c] = multcompare(stats);

PValues = nan(size(c,1),1);
for i = 1:length(PValues)
    x = tbl.mean_intensity(tbl.x==c(i,1));
    y = tbl.mean_intensity(tbl.x==c(i,2));
    PValues(i,1) = ranksum(x,y);
end
FDR = mafdr(PValues,'BHFDR',1);
c(:,7) = FDR;

effect = "mediandiff"
Effect = cell(size(c,1),1);
x = tbl.x;
w = tbl.mean_intensity;
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
figure
hold on
for i = 1:size(vCurve,1)
    x = [-0.325.*normalize(vCurve{i,1}(:,1),'range')+i;flipud(0.325.*normalize(vCurve{i,1}(:,1),'range')+i)];
    yy = [vCurve{i,1}(:,2);flipud(vCurve{i,1}(:,2))];
    pgon = polyshape(x,yy);
    plot(pgon,'EdgeColor','none','FaceColor',lines(1))
end
hold off

hold on
tblG = groupsummary(tbl.mean_intensity,tbl.x,{'mean' 'std'});
errorbar(1:8,tblG(:,1),tblG(:,2),'o','color','k','LineWidth',1,'MarkerFaceColor','k')
hold off

xlabel("Erastin (µM)")
ylabel('Fe^{2+} (A.U.)')
set(gca,'Layer','top','LineWidth',1,'FontSize',16,'tickdir','out',...
    'XTick',1:8,'XTickLabel',string(fliplr([10 5 2.5 1.25 0.6 0.3 0.15 0])),'xlim',[0.5 8.5])
box off
ylim([-10 160])
