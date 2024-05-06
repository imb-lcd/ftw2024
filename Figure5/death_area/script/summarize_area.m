clc; clear; close all

treatment = "ua1";
load("data_"+treatment+".mat",'area_limb','area_death')
opts = detectImportOptions("filename_"+treatment+".csv");
opts = setvartype(opts,'batchID',{'string'});
tbl = readtable("filename_"+treatment+".csv",opts);
tbl.area_limb = area_limb;
tbl.area_death = area_death;
ua1 = tbl;
clearvars -except ua1

treatment = "dfo";
load("data_"+treatment+".mat",'area_limb','area_death')
opts = detectImportOptions("filename_"+treatment+".csv");
opts = setvartype(opts,'batchID',{'string'});
tbl = readtable("filename_"+treatment+".csv",opts);
tbl.area_limb = area_limb;
tbl.area_death = area_death;
dfo = tbl;
clearvars -except ua1 dfo

treatment = "zvad_fer1";
load("data_"+treatment+".mat",'area_limb','area_death')
opts = detectImportOptions("filename_"+treatment+".csv");
opts = setvartype(opts,'batchID',{'string'});
tbl = readtable("filename_"+treatment+".csv",opts);
tbl.area_limb = area_limb;
tbl.area_death = area_death;
zvad_fer1 = tbl;
clearvars -except ua1 dfo zvad_fer1

treatment = "ctrl";
load("data_"+treatment+".mat",'area_limb','area_death')
opts = detectImportOptions("filename_"+treatment+".csv");
opts = setvartype(opts,'batchID',{'string'});
tbl = readtable("filename_"+treatment+".csv",opts);
tbl.lb_death = nan(height(tbl),1);
tbl.area_limb = area_limb;
tbl.area_death = area_death;
ctrl = tbl;
clearvars -except ua1 dfo zvad_fer1 ctrl

result = [ua1;dfo;zvad_fer1;ctrl];
pairs = readtable("pairs.xlsx");
clearvars -except result pairs

%% collect quantification result based on the pairs
area = nan(height(pairs),4);
for i = 1:height(pairs)
    prefix = extractBefore(pairs.ctrl_limb(i),"_c");
    idx = find(ismember(result.prefix,prefix));
    area(i,1) = result.area_limb(idx);

    prefix = extractBefore(pairs.ctrl_death(i),"_c");
    idx = find(ismember(result.prefix,prefix));
    area(i,2) = result.area_death(idx);

    prefix = extractBefore(pairs.exp_limb(i),"_c");
    idx = find(ismember(result.prefix,prefix));
    area(i,3) = result.area_limb(idx);

    prefix = extractBefore(pairs.exp_death(i),"_c");
    idx = find(ismember(result.prefix,prefix));
    area(i,4) = result.area_death(idx);
end
area(isnan(area)) = 0;
pairs.ratio_ctrl = area(:,2)./area(:,1);
pairs.ratio_exp = area(:,4)./area(:,3);


%% collect quantification result based on the treatment
pltTable = table(unique(pairs.treatment),'VariableNames',"treatment");
pltTable.label = ["Ctrl" "DFO" "Fer-1" "UA-1" "zVAD"]';
for i = 1:height(pltTable)
    idx = find(ismember(pairs.treatment,pltTable.treatment(i)));

    pltTable.yCtrl{i} = pairs.ratio_ctrl(idx);
    pltTable.xCtrl{i} = (rand(size(idx))-0.5)*0.1+1;
    pltTable.labCtrl{i} = pairs.ctrl_death(idx);
    pltTable.yExp{i} = pairs.ratio_exp(idx);
    pltTable.xExp{i} = (rand(size(idx))-0.5)*0.1+2;
    pltTable.labExp{i} = pairs.exp_death(idx);
end

%% get statisitic for each treatment
pltTable.iqrCtrl = cellfun(@(s)iqr(s),pltTable.yCtrl);
pltTable.iqrExp = cellfun(@(s)iqr(s),pltTable.yExp);
pltTable.q3Ctrl = cellfun(@(s)prctile(s,75),pltTable.yCtrl);
pltTable.q3Exp = cellfun(@(s)prctile(s,75),pltTable.yExp);

