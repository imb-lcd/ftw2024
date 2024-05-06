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

% load name for each well in the 2 experimental batches
tbl = readtable("..\data\filename.csv",'Delimiter',',');
prefixs = string(tbl.output)';
clearvars tbl

load("..\data\initiations.mat")
initiation = initiation(initiation.area_ratio>=1 & initiation.area_ratio<=20,:);

occurrence = zeros(180*9,14);
for i = 1:height(initiation)
    r = find(ismember(prefixs,initiation.batch_well(i)));
    r = (r-1)*9 + initiation.grid(i);
    c = initiation.frame(i);
    occurrence(r,c) = occurrence(r,c)+1;
end
occurrence(84*9+1:end,8:end) = nan;

%%% get the ids of wrong initiations based on visually determined
id_remove = manual_remove_wrong_initiation(initiation);
initiation(vertcat(id_remove{:}),:) = [];

occurrence = zeros(180*9,14);
for i = 1:height(initiation)
    r = find(ismember(prefixs,initiation.batch_well(i)));
    r = (r-1)*9 + initiation.grid(i);
    c = initiation.frame(i);
    occurrence(r,c) = occurrence(r,c)+1;
end
occurrence(84*9+1:end,8:end) = nan;
occurrence = occurrence(1:84*9,8:end-1);

%%
close all
figure('Position',[-1021 -454 560 1450])
imagesc([1 6],[1 84*9],occurrence);%,'AlphaData',(occurrence(1:84*9,8:end-1)>0))
set(gca,'Layer','top','LineWidth',1,'FontSize',16,'TickDir','out')
set(gca,'Position',[0.1588    0.1100    0.6514    0.8150])
color_nbr = flipud(bone(5));
color_nbr = [1 1 1;color_nbr(2:end,:)];

cbr = colorbar;
cbr.Position = [0.8398    0.41795    0.0381    0.2];
cbr.TickDirection = 'out';
cbr.LineWidth = 1;
gap = diff(clim)/size(color_nbr,1);
cbr.Ticks = gap.*(1:5)-gap/2;
cbr.TickLabels = ["0" "1" "2" "3" "4"];
cbr.Label.String = "Number of initiations";
ylabel("Position")
xlabel("Time (frame/50-min)")
colormap(color_nbr)
% exportgraphics(gcf,'../heatmap_initiation_silico.pdf','ContentType','vector')

%%
% save("initiations_for_prob_dist_fitting.mat","occurrence")