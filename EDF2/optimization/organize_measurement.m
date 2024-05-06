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

%% export table of FBS for R plotting
tbl = readtable("\FBS titration plot.xlsx","Sheet",1);
tbl.Properties.VariableNames = ["FBS_conc" "nI" "tI"];
tbl.x = repelem(6:-1:1,[5 5 6 5 5 4])';

tbl(19,:) = []; % remove outlier

clearvars -except tbl
% writetable(tbl,"..\data\wave_optimization_FBS.csv")

tblG = groupsummary(tbl,"x",{'mean' 'std'},{'nI' 'tI' 'FBS_conc'});
tblG = movevars(tblG,"mean_FBS_conc","After","x");

feature = "tI";
text_ylabel = "Timing of initiation"
prefix = "initiation_time"
ylimit = [0 12];

feature = "nI";
text_ylabel = "Number of initiation"
prefix = "initiation_number"
ylimit = [0 10];

%% visualize
close all
figure
swarmchart(tbl.x+0.2,tbl.(feature),[],[59, 73, 146]./255,'o','XJitter','density','XJitterWidth',0.25)

hold on
% errorbar(xx,y,neg,pos,'o','color','k','LineWidth',1)
% yline(median(tbl.tI(tbl.x==1)),'--')
errorbar(tblG.x,tblG.("mean_"+(feature)),tblG.("std_"+(feature)),'o','color','k','LineWidth',1,'MarkerFaceColor','k')
hold off

xlabel("FBS (%)");
% ylabel("Number of initiations")
ylabel(text_ylabel)
set(gca,'FontSize',16,'LineWidth',1,'tickdir','out',...
    'XLim',[0.5 6.5],'XTickLabel',string(round(unique(tbl.FBS_conc),2)))
ylim(ylimit)

% exportgraphics(gcf,"..\fig\"+prefix+"_FBS.pdf",'ContentType','vector')
% tbl_source = table(tbl.FBS_conc,tbl.nI);
% tbl_source.Properties.VariableNames = ["FBS (%)","Number of initiation"];
% writetable(tbl_source,"../../../ftw_paper_figures_v2/source_data/figS2.xlsx","Sheet","g_number_of_initiation")
% tbl_source = table(tbl.FBS_conc,tbl.tI);
% tbl_source.Properties.VariableNames = ["FBS (%)","Timing of initiation (h)"];
% writetable(tbl_source,"../../../ftw_paper_figures_v2/source_data/figS2.xlsx","Sheet","g_time_of_initiation")

%% export table of transferrin for R plotting
tbl = readtable("\2020-10-16_TrF alone titration.xlsx","Sheet",1);
well = tbl.Well;
TrF_batch = [repmat(repelem(["New" "Old"]',3),5,1);repelem(" ",6,1)];
TrF_conc = repelem([4 1.3 0.4 0.11 0.03 0]',6);
nI = tbl.No_OfInitiations;
tI = tbl.TimeOfInitiation;
tbl = table(TrF_conc,TrF_batch,well,nI,tI);
tbl.x = repelem(6:-1:1,6)';

clearvars -except tbl
% writetable(tbl(1:29,:),"..\data\wave_optimization_TrF.csv")

tblG = groupsummary(tbl,"x",{'mean' 'std'},{'nI' 'tI' 'TrF_conc'});
tblG = movevars(tblG,"mean_TrF_conc","After","x");

% feature = "tI";
% text_ylabel = "Timing of initiation"
% prefix = "initiation_time"
% ylimit = [0 30];
% tbl(12,:) = []; % remove outlier

feature = "nI";
text_ylabel = "Number of initiation"
prefix = "initiation_number"
ylimit = [0 8];
tbl(30:35,:) = []; % remove outlier

%% visualize
close all
figure
swarmchart(tbl.x-0.8,tbl.(feature),30,[59, 73, 146]./255,'o','XJitter','density','XJitterWidth',0.25)

hold on
errorbar(tblG.x-1,tblG.("mean_"+(feature)),tblG.("std_"+(feature)),'o','color','k','LineWidth',1,'MarkerFaceColor','k')
hold off

xlabel("Transferrin (mg/mL)");
% ylabel("Number of initiations")
ylabel(text_ylabel)
set(gca,'FontSize',16,'LineWidth',1,'tickdir','out',...
    'XLim',[0.5 5.5],'XTickLabel',string(round(unique(tbl.TrF_conc),2)))
ylim(ylimit)

% exportgraphics(gcf,"..\fig\"+prefix+"_TrF.pdf",'ContentType','vector')
% tbl_source = table(tbl.TrF_conc,tbl.nI);
% tbl_source.Properties.VariableNames = ["Transferrin (mg/mL)","Number of initiation"];
% writetable(tbl_source,"../../../ftw_paper_figures_v2/source_data/figS2.xlsx","Sheet","h_number_of_initiation")
% tbl_source = table(tbl.TrF_conc,tbl.tI);
% tbl_source.Properties.VariableNames = ["Transferrin (mg/mL)","Timing of initiation (h)"];
% writetable(tbl_source,"../../../ftw_paper_figures_v2/source_data/figS2.xlsx","Sheet","h_time_of_initiation")