pltTable.meanCtrl = cellfun(@(s)mean(s),pltTable.yCtrl);
pltTable.meanExp = cellfun(@(s)mean(s),pltTable.yExp);
pltTable.stdCtrl = cellfun(@(s)std(s),pltTable.yCtrl);
pltTable.stdExp = cellfun(@(s)std(s),pltTable.yExp);

[pltTable.pVal,~,~] = cellfun(@(s,t)ranksum(s,t),pltTable.yCtrl,pltTable.yExp);

%% plot result
%%% white background
markerFaceColor1 = "w";
markerFaceColor2 = "w";
markerEdgeColor1 = "k";
markerEdgeColor2 = "r";
boxColor1 = "k";
boxColor2 = "r";
lineColor = "k";
bgColor = "w";

%%% black background
% markerFaceColor1 = "w";
% markerFaceColor2 = "c";
% markerEdgeColor1 = "k";
% markerEdgeColor2 = "k";
% boxColor1 = "w";
% boxColor2 = "c";
% lineColor = "w";
% bgColor = "k";



close all
for i = 1:height(pltTable)
    figure('Position',[680   558   320   420])
    hold on
    p1 = plot(pltTable.xCtrl{i},pltTable.yCtrl{i},...
        'o','MarkerFaceColor',markerFaceColor1,'MarkerEdgeColor',markerEdgeColor1);
    row = dataTipTextRow('label',strrep(pltTable.labCtrl{i},"_","\_"));
    p1.DataTipTemplate.DataTipRows(end+1) = row;

    p2 = plot(pltTable.xExp{i},pltTable.yExp{i},...
        'o','MarkerFaceColor',markerFaceColor2,'MarkerEdgeColor',markerEdgeColor2);
    row = dataTipTextRow('label',strrep(pltTable.labExp{i},"_","\_"));
    p2.DataTipTemplate.DataTipRows(end+1) = row;

    for j = 1:length(pltTable.yCtrl{i})
        p = plot([pltTable.xCtrl{i}(j) pltTable.xExp{i}(j)],...
            [pltTable.yCtrl{i}(j) pltTable.yExp{i}(j)],'-','Color',lineColor);
    end

    % % median and iqr
    % boxplot(pltTable.yCtrl{i},'Positions',0.85,'PlotStyle','compact','Symbol','','Colors',boxColor1)
    % boxplot(pltTable.yExp{i},'Positions',2.15,'PlotStyle','compact','Symbol','','Colors',boxColor2)
    % top1 = pltTable.q3Ctrl(i)+pltTable.iqrCtrl(i)*1.5;
    % top1 = min([top1,max(pltTable.yCtrl{i})]);
    % top2 = pltTable.q3Exp(i)+pltTable.iqrExp(i)*1.5;
    % top2 = min([top2,max(pltTable.yExp{i})]);
    % mean and 1sd
    errorbar(0.85,pltTable.meanCtrl(i),pltTable.stdCtrl(i),'ko','MarkerFaceColor','auto','LineWidth',2)
    errorbar(2.15,pltTable.meanExp(i),pltTable.stdExp(i),'ro','MarkerFaceColor','auto','LineWidth',2)
    top1 = pltTable.meanCtrl(i)+pltTable.stdCtrl(i);
    top2 = pltTable.meanExp(i)+pltTable.stdExp(i);

    plot([0.85 0.85 2.15 2.15],[top1+0.02 0.48 0.48 top2+0.02],'Color',lineColor)
    plot([1.5 1.5],[0.48 0.49],'Color',lineColor)

    hold off
    set(gca,'Children',circshift(get(gca,'Children'),2))
    set(gca,'FontSize',16,'TickDir','out','Layer','top','LineWidth',1,...
        'XColor',lineColor,'YColor',lineColor,'Color',bgColor)
    xticks([1 2])
    xticklabels(["Control" pltTable.label(i)])
    xlim([0.5 2.5])
    ylabel("Death area/Limb area")
    ylim([-0.01 0.51])

    box off

    text(1.5,0.5,"p="+sprintf("%1.2g",pltTable.pVal(i)),'Color',lineColor,...
        'HorizontalAlignment','center','FontSize',14)
    set(gcf,'Color',bgColor)
    % copygraphics(gcf,'ContentType','image','BackgroundColor','current')
    % exportgraphics(gcf,pltTable.label(i)+".pdf",'ContentType','vector')

    % if i>1
    %     tbl_source_1 = table(pltTable.xCtrl{i},pltTable.yCtrl{i},...
    %         'VariableNames',["x","Death area/limb area"]);
    %     tbl_source_1.Condition = repmat("Control",height(tbl_source_1),1);
    %     tbl_source_2 = table(pltTable.xExp{i},pltTable.yExp{i},...
    %         'VariableNames',["x","Death area/limb area"]);
    %     tbl_source_2.Condition = repmat(pltTable.label(i),height(tbl_source_2),1);
    %     tbl_source = [tbl_source_1;tbl_source_2];
    % 
    %     writetable(tbl_source,"../../../ftw_paper_figures_v2/source_data/fig5.xlsx","Sheet","f_"+pltTable.label(i))
    % end
