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

% sample = "main_control_xy4";
samples = ["main_control_xy4","main_long_xy11","main_short_xy9",...
    "supp_control_xy5","supp_control_xy7","supp_long_xy3",...
    "supp_long_xy1","supp_long_xy2","supp_short_xy1","supp_short_xy2",...
    "supp_long_xy10"];

pxSize = [0.921 0.921 0.921,...
    0.921 0.921 0.691,...
    0.691 0.691 0.691 0.921,...
    0.921];
grp = [1 2 3 1 1 2 2 2 3 3 2];

samples = samples([1 4 5 2 7 8 6 11]);
pxSize = pxSize([1 4 5 2 7 8 6 11]);
grp = grp([1 4 5 2 7 8 6 11]);

samples(6) = [];
pxSize(6) = [];
grp(6) = [];

samples = table(samples',grp',pxSize','VariableNames',["sample" "group" "pixelWidth"]);
samples = samples([1 2 3 4 6 7],:);
clearvars -except samples

samples.entropy = cellfun(@(s) load("result_"+s+".mat","entropy"),samples.sample,'UniformOutput',0);

% %%
% close all
% for j = 1:10
%     figure('WindowState','maximized')
%     tiledlayout(1,7,"TileSpacing","tight","Padding","tight")
%     for i = 1:height(samples)
%         img = samples.entropy{i}.entropy{j};
%         if ismember(i,[5 6])
%             img = imresize(img,2/3);
%         end
%         nexttile
%         imshow(img,[0 3.6],'border','tight')
%         colormap turbo
%         title(strrep(samples.sample(i),'_','\_'))
%     end
%     sgtitle((j*10)+"\mum")
%     % exportgraphics(gcf,(j*10)+"um.png","ContentType","image")
%     close all
% end

%%

samples.entropy = cellfun(@(s) s.entropy{3},samples.entropy,'UniformOutput',0);
for i = 1:height(samples)
    bf = load(samples.sample(i)+"_orientation_const.mat");
    bf = bf.res;
    bf = max(bf,[],3);
    bf = ~isnan(bf);
    test = samples.entropy{i};
    samples.entropy{i} = test(bf);
end

% 
% for i = length(samples)
%     sample = samples(i);
%     load("result_"+sample+".mat","entropy")
%     for j = 1%:length(entropy)
%         figure
%         imshow(entropy{j},[1.69 4.05])
%         % imshow(entropy{j},[0 3.6])
%         colormap turbo
%         title(j)
%     end
% end
% 
% %%
% load('result_main_control_xy4.mat')
% 
% round(30/0.921)
% x = 1285;
% y = 682;
% temp = angle_set(y-16:y+16,x-16:x+16);
% temp = vertcat(temp{:});
% p = histcounts(temp(:,1),linspace((-90),(90),91),'Normalization','probability');
% sum(-1.*p(p~=0).*log(p(p~=0)))
% histogram(temp(:,1),'BinEdges',linspace((-90),(90),91),'Normalization','probability')
% 
% fiber = tiffreadVolume("../img/main_control_xy4_binary_fiber.tif");
% orientation = tiffreadVolume("../img/main_control_xy4_binary_fiber_orientation.tif");
% 
% fiber_mip = max(fiber,[],3);
% figure;imshow(fiber_mip)
% h = drawrectangle('Position',[x-16,y-16,32,32]);
% 
% % orientation_mip = max(orientation,[],3,"omitmissing");
% % orientation_mip(fiber_mip==0) = nan;
% % figure;imshow(orientation_mip,[-90 90])
% % colormap hsv
% % h = drawrectangle('Position',[x-16,y-16,32,32]);

% %%
% load('result_supp_long_xy10.mat')
% 
% round(30/0.921)
% x = 1148;
% y = 958;
% temp = angle_set(y-16:y+16,x-16:x+16);
% temp = vertcat(temp{:});
% p = histcounts(temp(:,1),linspace((-90),(90),91),'Normalization','probability');
% sum(-1.*p(p~=0).*log(p(p~=0)))
% histogram(temp(:,1),'BinEdges',linspace((-90),(90),91),'Normalization','probability')

%%
ub = max(cellfun(@(s)max(s(:)),samples.entropy))
lb = max(cellfun(@(s)min(s(:)),samples.entropy))

% export entropy heatmap
% cellfun(@(s,t) imwrite((s-lb)/ub,"../img/"+t+"_entropy.tif"),samples.entropy,samples.sample)

% data statistics
samples.entropy_mean = cellfun(@(s)mean(s(~isnan(s)&s~=0)),samples.entropy);
samples.entropy_std = cellfun(@(s)std(s(~isnan(s)&s~=0)),samples.entropy);
samples.entropy_q1 = cellfun(@(s)prctile(s(~isnan(s)&s~=0),25),samples.entropy);
samples.entropy_median = cellfun(@(s)median(s(~isnan(s)&s~=0)),samples.entropy);
samples.entropy_q3 = cellfun(@(s)prctile(s(~isnan(s)&s~=0),75),samples.entropy);
samples.entropy_iqr = cellfun(@(s)iqr(s(~isnan(s)&s~=0)),samples.entropy);
samples.entropy_prctile = cellfun(@(s)prctile(s(~isnan(s)&s~=0),1:100),samples.entropy,'UniformOutput',0);

% statistical test
data = cellfun(@(s)s(~isnan(s)&s~=0),samples.entropy,'UniformOutput',0);
grp = arrayfun(@(s)s.*ones(size(data{s})),1:height(samples),'UniformOutput',0)';
grp_pooled = arrayfun(@(s)samples.group(s).*ones(size(data{s})),1:height(samples),'UniformOutput',0)';
data = vertcat(data{:});
grp = vertcat(grp{:});
grp_pooled = vertcat(grp_pooled{:});
[p,tbl,stats] = kruskalwallis(data,grp,"off");
c = multcompare(stats,"Display","on");

%%
s1 = samples.entropy{1};
s1 = s1(~isnan(s1)&s1~=0);
s2 = samples.entropy{2};
s2 = s2(~isnan(s2)&s2~=0);
[h,p,ks2stat] = kstest2(s1,s2);

%%
% boxplot
% boxplot(data,grp,"Symbol",' ')
close all

figure
hold on
for i = 1:height(samples)
    b = boxchart(grp(grp==i),data(grp==i),'MarkerStyle','none');
    if samples.group(i)==1
        b.BoxFaceColor = [0    0.4470    0.7410];
    else
        b.BoxFaceColor = [0.8500    0.3250    0.0980];
    end
end
hold off
set(gca,'Layer','top','LineWidth',1,'TickDir','out','FontSize',16)
axis padded
ylabel("Entropy")
xticks(1:height(samples))
ylimit = ylim;

% errorbar
figure
for i = 1:height(samples)
    hold on
    if samples.group(i)==1
        errorbar(i,samples.entropy_mean(i),samples.entropy_std(i),'s','Color',[0    0.4470    0.7410],'LineWidth',1)
    else
        errorbar(i,samples.entropy_mean(i),samples.entropy_std(i),'s','Color',[0.8500    0.3250    0.0980],'LineWidth',1)
    end
    hold off
end
% errorbar(1:8,samples.entropy_mean,samples.entropy_std,'s')
set(gca,'Layer','top','LineWidth',1,'TickDir','out','FontSize',16)
axis padded
ylabel("Entropy")
xticks(1:height(samples))
ylim(ylimit)

% swarmchart
color_grp = lines(2);
figure
for i = 1:height(samples)
    hold on
    swarmchart(grp(grp==i),data(grp==i),[],color_grp(samples.group(i),:),'.','XJitterWidth',0.6)
    hold off
end
set(gca,'Layer','top','LineWidth',1,'TickDir','out','FontSize',16)
axis padded
ylabel("Entropy")
xticks(1:height(samples))

% prctile
color_grp = lines(2);
figure
for i = 1:height(samples)
    hold on
    plot(1:100,samples.entropy_prctile{i},'Color',color_grp(samples.group(i),:))
    hold off
end
set(gca,'Layer','top','LineWidth',1,'TickDir','out','FontSize',16)
axis padded
ylabel("Entropy")
xlabel("prctile")
% xticks(1:8)

% histogram
color_grp = lines(2);
figure
for i = 1:height(samples)
    nexttile
    hold on
    histogram(data(grp==i),'Normalization','probability',...
        'FaceColor',color_grp(samples.group(i),:),'FaceAlpha',0.3,...
        'EdgeColor','none','BinWidth',0.1)
    hold off
    % ylim([-0.0018 0.12])
% end
set(gca,'Layer','top','LineWidth',1,'TickDir','out','FontSize',16)
% axis padded
ylabel("probability")
xlabel("Entropy")
end

% close all; histogram(data(grp==1),'BinWidth',0.1); xlabel("Entropy")
% close all; imshow(samples.entropy{1},[0 3.6]); colormap turbo
% close all; imshow(samples.entropy{1}>=1.3 & samples.entropy{1}<1.4);
% bf = load("main_control_xy4_orientation_const.mat");
% bf = bf.res;
% bf = max(bf,[],3);
% bf = ~isnan(bf);
% close all; imshow(bf);
% test = samples.entropy{1};
% test = test(bf);
% close all; histogram(test,'BinWidth',0.1); xlabel("Entropy")
%% pooled
close all

B = groupsummary(data,grp_pooled,{'mean','std'});

figure
hold on
for i = 1:2
    b = boxchart(grp_pooled(grp_pooled==i),data(grp_pooled==i),'MarkerStyle','none');
    if i==1
        b.BoxFaceColor = [0    0.4470    0.7410];
    else
        b.BoxFaceColor = [0.8500    0.3250    0.0980];
    end
end
hold off
set(gca,'Layer','top','LineWidth',1,'TickDir','out','FontSize',16)
axis padded
ylabel("Entropy")
xticks(1:height(samples))
ylimit = ylim;
xlimit = xlim;

% errorbar
figure
for i = 1:2
    hold on
    if i==1
        errorbar(i,B(i,1),B(i,2),'s','Color',[0    0.4470    0.7410],'LineWidth',1)
    else
        errorbar(i,B(i,1),B(i,2),'s','Color',[0.8500    0.3250    0.0980],'LineWidth',1)
    end
    hold off
end
% errorbar(1:8,samples.entropy_mean,samples.entropy_std,'s')
set(gca,'Layer','top','LineWidth',1,'TickDir','out','FontSize',16)
axis padded
ylabel("Entropy")
xticks(1:2)
ylim(ylimit)
xlim(xlimit)

% swarmchart
color_grp = lines(2);
figure
for i = 1:2
    hold on
    swarmchart(grp_pooled(grp_pooled==i),data(grp_pooled==i),[],color_grp(i,:),'.','XJitterWidth',0.6)
    hold off
end
set(gca,'Layer','top','LineWidth',1,'TickDir','out','FontSize',16)
axis padded
ylabel("Entropy")
xticks(1:2)
ylim(ylimit)
xlim(xlimit)

% prctile
color_grp = lines(2);
figure
for i = 1:2
    hold on
    plot(1:100,prctile(data(grp_pooled==i),1:100),'Color',color_grp(i,:))
    hold off
end
set(gca,'Layer','top','LineWidth',1,'TickDir','out','FontSize',16)
axis padded
ylabel("Entropy")
xlabel("prctile")
ylim(ylimit)
% xticks(1:8)

% histogram
% data_tru = data;
% data_tru(data_tru<1) = nan;
color_grp = lines(2);
color_grp = [0 0 0;1 0 0];
source = [];
close all
for binSize = [0.1];
    figure
    for i = 1:2
        hold on
        h = histogram(data(grp_pooled==i),'binwidth',binSize,'Normalization','probability',...
            'FaceColor',color_grp(i,:),...
            'EdgeColor','w');
        hold off
        xline(median(data(grp_pooled==i)),'b')
        source = [source;h.BinEdges(1:end-1)'+h.BinWidth/2,h.Values'*100,i.*ones(length(h.Values),1)];
        % ylim([-0.0018 0.025])
    end
    set(gca,'Layer','top','LineWidth',1,'TickDir','out','FontSize',16)
    % axis padded
    ylabel("probability")
    xlabel("Entropy")
    xlim([-0.2368 4])
    legend(["Control" "UAMC-3203"],'Location','best')
end
ylim([0 0.1441])
% exportgraphics(gcf,'pooled_entropy.pdf','ContentType','vector')
% tbl_source = table(source(:,1),source(:,2),source(:,3),...
%     'VariableNames',["Entropy","Frequency ","Condition"]);
% tmp = ["Control" "UAMC-3203"];
% tbl_source.Condition = tmp(tbl_source.Condition)';
% writetable(tbl_source,"../../../ftw_paper_figures_v2/source_data/figS20.xlsx","Sheet","b")

[h,p] = kstest2(data(grp_pooled==1),data(grp_pooled==2))
[p,tbl,stat] = kruskalwallis(data,grp_pooled)

%% export entropy as tiff
% for i = 7%1:height(samples)
%     t = Tiff("../img/"+samples.sample(i)+"_entropy_30um.tif","w");
%     tmp = samples.entropy{i};
%     numrows = size(tmp,1);
%     numcols = size(tmp,2);
%     setTag(t,"Photometric",Tiff.Photometric.LinearRaw);
%     setTag(t,"Compression",Tiff.Compression.None)
%     setTag(t,"BitsPerSample",32)
%     setTag(t,"SamplesPerPixel",1)
%     setTag(t,"SampleFormat",3);
%     setTag(t,"ImageLength",numrows)
%     setTag(t,"ImageWidth",numcols)
% 
%     write(t,single(tmp))
%     close(t)
% end