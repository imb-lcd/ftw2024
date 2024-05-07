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
well = [1:5;10:-1:6;11:15;20:-1:16;21:25;30:-1:26;43:47;52:-1:48];
inhibitor = [repelem("zVAD",2,5);repelem("Fer-1",2,5);repelem("Nec-1",4,5)];
conc = [repmat([10 5 2.5 10 5],2,1);repmat([20 10 5 20 10],4,1);repmat([2.5 1.25 0.6 2.5 1.25],2,1)];
timing = [repelem("Before",8,3),repelem("After",8,2)];

tbl = table(well(:),inhibitor(:),conc(:),timing(:),'VariableNames',["well" "inhibitor" "conc" "timing"]);

well = [36:-1:31;37:42;58:-1:53];
inhibitor = [repmat(["zVAD","Fer-1","Nec-1","Control","Control","Control"],2,1);
    ["Fer-1",repelem("Control",1,5)]];
conc = [[2.5 5 5 0 0 0];[2.5 5 5 0 0 0];[10,zeros(1,5)]];
timing = [["After" "After" "After" "No" "No" "No"];...
    ["After" "After" "After" "No" "No" "No"];["After" "No" "No" "No" "No" "No"]];

tbl2 = table(well(:),inhibitor(:),conc(:),timing(:),'VariableNames',["well" "inhibitor" "conc" "timing"]);

tbl = [tbl;tbl2];
tbl(tbl.well==58,:) = [];
tbl = tbl(:,[1 2 4 3]);
tbl = sortrows(tbl,'well');
clearvars -except tbl

[G,TID] = findgroups(tbl(:,2:4));
TID.well = arrayfun(@(i)find(G==i),1:height(TID),'UniformOutput',0)';

%%
x = [];
y = [];
z = [];

for i = 1:57
    fname = "..\data\kymograph_cy5_s"+i+".mat";
    if exist(fname)
        load(fname)
    else
        continue
    end

    kymograph = cell2table(kymograph,'VariableNames',...
        ["kymograph","distance_time","mode_distance_time",...
        "around_mode_distance_time","fitting_result","signal","angle"]);

    if any(cellfun('length',kymograph.fitting_result)==0)
        kymograph(cellfun('length',kymograph.fitting_result)==0,:) = [];
        speed = cellfun(@(p)p{1}(1)/3600,kymograph.fitting_result);
        angle = cell2mat(kymograph.angle);
    else
        speed = cellfun(@(p)p(1)/3600,kymograph.fitting_result);
        angle = kymograph.angle;
    end
    
    x = [x;i.*ones(length(speed),1)];
    y = [y;speed];
    z = [z;angle];
end

% index = find(y<0.2 & y>0);
% x = x(index);
% y = y(index);

%% discard the speed where the kymograph is weird
well_angle{32} = [0:10:60,280:10:350];
well_angle{41} = 110:10:170;
well_angle{35} = 0:10:359;
well_angle{38} = 0:10:359;
well_angle{15} = 0:10:359;
well_angle{16} = 0:10:359;
well_angle{14} = 0:10:359;
well_angle{17} = 0:10:359;
well_angle{44} = 250:10:320;
well_angle{52} = 150:10:180;
well_angle{34} = 310:10:330;
well_angle{24} = [20 30 90];
well_angle{3}  = 0:10:30;

well_angle{32} = 0:10:359;
well_angle{57} = 0:10:359;

index_to_discard = [];
for i = 1:length(well_angle)
    if isempty(well_angle{i})
        continue
    else
        index_to_discard = [index_to_discard;...
            find(x==i & ismember(z,well_angle{i}))];
    end
end

x(index_to_discard) = [];
y(index_to_discard) = [];
%%
close all
figure("Name","Speed");
swarmchart(x,y,'.');
% boxplot(y,x)
% ylim([0 0.2])
xlim([0.5 57.5])
xlabel('Well')
ylabel('Speed')

