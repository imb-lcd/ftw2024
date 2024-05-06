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
b1 = load('./data/summary_entropy_batch1.mat');
b2 = load('./data/summary_entropy_batch2_20230822.mat');
b3 = load('./data/summary_entropy_batch3_20240110.mat');
b4 = load('./data/summary_entropy_batch4_20240112.mat');
b5 = load('./data/summary_entropy_batch5_20240118.mat');
b6 = load('./data/summary_entropy_batch6_20240429.mat');

b1.tbl.condition = b1.tbl.condition+10+2;
b2.tbl.condition = b2.tbl.condition+4+2;
b3.tbl.condition = b3.tbl.condition+2+2;
b4.tbl.condition = b4.tbl.condition+1+2;
b5.tbl.condition = b5.tbl.condition+2;
tbl = [b6.tbl;b5.tbl;b4.tbl;b3.tbl;b2.tbl;b1.tbl];

name_condition = ["786-O" "HuH-7" "A-172" "Hs 895.T" "HeLa" "SH-SY5Y" "Erastin" "BSO/FC" "−Cys2" "Sodium iodate" "RSL3" "Staurosporine" "Ionomycin"];
name_condition = ["G-402" "HOS" "LN-18" "U-118MG" "PANC-1" "MDA-MB-231",name_condition];
name_condition = ["A549" "U-2 OS",name_condition];
name_condition = ["NCI-H1650",name_condition];
name_condition = ["HT-1080",name_condition];
name_condition = ["A549, RSL3","U-2 OS, RSL3",name_condition];
tbl.treatment = name_condition(tbl.condition)';

[G,ID] = findgroups(tbl.treatment);

%%% include new RSL3
rsl3 = load("../../20240119_RSL3/script/entropy_RSL3_new.mat");

order = [9 16 3 23 7 8 14 22 17 15 1 12 2 11 10 19 6 5 25 20 18 21 13 24 4];

tmp = [];
for i = 1:length(order)
    if ID(order(i))=="RSL3"
        x = rsl3.tbl;
        x.condition = i.*ones(height(x),1);
        tmp = [tmp;x];
    else
        x = tbl(G==order(i),:);
        x.condition = i.*ones(height(x),1);
        tmp = [tmp;x];
    end
end
tbl = tmp;
name_condition = unique(tbl.treatment,'stable')';

%%
tbl(isnan(tbl.entropy),:) = [];

%% statsistical test
close all
figure
[p,~,stats] = kruskalwallis(tbl.entropy,tbl.condition,'off');
[c] = multcompare(stats);

PValues = nan(size(c,1),1);
for i = 1:length(PValues)
    xx = tbl.entropy(tbl.condition==c(i,1));
    yy = tbl.entropy(tbl.condition==c(i,2));
    PValues(i,1) = ranksum(xx,yy);
end
FDR = mafdr(PValues,'BHFDR',1);
c(:,7) = FDR;

tmp = sparse(c(:,1),c(:,2),c(:,7),nnz(unique(tbl.condition)),nnz(unique(tbl.condition)));
tmp = tmp+tmp';
tmp = -log10(tmp);
D = full(tmp);
D(1:nnz(unique(tbl.condition))+1:end) = 0;
yOut = squareform(D);
Z = linkage(yOut);
leafOrder = optimalleaforder(Z,D);
dendrogram(Z,0,'reorder',leafOrder)

tmp = sparse(c(:,1),c(:,2),c(:,7),nnz(unique(tbl.condition)),nnz(unique(tbl.condition)));
tmp = tmp(leafOrder,leafOrder);
heatmap(full(tmp+tmp'),'XDisplayLabels',name_condition(leafOrder),...
    'YDisplayLabels',name_condition(leafOrder),'title','Mann–Whitney U test, FDR','FontSize',16)

%%
tblG = groupsummary(tbl,"condition",{'mean' 'std'},{'entropy'});
tblG.name = name_condition(tblG.condition)';
tblG = movevars(tblG,"name","After","condition");

close all
figure('Position',[184   371   750   420])

% swarmchart
hold on
swarmchart(tbl.condition,tbl.entropy,20,[157,164,201]/255,'o',...
    'XJitterWidth',0.25,'XJitter','rand','MarkerFaceColor','w','LineWidth',0.25); % [59, 73, 146]/255
hold off

% errorbar
hold on
feature = "entropy";
errorbar(tblG.condition,tblG.("mean_"+(feature)),tblG.("std_"+(feature)),'o','color','k',...
    'LineWidth',1,'MarkerFaceColor','k')
hold off

ylabel("Entropy")
ylim([0.6 5.4])
set(gca,'Layer','top','LineWidth',1,'FontSize',16,'tickdir','out',...
    'XTick',1:length(name_condition),'XTickLabel',name_condition,'xlim',[0 length(name_condition)+1]) % ,'ylim',[400 650]
box off

hold on
plot([22 22 25 25],[4.75 4.75+0.1 4.75+0.1 4.7],'k-','LineWidth',1)
plot([1 1 21 21],[4.3 4.75+0.1 4.75+0.1 4.4],'k-','LineWidth',1)
plot([11 11 23.5 23.5],[4.85 4.85+0.2 4.85+0.2 4.85],'k-','LineWidth',1)
plot(16.75,5.2,'k*','LineWidth',1)
plot([17 23],[1.5 1.5],'k-','LineWidth',1)
hold off
text(mean([17 23]),1.5,"RPE-1",'HorizontalAlignment','center','VerticalAlignment','top','FontSize',16)

%%%
% exportgraphics(gcf,".\entropy_mean_SD.pdf","ContentType","vector")

tbl_source = tbl;
% writetable(tbl_source,"../../ftw_paper_figures_v2/source_data/figS1.xlsx","Sheet","k")

