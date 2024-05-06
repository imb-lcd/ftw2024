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

%% organize measured speed
list = struct2table(dir("..\data\kymograph_s*.mat"));

well = [];
signal = [];
angle = [];
speed = [];
distance = [];
for i = 1:height(list)
    load(fullfile(list.folder{i},list.name{i}))
    for j = 1:height(kymograph)
        if ~isempty(kymograph.speed{j})
            expression = "s(?<well>\d+)_(?<signal>[a-z]+[0-9]*)*";
            tokenNames = regexp(kymograph.source_img(j),expression,'names');
            well = [well;str2double(tokenNames.well)];
            signal = [signal;tokenNames.signal];
            angle = [angle;kymograph.angle(j)];
            speed = [speed;kymograph.speed{j}{1}(1)/3600];
            distance = [distance;size(kymograph.maxR{j},2)*1.266];
        end
    end
end

tbl = table(well,signal,angle,speed,distance);

% discard one speed measurement
[G,ID1,ID2] = findgroups(tbl.well,tbl.angle);
tmp = tabulate(G);
tbl(ismember(G,tmp(tmp(:,2)==1,1)),:) = [];

% discard the measurement if range is greater than 0.05
[G,ID1,ID2] = findgroups(tbl.well,tbl.angle);
[B,BG,BC] = groupsummary(tbl.speed,G,'range');
tbl(~ismember(G,BG(B<0.005)),:) = [];

tbl.level(ismember(tbl.well,[10,21,28,45]))=1;
tbl.level(ismember(tbl.well,[9,16,33,40]))=2;
tbl.level(ismember(tbl.well,[8,17,32,41]))=3;
tbl.level(ismember(tbl.well,[18,24,25,31]))=4;
tbl.well_color(ismember(tbl.well,[24  8 16 21])) = 1;
tbl.well_color(ismember(tbl.well,[18 17  9 10])) = 2;
tbl.well_color(ismember(tbl.well,[25 32 33 28])) = 3;
tbl.well_color(ismember(tbl.well,[31 41 40 45])) = 4;

clearvars well
wells = [10,16,17,18,21,24,25,28,31,32,33,40,41,45,8,9];
for i = 1:length(wells)
    tmp = tbl(tbl.well==wells(i)&tbl.signal=="cy5",:);
    [~,I] = sort(abs(median(tmp.speed)-tmp.speed));
    tmp = tmp(I,:);
    well(wells(i),:) = [wells(i) tmp.angle(1) tmp.speed(1) tmp.level(1)];
    if i==15
        well(wells(i),:) = [wells(i) tmp.angle(13) tmp.speed(13) tmp.level(13)];
    end
end
well(well(:,3)==0,:) = [];
well = [well;repmat([38 0 0 0;37 0 0 -1],4,1)];
well(:,4) = well(:,4)+2;

%% statistical test
close all
figure
[p,~,stats] = kruskalwallis(well(:,3),well(:,4),'off');
[c] = multcompare(stats);

PValues = nan(size(c,1),1);
PPValues = PValues;
for i = 1:length(PValues)
    x = well(well(:,4)==c(i,1),3);
    y = well(well(:,4)==c(i,2),3);
    PValues(i,1) = ranksum(x,y);
end
FDR = mafdr(PValues,'BHFDR',1);
c(:,7) = FDR;

effect = "mediandiff"
Effect = cell(size(c,1),1);
x = well(:,4);
w = well(:,3);
for i = 1:size(c,1)
    Effect{i} = meanEffectSize(w(x==c(i,2)),w(x==c(i,1)),...
        Effect=effect,ConfidenceIntervalType="bootstrap");
    c(i,8) = Effect{i}.ConfidenceIntervals(1)*...
        Effect{i}.ConfidenceIntervals(2)>0;
    c(i,9) = Effect{i}.Effect;
end

figure
tmp = sparse(c(:,1),c(:,2),c(:,7),nnz(unique(x)),nnz(unique(x)));
heatmap(full(tmp+tmp'),'XDisplayLabels',string([0.3 0.6 1.25 2.5 5 10]),...
    'YDisplayLabels',string([0.3 0.6 1.25 2.5 5 10]),'title','Mann–Whitney U test, FDR','FontSize',16)

%% plot
close all
tblG = groupsummary(well(:,3).*60,well(:,4),{'mean' 'std'});

figure
swarmchart(well(:,4)-0.25,well(:,3).*60,[],[59, 73, 146]/255,'XJitter','none','XJitterWidth',0.15)
hold on
errorbar(1:6,tblG(:,1),tblG(:,2),'o','color','k','LineWidth',1,'MarkerFaceColor','k')
hold off

ylim([-0.2 6.2]); ylabel("Speed (µm/min)")
xlim([0.5 6.5]); xlabel("Erastin (µM)")
set(gca,'Layer','top','LineWidth',1,'fontsize',16,'TickDir','out',...
    'xtick',1:6,'XTickLabel',string([0.3 0.6 1.25 2.5 5 10]))

% exportgraphics(gcf,"..\fig\speed_dose.pdf","ContentType","vector")
% writetable(tbl_source,"../../source_data/fig4.xlsx","Sheet","e")