%% organize data based on wells
xlight = [];
for i = 1:length(x)
    xlight(i) = find(tbl.well==x(i));
end
figure("Name","Speed");
swarmchart(xlight,y,'.');
% xticks(1:16)
% xticklabels(tbl.well)
% xline([4.5 8.5 12.5])
% xlim([0.5 16.5])
% text(2.5:4:14.5,0.15.*ones(1,4),["DAPI" "CFP" "FITC" "YFP"],'HorizontalAlignment','center')
xlabel('well')
ylabel('speed')

tbl_well = tbl;
data = cell(height(tbl),1);
for i = 1:length(data)
    data{i} = [z(x==tbl_well.well(i)),y(x==tbl_well.well(i))];
end
tbl_well.data = data;
tbl_well.min = cellfun(@(i)min(i(:,2)),tbl_well.data,'UniformOutput',0);
tbl_well.max = cellfun(@(i)max(i(:,2)),tbl_well.data,'UniformOutput',0);
tbl_well.mean = cellfun(@(i)mean(i(:,2)),tbl_well.data,'UniformOutput',0);
tbl_well.std = cellfun(@(i)std(i(:,2)),tbl_well.data,'UniformOutput',0);
tbl_well.median = cellfun(@(i)median(i(:,2)),tbl_well.data,'UniformOutput',0);
tbl_well.Q1 = cellfun(@(i)prctile(i(:,2),25),tbl_well.data,'UniformOutput',0);
tbl_well.Q3 = cellfun(@(i)prctile(i(:,2),75),tbl_well.data,'UniformOutput',0);
% fit distribution for violin plot
vCurve = cell(height(tbl_well),1);
for i = 1:height(tbl_well)
    if ~isempty(tbl_well.data{i})
        pd = fitdist(tbl_well.data{i}(:,2),'Kernel');
        v = pdf(pd,linspace(min(tbl_well.data{i}(:,2)),max(tbl_well.data{i}(:,2)),100));
        v = normalize(v,"range");
        vCurve{i} = [v;linspace(min(tbl_well.data{i}(:,2)),max(tbl_well.data{i}(:,2)),100)]';
    end
%     plot(i-y,linspace(min(x),max(x),100))
end
tbl_well.vCurve = vCurve;

hold on
errorbar(1:57,[tbl_well.median{:}],...
    [tbl_well.median{:}]-[tbl_well.Q1{:}],...
    [tbl_well.Q3{:}]-[tbl_well.median{:}],'k_','CapSize',12,'LineWidth',1,'MarkerSize',12)
for i = 1:57
    if ~isempty(tbl_well.vCurve{i})
        plot(i-0.45.*tbl_well.vCurve{i}(:,1),tbl_well.vCurve{i}(:,2),'k-')
    end
end
hold off

tbl_well_sorted = sortrows(tbl_well,{'inhibitor' 'timing' 'conc'});
tbl_well_sorted = tbl_well_sorted([1:11 18:23 12:17 34:45 24:33 52:57 46:51],:);
xWell = [ones(1,11) repelem(2:24,2)];
swarmchart(xWell,cell2mat(tbl_well_sorted.median),'.');

%% 
tmp = tbl_well_sorted(ismember(tbl_well_sorted.well,[55 56 15 16 25 26 4 7]),:);
index = [];
for i = 1:height(tmp)    
%     [~,index{i}] = mink(abs(tmp.data{i}(:,2)-tmp.median{i}),12);

    s = RandStream('mlfg6331_64','Seed',84+i);
    index{i} = randi(s,36,12,1);
end

data = [];
for i = 1:8
    if ~isempty(tmp.data{i})
        speed = tmp.data{i}(index{i},2);
        data = [data;i.*ones(12,1),speed];
    end
end
data(data(:,1)==2,1)=1;
data(data(:,1)==5,1)=3;
data(data(:,1)==6,1)=3;
data(data(:,1)==7,1)=4;
data(data(:,1)==8,1)=4;
data = [data;2.*ones(24,1) zeros(24,1)];

