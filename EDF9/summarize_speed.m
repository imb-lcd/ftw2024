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

scene = 1:12;
conc = repelem([0.25 0.06 0.03 0],3);
frame_strt = [6 7 7 7 11 6 8 6 7 7 11 7];
frame_stop = [9 10 11 10 14 9 11 10 10 11 15 12];
width =  [1012.56, -1256.22, 1471.66, 214.94, -685.10, -592.29, -329.32, -1048.30,  621.61,  176.13, 374.75, 1070.44];
height = [-834.54,   122.63, -902.34, 819.55, -742.37, -787.25,  775.96,   172.42, -722.03, 1034.84, 944.74,  -37.49];
len = [1650.188,1580.828,1969.918,1054.156,1227.934,1231.175,1010.022,1324.048,1149.103,1319.997,1252.791,1348.774]; % um
tbl = table(scene',conc',frame_strt',frame_stop',width',height',len');
tbl.Properties.VariableNames = ["scene","FSEN","frame_strt","frame_stop",'width','height','dist'];
tbl.img = "FSEN_"+pad(string(round(tbl.FSEN*100)),2,'left','0')+"_s"+pad(string(tbl.scene),2,'left','0');
clearvars -except tbl

speed = nan(height(tbl),1);
for i = 1:height(tbl)
    load("kymo"+i+".mat")
    speed(i) = kymograph.speed{1}{1}(1)/60;
end
tbl.speed = speed;
clearvars -except tbl

speed_manual = [0.152795,0.146374,0.1368,0.097607,0.1136398,0.113998,0.093521,0.091948,0.106399,0.091666,0.086999,0.089527].*60;
tbl.speed_manual = speed_manual';
clearvars -except tbl

[G,ID] = findgroups(tbl.FSEN);
color_group = lines(4);

%%
figure
for i = 1:length(ID)
    hold on
    % swarmchart(i.*ones(nnz(G==i)),tbl.speed(G==i),'filled','XJitterWidth',0.3,'MarkerFaceColor',color_group(i,:))
    swarmchart(i.*ones(nnz(G==i)),tbl.speed(G==i),'XJitterWidth',0.3,'MarkerEdgeColor',[59, 73, 146]/255,'MarkerFaceColor','none')
    errorbar(i+0.3,mean(tbl.speed(G==i)),std(tbl.speed(G==i)),'ko','LineWidth',1,'MarkerFaceColor','k')
    hold off
end

ylabel("Speed (µm/min)")
xlabel("FSEN1 (µM)")
xticks(1:4);
xticklabels(string(ID))
set(gca,'layer','top','linewidth',1,'tickdir','out','fontsize',16)
axis square
axis padded
% ylim([4.17 9.49])
ylim([4.5 8.7])
% exportgraphics(gcf,"..\fig\speed_dose_FSEN.pdf","ContentType","vector")
tbl_source = table(tbl.FSEN,tbl.speed,'VariableNames',["FSEN1 (µM)","Speed (µm/min)"]);
% writetable(tbl_source,"../../../ftw_paper_figures_v2/source_data/figS14.xlsx","Sheet","b")
tblG = groupsummary(tbl_source,"FSEN1 (µM)","mean","Speed (µm/min)")
