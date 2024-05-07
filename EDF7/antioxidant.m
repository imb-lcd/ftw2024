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

tbl = readtable("Data-Abs at 517nm.xlsx");

data = table2array(tbl(2:end,3:end));
cond = [repelem("Trolox",4,1)+", "+[32;16;8;4]+"μM";"LY294002, 100μM";"GKT, 5μM";"Dasatinib, 10μM";"Control"];

ndata = data./repmat(data(end,:),8,1);

index = [8,1,6,7,5];

ndata = ndata(index,:);
cond = cond(index);

%%
close all
figure
bar(1:length(cond),mean(ndata,2),'EdgeColor','w','FaceColor',[0.6 0.6 0.6],'LineWidth',1)
hold on
errorbar(1:length(cond),mean(ndata,2),std(ndata,[],2),'k.','Marker','none','LineWidth',1)

for i = 1:size(ndata,1)
s = swarmchart(i.*ones(1,3)-0.2,ndata(i,:),150,'k.','XJitter','rand','XJitterWidth',0.8);
s.MarkerFaceColor = 'none';
end
hold off

xticklabels(cond)
xticklabels(["Control" "Trolox" "GKT137831" "Dasatinib" "LY294002"])
ylabel(["Relateive DPPH"; "abs at 517 nm"])
ylabel(["DPPH abs (517nm)"])
set(gca,'fontsize',16,'tickdir','out','XColor','k','YColor','k','Layer','top','LineWidth',1,'FontName','Arial')
box off
title(["Cell-free"; "antioxidant activity"])

axis square
axis padded

exportgraphics(gcf,'antioxidant_datapoints.pdf','ContentType','vector')
tmp = ndata';
tbl_source = table(repelem(cond,3),tmp(:),'VariableNames',["Condition","DPPH abs"]);
% writetable(tbl_source,"../../ftw_paper_figures_v2/source_data/figS11.xlsx","Sheet","abs")

tblG = groupsummary(tbl_source,"Condition","mean","DPPH abs")