end

%% Calculate the statistics for the ratio difference
ratiodiff = pairs.ratio_exp - pairs.ratio_ctrl;
grp = categorical(pairs.treatment);
treatments = unique(grp);
[B,BG,BC] = groupsummary(ratiodiff,grp,{'mean' 'std'});

% significance test and effect size
[~,~,stats] = kruskalwallis(ratiodiff,grp,"off");
% [~,~,stats] = anova1(diffR,grp,"off");
c = multcompare(stats,"Display","off");
ZOut = table(string(treatments(c(:,1))),string(treatments(c(:,2))),c(:,6));
ZOut.Properties.VariableNames = ["Treatment1" "Treatment2" "p-val"];
for i = 1:size(c,1)
    Effect = meanEffectSize(ratiodiff(grp==treatments(c(i,2))),...
        ratiodiff(grp==treatments(c(i,1))),"Effect","cohen");
    ZOut.cohenD(i) = Effect.Effect;
    ZOut.ConfidenceIntervals{i} = Effect.ConfidenceIntervals;
end

% empirical p-value
rng('default') 
m = arrayfun(@(s) bootstrp(10000,@mean,ratiodiff(grp==treatments(s))),1:length(treatments),'UniformOutput',0);
[fi,xi] = cellfun(@(s) ksdensity(s),m,'UniformOutput',0);
vq = interp1(xi{1},fi{1},B(:,1));
emp_pVal = nan(size(B(:,1)));
for i = 1:length(emp_pVal)
    if any(xi{1}<B(i,1))
        emp_pVal(i) = trapz([xi{1}(xi{1}<B(i,1)) B(i,1)],[fi{1}(xi{1}<B(i,1)) vq(i)]);
    end
end

%% plot the ratio difference and their statistics
close all
figure
swarmchart(grp,ratiodiff,'XJitter','rand','XJitterWidth',0.4)

hold on
errorbar(1:5,B(:,1),B(:,2),'ks','LineWidth',2,'MarkerFaceColor','k')
hold off

% hold on
% plot([1 1 2 2],[B(1,1)+B(1,2)+0.02 0.25 0.25 B(2,1)+B(2,2)+0.02],'k')
% plot([1.5 1.5],[0.25 0.26],'k')
% text(1.5,0.26,"p="+sprintf("%1.2g",c(1,6)),'FontSize',14,...
%     'HorizontalAlignment','center','VerticalAlignment','baseline')
% hold off
% 
% hold on
% plot([1 1 4 4],[0.25+0.02 0.3 0.3 B(4,1)+B(4,2)+0.02],'k')
% plot([2.5 2.5],[0.3 0.31],'k')
% text(2.5,0.31,"p="+sprintf("%1.2g",c(3,6)),'FontSize',14,...
%     'HorizontalAlignment','center','VerticalAlignment','baseline')
% hold off

ylabel("\DeltaRatio")
set(gca,'FontSize',16,'TickDir','out','Layer','top','LineWidth',1)
% xticklabels(["Ctrl" "DFO" "Fer-1" "UA-1" "zVAD"])

figure
plot(xi{1},fi{1},'LineWidth',1)

