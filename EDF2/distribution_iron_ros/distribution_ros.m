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

load("quantification_steadystate.mat")
tbl = tbl_cell(~(isnan(tbl_cell.ss_before)|isnan(tbl_cell.ss_after)),:);
G = groupsummary(tbl,'era','median',{'ss_after'});

% sample 80 results for each erastin levels
s = RandStream('mlfg6331_64','Seed',84); 
isSampled = false(height(tbl),1);
for i = 1:height(G)
    index = find(tbl.era==G.era(i));
    y = randsample(s,1:length(index),80);
    y = sort(y);
    index = index(y);
    isSampled(index) = 1;
end
tbl.isSampled = isSampled;

load('photoinduction_tracking_rosMean_d7_Analyze3.mat')
cellAnnotation = vertcat(measurements_CFP(:).cellAnnotation);
cellAnnotation = cell2mat(cellAnnotation(:,2:3));

idx = nan(height(tbl),1);
for i = 1:height(tbl)
    idx(i) = find(cellAnnotation(:,1)==tbl.well(i) & cellAnnotation(:,2)==tbl.index(i));
end

division = vertcat(measurements_CFP(:).filledDivisionMatrixDataset);
division = division(idx,1:50);

t = 0:10:1520;
t([3 40]) = [];
t = minutes(t(1:50));

tErastin = mean(t([2 3]));
tPhotoIn = mean(t([38 39]));

%% one cell
c = lines(7);

idxs = 1;
for idx = idxs
    s = tbl.ros{idx};

    nexttile
    hold on
    plot(t(3:7),s(3:7),'.-','LineWidth',5,'color',c(2,:))
    plot(t(39:43),s(39:43),'.-','LineWidth',5,'color',c(3,:))
    plot(t,s,'.-','LineWidth',1,'color',c(1,:))
    hold off    
    xline([tErastin tPhotoIn],'--')
    ylabel("ROS")

    if any(division(idx,:))
        xline(t(division(idx,:)==1),'r--')
    end

    set(gca,'layer','top','fontsize',16,'LineWidth',1,'TickDir','out')
    box on
    axis padded
end

%% one erastin level
% set erastin level and a specific frame
era = 0;
f = 38;

idxs = find(tbl.era==era)';
ros = vertcat(tbl.ros{idxs})'; % absolute value
ros = ros./repmat(ros(3,:),50,1); % relative value
ylimit = [0 5];
binwidth = 0.3;

ub_x = minutes(t(f)+mode(diff(t))/2);
lb_x = minutes(t(f)-mode(diff(t))/2);
ub_y = prctile(ros(f,:),75)+1.5*iqr(ros(f,:));
lb_y = prctile(ros(f,:),25)-1.5*iqr(ros(f,:));

close all
figure
X = ros(f,:)';
h = histogram(X,'Normalization','pdf','EdgeColor','w');
title("ROS distribution ([Era]="+era+")")
xlabel("ROS right before photoinduction")
ylabel("PDF")
set(gca,'layer','top','fontsize',16,'LineWidth',1,'TickDir','out')

pd = fitdist(X,'Logistic');
mu = pd.mu;
sigma = pd.sigma;
x_values = min(X):0.01:max(X);
y = pdf(pd,x_values);

hold on
plot(x_values,y,'LineWidth',2)
hold off
axis padded
% exportgraphics(gcf,'ros_distribution.pdf','ContentType','vector')

tbl_source = table([h.BinEdges(1:end-1)'+h.BinWidth/2;x_values'],[h.Values';y'],repelem(["Observed" "Fitting"],[length(h.Values) length(y)])');
tbl_source.Properties.VariableNames = ["Cellular ROS level (AU)","PDF","Condition"];
% writetable(tbl_source,"../../ftw_paper_figures_v2/source_data/figS2.xlsx","Sheet","f")