data = array2table(data,'VariableNames',["cond" "speed"]);
% writetable(data,"..\data\inhibitor_speed_sampled.csv")
%%
data = cellfun(@(i)y(ismember(x,i)),TID.well,'UniformOutput',0);
TID.data = data;
TID.min = cellfun(@(i)min(i),TID.data,'UniformOutput',0);
TID.max = cellfun(@(i)max(i),TID.data,'UniformOutput',0);
TID.mean = cellfun(@(i)mean(i),TID.data,'UniformOutput',0);
TID.std = cellfun(@(i)std(i),TID.data,'UniformOutput',0);
TID.median = cellfun(@(i)median(i),TID.data,'UniformOutput',0);
TID.Q1 = cellfun(@(i)prctile(i,25),TID.data,'UniformOutput',0);
TID.Q3 = cellfun(@(i)prctile(i,75),TID.data,'UniformOutput',0);

% fit distribution for violin plot
vCurve = cell(height(TID),1);
for i = 1:height(TID)
    if ~isempty(TID.data{i})
        pd = fitdist(TID.data{i},'Kernel');
        v = pdf(pd,linspace(min(TID.data{i}),max(TID.data{i}),100));
        v = normalize(v,"range");
        vCurve{i} = [v;linspace(min(TID.data{i}),max(TID.data{i}),100)]';
    end
%     plot(i-y,linspace(min(x),max(x),100))
end
TID.vCurve = vCurve;