for i = 2:length(treatments)
    hold on
    plot([B(i,1) B(i,1)],[-0.01 3],'r')
    text(B(i,1),3,string(treatments(i))+", p="+sprintf("%1.2g",emp_pVal(i)),'Rotation',90)
    hold off
end
yline(0,'k--')
ylim([-1.0666   16.3040])
set(gca,'FontSize',16,'TickDir','out','Layer','top','LineWidth',1)
xlabel("mean(\DeltaRatio)")
title("A null distribution of mean(\DeltaRatio)")

% figure
% hold on
% p = arrayfun(@(s) plot(xi{s},fi{s},'LineWidth',1),1:length(treatments),'UniformOutput',0);
% hold off
% legend([p{:}],string(treatments))
% xlabel("mean(\DeltaRatio)")
% set(gca,'FontSize',16,'TickDir','out','Layer','top','LineWidth',1)

%%
% 
% close all
% figure('Position',[680   558   320   420])
% hold on
% 
% xCtrl = (rand(size(pData,1),1)-0.5)*0.1+1;
% p1 = plot(xCtrl,pData(:,1),'ko','MarkerFaceColor','w','MarkerEdgeColor','k');
% row = dataTipTextRow('label',strrep(pairs(idx,1),"_","\_"));
% p1.DataTipTemplate.DataTipRows(end+1) = row;
% 
% xFer1 = (rand(size(pData,1),1)-0.5)*0.1+2;
% p2 = plot(xFer1,pData(:,2),'o','Color','r','MarkerFaceColor','w','MarkerEdgeColor','r');
% row = dataTipTextRow('label',strrep(pairs(idx,2),"_","\_"));
% p2.DataTipTemplate.DataTipRows(end+1) = row;
% 
% for i = 1:size(pData,1)
%     p = plot([xCtrl(i) xFer1(i)],[pData(i,1) pData(i,2)],'k-');    
% end
% 
% % median and iqr
% boxplot(pData(:,1),'Positions',0.85,'PlotStyle','compact','Symbol','','Colors','k')
% boxplot(pData(:,2),'Positions',2.15,'PlotStyle','compact','Symbol','','Colors','r')
% % mean and 1sd
% % errorbar(0.85,mean(pData(:,1)),std(pData(:,1)),'ko','MarkerFaceColor','auto')
% % errorbar(2.15,mean(pData(:,2)),std(pData(:,2)),'ro','MarkerFaceColor','auto')
% 
% iqr1 = diff(prctile(pData(:,1),[25 75]));
% top1 = prctile(pData(:,1),75)+1.5*iqr1;
% top1 = min([top1,max(pData(:,1))]);
% % top1 = 0.3348;
% % top1 = mean(pData(:,1))+std(pData(:,1));
% 
% iqr2 = diff(prctile(pData(:,2),[25 75]));
% top2 = prctile(pData(:,2),75)+1.5*iqr2;
% top2 = min([top2,max(pData(:,2))]);
% % top2 = 0.15738;
% % top2 = mean(pData(:,2))+std(pData(:,2));
% 
% plot([0.85 0.85 2.15 2.15],[top1+0.02 0.38 0.38 top2+0.02],'k')
% plot([1.5 1.5],[0.38 0.39],'k')
% 
% % representative images
% % plot(xCtrl(12),pData(12,1),'ks','markersize',12)
% % plot(xFer1(12),pData(12,2),'rs','markersize',12)
% 
% hold off
% set(gca,'Children',circshift(get(gca,'Children'),2))
% set(gca,'FontSize',16,'TickDir','out','Layer','top','LineWidth',1)
% xticks([1 2])
% xticklabels(["Control" tLab])
% xlim([0.5 2.5])
% ylabel("Death area/Limb area")
% ylim([-0.01 0.41])
% 
% box off
% 
% p = signrank(pData(:,1),pData(:,2),'tail','both')
% p = ranksum(pData(:,1),pData(:,2))
% % p = anova1([pData(:,1);pData(:,2)],[ones(15,1);2.*ones(15,1)])
% text(1.5,0.4,"p="+sprintf("%1.2e",p),'HorizontalAlignment','center','FontSize',14)
% 
% copygraphics(gcf,'ContentType','image')
% % exportgraphics(gcf,"../result/ratio.pdf",'ContentType','vector')

