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

load("cyanHot.mat")
tbl = readtable("filename.csv","Delimiter",",");

th_size = nan(height(tbl),1);
th_mint = nan(height(tbl),1);
th_dead = nan(height(tbl),1);

i =  1; th_size(i) =  80; th_mint(i) =  600; th_dead(i) =  850;
i =  2; th_size(i) =  80; th_mint(i) =  800; th_dead(i) = 1100;
%%% control
i =  7; th_size(i) = 100; th_mint(i) =  560; th_dead(i) =  700;
i =  8; th_size(i) = 100; th_mint(i) =  560; th_dead(i) =  700;
i =  9; th_size(i) = 100; th_mint(i) =  540; th_dead(i) =  700;
i = 10; th_size(i) = 100; th_mint(i) =  560; th_dead(i) =  700;
%%% dfo
i = 11; th_size(i) = 100; th_mint(i) =  540; th_dead(i) =  700;
i = 12; th_size(i) = 100; th_mint(i) =  540; th_dead(i) =  700;
i = 13; th_size(i) = 100; th_mint(i) =  540; th_dead(i) =  700;
i = 14; th_size(i) = 100; th_mint(i) =  540; th_dead(i) =  700;
%%% fer1
i = 15; th_size(i) = 100; th_mint(i) =  540; th_dead(i) =  700;
i = 16; th_size(i) = 100; th_mint(i) =  540; th_dead(i) =  700;
i = 17; th_size(i) = 100; th_mint(i) =  540; th_dead(i) =  700;
i = 18; th_size(i) = 100; th_mint(i) =  540; th_dead(i) =  700;
%%% h2o2
i = 19; th_size(i) =  80; th_mint(i) = 1000; th_dead(i) = 1200;
%%% no cell, erastin
i = 20; th_size(i) =  80; th_mint(i) = 200; th_dead(i) = 300;
%%% tempo
i = 21; th_size(i) = 100; th_mint(i) =  540; th_dead(i) =  700;
i = 22; th_size(i) = 100; th_mint(i) =  540; th_dead(i) =  700;
i = 23; th_size(i) = 100; th_mint(i) =  540; th_dead(i) =  700;
i = 24; th_size(i) = 100; th_mint(i) =  540; th_dead(i) =  700;
%%% trolox
i = 29; th_size(i) = 100; th_mint(i) =  520; th_dead(i) =  700;
i = 30; th_size(i) = 100; th_mint(i) =  520; th_dead(i) =  700;
i = 31; th_size(i) = 100; th_mint(i) =  520; th_dead(i) =  700;
i = 32; th_size(i) = 100; th_mint(i) =  520; th_dead(i) =  700;
%%% tiron
i = 25; th_size(i) = 100; th_mint(i) =  157; th_dead(i) =  240;
i = 26; th_size(i) = 100; th_mint(i) =  157; th_dead(i) =  240;
i = 27; th_size(i) = 100; th_mint(i) =  157; th_dead(i) =  240;
i = 28; th_size(i) = 100; th_mint(i) =  157; th_dead(i) =  240;

tbl.th_size = th_size;
tbl.th_cell = th_mint;
tbl.th_dead = th_dead;

%% 
pct_death = nan(height(tbl),4);
for i = 1:height(tbl)
    if ~isnan(tbl.th_size(i))
        img = imread("../img/"+tbl.fname(i)+".tif",tbl.frame(i));
        label = imread("../img/"+tbl.fname(i)+"_Label_Image.tif");
        stats = regionprops(label,img,{'Area','MeanIntensity','Centroid'});

        area = [stats(:).Area];
        meanInt = [stats(:).MeanIntensity];
        isDead = area>tbl.th_size(i)&meanInt>tbl.th_dead(i);
        isCell = area>tbl.th_size(i)&meanInt>tbl.th_cell(i);

        img_group = nan(size(img));
        img_group(1:size(img,1)/2,1:size(img,2)/2) = 1;
        img_group(1:size(img,1)/2,size(img,2)/2:end) = 2;
        img_group(size(img,1)/2:end,1:size(img,2)/2) = 3;
        img_group(size(img,1)/2:end,size(img,2)/2:end) = 4;
        grp = arrayfun(@(s)img_group(round(s.Centroid(2)),round(s.Centroid(1))),stats);
        
        pct_death(i,:) = groupsummary((isDead&isCell)',grp,'sum')./groupsummary((isCell)',grp,'sum').*100;
        
       % pct_death(i) = nnz(isDead&isCell)/nnz(isCell)*100;
    end
end
tbl.pct_death = mat2cell(pct_death,ones(height(tbl),1),4);

%%
tbl.group = [1 2 repelem(3,4) repelem(4,4) repelem(5,4) repelem(6,4),...
    7 8 repelem(9,4) repelem(10,4) repelem(11,4)]';

data = tbl(:,[2 7 8]);
data(data.group==3,:) = [];
data = data([1 2 4 8 11 15 16 17 21 26],:);

%%
[minpct,index] = cellfun(@(s)min(s),data.pct_death);
index(1) = 1;
index(2) = 3;
index(3) = 1

%%
[G,TID] = findgroups(data(:,3));
text_ticks = [];