%% plot the data of the representative kymograph
rep = tbl_well(ismember(tbl_well.well,[56 35 25 7]),:);
rep = rep([4 3 2 1],:);
rep.data{2} = [(0:10:359)',zeros(36,1)];
rep.x = (1:4)';

y = vertcat(rep.data{:});
y(mod(y(:,1),30)~=0,:) = [];
y(:,1) = [];
y = y.*60;
x = repelem((1:4)',12);
tblG = groupsummary(y,x,{'mean' 'std'});

close all
figure
swarmchart(x-0.2,y,30,[59, 73, 146]./255,'o','XJitter','rand','XJitterWidth',0.15)

hold on
errorbar(1:4,tblG(:,1),tblG(:,2),'o','color','k','LineWidth',1,'MarkerFaceColor','k')
hold off

% xlabel("Transferrin (mg/mL)");
ylabel("Speed (µm/min)")
set(gca,'FontSize',16,'LineWidth',1,'tickdir','out',...
    'XLim',[0.5 4.5],'XTick',1:4,'XTickLabel',rep.inhibitor)
ylim([-0.3 6.3])

% exportgraphics(gcf,"..\fig\speed_representatives.pdf","ContentType","vector")
tbl_source = table(x,y);
tbl_source.Properties.VariableNames = ["Condition","Speed (µm/min)"];
tbl_source.Condition = rep.inhibitor(tbl_source.Condition)
tblG = groupsummary(tbl_source,"Condition",{'mean' 'std'});
% writetable(tbl_source,"figS5.xlsx","Sheet","b")

%%
close all
tmp = TID([1 5:7 2:4 13:18 8:12 22:24 19:21],:);
xx = repelem(1:height(tmp),cellfun('length',tmp.data))';
yy = vertcat(tmp.data{:});
figure("Name","Speed");
tiledlayout('flow','Padding','tight','TileSpacing','tight')
nexttile
swarmchart(xx,yy,'.');

hold on
errorbar(1:24,[tmp.median{:}],...
    [tmp.median{:}]-[tmp.Q1{:}],...
    [tmp.Q3{:}]-[tmp.median{:}],'k_','CapSize',12,'LineWidth',2,'MarkerSize',12)
for i = 1:24
    if ~isempty(tmp.vCurve{i})
        plot(i-0.45.*tmp.vCurve{i}(:,1),tmp.vCurve{i}(:,2),'k-')
    end
end
hold off

xticks(1:height(tmp))
xticklabels(string(tmp.inhibitor)+", "+string(tmp.conc)+"uM, "+string(tmp.timing))
xtickangle(90)
xline([7.5 18.5])
ylabel('Speed (um/sec)')

%%
well_order = vertcat(tmp.well{:});
xwell = [];
ywell = [];
for i = 1:length(well_order)
    xwell = [xwell;i*ones(nnz(x==well_order(i)),1)];
    ywell = [ywell;y(x==well_order(i))];
end
figure("Name","Speed");
tiledlayout('flow','Padding','tight','TileSpacing','tight')
nexttile
swarmchart(xwell,ywell,'.');
xline([11.5 23.5 45.5])
xlim([0.5 57.5])

yWell = cell2mat(tmp.median);
figure
hold on
bar(yWell,'FaceColor','none')
swarmchart(xWell,cell2mat(tbl_well_sorted.median),'k.');
hold off
ylim([0 0.1])
xticks(1:height(tmp))
xticklabels(string(tmp.inhibitor)+", "+string(tmp.conc)+"uM, "+string(tmp.timing))
xtickangle(90)

%% Control
figure("Name","Speed");
tiledlayout('flow','Padding','tight','TileSpacing','tight')
range = 1;
nexttile
swarmchart(xx(ismember(xx,range)),yy(ismember(xx,range)),'.');

nexttile
xpos = 0:0.2:2;
xpos = xpos(:);
swarmchart(xpos(xwell(ismember(xwell,1:11))),ywell(ismember(xwell,1:11)),'.');
xlim([-0.2 2.2])

hold on
[B,BG,BC] = groupsummary(ywell(ismember(xwell,1:11)),xwell(ismember(xwell,1:11)),{'median' @(i)prctile(i,25) @(i)prctile(i,75)});
errorbar(xpos(BG),B(:,1),...
    B(:,1)-B(:,2),...
    B(:,3)-B(:,1),'k_','CapSize',12,'LineWidth',2,'MarkerSize',12)
hold off
sgtitle("Control")

%% Nec-1
figure("Name","Speed");
tiledlayout('flow','Padding','tight','TileSpacing','tight')
range = 8:18;
nexttile
swarmchart(xx(ismember(xx,range)),yy(ismember(xx,range)),'.');
xlim([7.5 18.5])

nexttile
xpos = [range-0.2;range+0.2];
xpos = xpos(:);
xpos = [ones(23,1);xpos];
swarmchart(xpos(xwell(ismember(xwell,24:45))),ywell(ismember(xwell,24:45)),'.');

hold on
[B,BG,BC] = groupsummary(ywell(ismember(xwell,24:45)),xwell(ismember(xwell,24:45)),{'median' @(i)prctile(i,25) @(i)prctile(i,75)});
errorbar(xpos(BG),B(:,1),...
    B(:,1)-B(:,2),...
    B(:,3)-B(:,1),'k_','CapSize',12,'LineWidth',2,'MarkerSize',12)
hold off
xlim([7.5 18.5])
sgtitle("Nec-1")

%% zVAD
figure("Name","Speed");
tiledlayout('flow','Padding','tight','TileSpacing','tight')
range = 19:24;
nexttile
swarmchart(xx(ismember(xx,range)),yy(ismember(xx,range)),'.');
xlim([18.5 24.5])

nexttile
xpos = [range-0.2;range+0.2];
xpos = xpos(:);
xpos = [ones(45,1);xpos];
swarmchart(xpos(xwell(ismember(xwell,46:57))),ywell(ismember(xwell,46:57)),'.');

hold on
[B,BG,BC] = groupsummary(ywell(ismember(xwell,46:57)),xwell(ismember(xwell,46:57)),{'median' @(i)prctile(i,25) @(i)prctile(i,75)});
errorbar(xpos(BG),B(:,1),...
    B(:,1)-B(:,2),...
    B(:,3)-B(:,1),'k_','CapSize',12,'LineWidth',2,'MarkerSize',12)
hold off
xlim([18.5 24.5])
sgtitle("zVAD")