close all
figure
for i = 1:height(TID)
    index = find(G==i);
    tmp = data.pct_death{index};
    hold on
    s = swarmchart(i.*ones(size(tmp)),tmp,12,'filled','XJitterWidth',0.3,...
        'MarkerEdgeColor','none','MarkerFaceAlpha',1,'MarkerFaceColor','k');
    hold off
    text_ticks = [text_ticks;string(data.fname(index(1)))];
end

% text_ticks = strrep(extractBefore(text_ticks,"_nuc"),"_s1","");
% text_ticks = strrep(text_ticks,"_"," ");
text_ticks(1) = "C.M. eluate"; % "30kDa eluate";
text_ticks(2) = "C.M. retention"; % ">30kDa";
text_ticks(3) = "C.M."; % "Control";
text_ticks(4) = "DFO";
text_ticks(5) = "C.M. + Fer-1"; % "Fer-1";
text_ticks(6) = "H₂O₂ eluate"; % "H_2O_2 flow through";
text_ticks(7) = "Wash Ctrl"; % "No cells + erastin";
text_ticks(8) = "C.M. + TEMPO"; % "Tempo";
text_ticks(9) = "C.M. + Tiron";
text_ticks(10) = "C.M. + Trolox"; % "Trolox";

xticks(1:length(text_ticks))
xticklabels(text_ticks)
ylabel("Cell death (%)")
set(gca,'layer','top','linewidth',1,'tickdir','out','fontsize',16,'yscale','lin')

axis padded

ylimit = ylim;

%% group1
index = [3 10 5 8 9 7]
data1 = data(index,:);
text_ticks1 = text_ticks(index);
data1.group = (1:height(data1))';
data1.n = cellfun(@(s)length(s),data1.pct_death);
data1.cond = text_ticks1;
data1 = movevars(data1,"cond","After","fname");

[G,TID] = findgroups(data1(:,4));

close all
figure
for i = 1:height(TID)
    index = find(G==i);
    tmp = data1.pct_death{index};
    hold on
    % s = swarmchart(i.*ones(size(tmp)),tmp,12,'filled','XJitterWidth',0.3,...
    %     'MarkerEdgeColor','none','MarkerFaceAlpha',1,'MarkerFaceColor','k');
    swarmchart(i.*ones(size(tmp)),tmp,'XJitterWidth',0.3,'MarkerEdgeColor',[59, 73, 146]/255,'MarkerFaceColor','none')
    errorbar(i+0.3,mean(tmp),std(tmp),'ko','LineWidth',1,'MarkerFaceColor','k')
    hold off
end

xticks(1:length(text_ticks1))
xticklabels(text_ticks1)
ylabel("Cell death (%)")
set(gca,'layer','top','linewidth',1,'tickdir','out','fontsize',16,'yscale','lin')
axis padded
ylim(ylimit)

axis square

% tbl_source = table(repelem(data1.group,cellfun(@(s)length(s),data1.pct_death)),...
%     [data1.pct_death{:}]','VariableNames',["Condition","Cell death (%)"]);
% tbl_source.Condition = text_ticks1(tbl_source.Condition);
% writetable(tbl_source,"../../../ftw_paper_figures_v2/source_data/figS8.xlsx","Sheet","a")

% exportgraphics(gcf,'../fig/death_percentage_grp1.pdf','ContentType','vector')

%% group2
data2 = data([3,2,1,6],:);
text_ticks2 = text_ticks([3,2,1,6]);
data2.group = (1:height(data2))';
data2.n = cellfun(@(s)length(s),data2.pct_death);
data2.cond = text_ticks2;
data2 = movevars(data2,"cond","After","fname");

[G,TID] = findgroups(data2(:,4));

close all
figure
for i = 1:height(TID)
    index = find(G==i);
    tmp = data2.pct_death{index};
    hold on
    % s = swarmchart(i.*ones(size(tmp)),tmp,12,'filled','XJitterWidth',0.3,...
    %     'MarkerEdgeColor','none','MarkerFaceAlpha',1,'MarkerFaceColor','k');
    swarmchart(i.*ones(size(tmp)),tmp,'XJitterWidth',0.3,'MarkerEdgeColor',[59, 73, 146]/255,'MarkerFaceColor','none')
    errorbar(i+0.3,mean(tmp),std(tmp),'ko','LineWidth',1,'MarkerFaceColor','k')
    hold off    
end

xticks(1:length(text_ticks2))
xticklabels(text_ticks2)
ylabel("Cell death (%)")
set(gca,'layer','top','linewidth',1,'tickdir','out','fontsize',16,'yscale','lin')
axis padded
ylim(ylimit)

% exportgraphics(gcf,'../fig/death_percentage_grp2.pdf','ContentType','vector')

% tbl_source = table(repelem(data2.group,cellfun(@(s)length(s),data2.pct_death)),...
%     [data2.pct_death{:}]','VariableNames',["Condition","Cell death (%)"]);
% tbl_source.Condition = text_ticks2(tbl_source.Condition);
% writetable(tbl_source,"../../../ftw_paper_figures_v2/source_data/figS8.xlsx","Sheet","b")
