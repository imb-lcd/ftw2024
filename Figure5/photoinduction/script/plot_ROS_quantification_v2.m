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

load("../data/induction_site_ROS.mat")

% get statistics
medianROS = [cellfun(@(s)median(s),induction_site.t0,'UniformOutput',0),...
    cellfun(@(s)median(s),induction_site.t1,'UniformOutput',0),...
    cellfun(@(s)median(s),induction_site.t2,'UniformOutput',0),...
    cellfun(@(s)median(s),induction_site.t3,'UniformOutput',0)];
% medianROS2 = cellfun(@(s)median(double(s)),induction_site.t0,'UniformOutput',0);
% medianRatio = cellfun(@(s) double(s(1))/double(s(2)),medianROS);
medianOxidized = cellfun(@(s) double(s(1)),medianROS);
medianReducedPre = cellfun(@(s) double(s(2)),medianROS);
medianReducedPre = medianReducedPre(:,1);
medianRatio = medianOxidized./repmat(medianReducedPre,1,4);

% total intensity
totalROS = [cellfun(@(s)sum(s),induction_site.t0,'UniformOutput',0),...
    cellfun(@(s)sum(s),induction_site.t1,'UniformOutput',0),...
    cellfun(@(s)sum(s),induction_site.t2,'UniformOutput',0),...
    cellfun(@(s)sum(s),induction_site.t3,'UniformOutput',0)];
totOxidized = cellfun(@(s) double(s(1)),totalROS);
totReducedPre = cellfun(@(s) double(s(2)),totalROS);
totReducedPre = totReducedPre(:,1);
totRatio = totOxidized./repmat(totReducedPre,1,4);

% mean intensity
meanROS = [cellfun(@(s)mean(double(s)),induction_site.t0,'UniformOutput',0),...
    cellfun(@(s)mean(double(s)),induction_site.t1,'UniformOutput',0),...
    cellfun(@(s)mean(double(s)),induction_site.t2,'UniformOutput',0),...
    cellfun(@(s)mean(double(s)),induction_site.t3,'UniformOutput',0)];
meanOxidized = cellfun(@(s) double(s(1)),meanROS);
meanReducedPre = cellfun(@(s) double(s(2)),meanROS);
meanRatio = meanOxidized./(meanOxidized+meanReducedPre);
% meanReducedPre = meanReducedPre(:,1);
% meanRatio = meanOxidized./repmat(meanReducedPre,1,4);

% signal = medianRatio; climit = [0 1.1]; sLabel = "median ratio";
% signal = medianOxidized; climit = [200 3500]; sLabel = "median oxidized lipid";
% signal = totRatio; climit = [0 1.1]; sLabel = "total ratio";
signal = meanRatio; climit = [0 1.1]; sLabel = "mean ratio";
signal = meanRatio; climit = [0 0.55]; sLabel = "mean ratio";

% 1 pixel is 0.691 um
scale = 0.691;

% rotate the limb
[coeff,score,latent] = pca([induction_site.x,induction_site.y]);
figure
plot(score(:,1),score(:,2),'ro')
set(gca,'ydir','reverse')
xlabel("pixel")
ylabel("pixel")

%% plot the quantification result
% close all
figure('position',[673     2   420   980])
for i = 1:4
    nexttile
    scatter(score(:,1).*scale,score(:,2).*scale,[],signal(:,i),'filled')
    
    hold on; plot(0,0,'ko'); hold off % origin

    clim
    clim(climit)
    title("Time = "+(i-1))
    c = colorbar;
    c.Label.String = sLabel;
    set(gca,'ydir','reverse')
    xlim([-700 750])
    
    if i == size(signal,2)
        xlabel("Distance (μm)")
    end
end
% copygraphics(gcf,"ContentType","image")

% center of induction sites
xc = mean(induction_site.x);
yc = mean(induction_site.y);

% slope of principal axes
slope1 = coeff(2,1)/coeff(1,1);
slope2 = coeff(2,2)/coeff(1,2);

% lines for defining central and lateral regions
% center (< 100 μm)
offset_y = 100/scale*sin(atan(slope1));
offset_x = 100/scale*cos(atan(slope1));
x1 = xc+offset_x;
y1 = yc+offset_y;
region_line{1} = [0 2049;slope2.*([0 2049]-x1)+y1]; %
x1 = xc-offset_x;
y1 = yc-offset_y;
region_line{2} = [0 2049;slope2.*([0 2049]-x1)+y1]; %

% lateral (≥ 350 μm)
offset_y = 350/scale*sin(atan(slope1));
offset_x = 350/scale*cos(atan(slope1));
x1 = xc+offset_x;
y1 = yc+offset_y;
region_line{3} = [0 2049;slope2.*([0 2049]-x1)+y1]; %
x1 = xc-offset_x;
y1 = yc-offset_y;
region_line{4} = [0 2049;slope2.*([0 2049]-x1)+y1]; %

% line along the 1st principal axis to indicate the central and lateral
% regions
tmp_line = [0 2049;slope1.*([0 2049]-xc)+yc+750];

[xi,yi] = polyxpoly(tmp_line(1,:),tmp_line(2,:),...
    region_line{1}(1,:),region_line{1}(2,:));
[xj,yj] = polyxpoly(tmp_line(1,:),tmp_line(2,:),...
    region_line{2}(1,:),region_line{2}(2,:));
region_line{5} = [xi xj;yi yj]; % central

[xi,yi] = polyxpoly(tmp_line(1,:),tmp_line(2,:),...
    region_line{3}(1,:),region_line{3}(2,:));
[xj,yj] = polyxpoly(tmp_line(1,:),tmp_line(2,:),...
    region_line{4}(1,:),region_line{4}(2,:));
region_line{6} = [xi region_line{5}(1,:) xj;yi region_line{5}(2,:) yj]; 
region_line{6} = [region_line{6}(:,[1 2]) nan(2,1) region_line{6}(:,[3 4])]; % middle

region_line{7} = tmp_line; % lateral
region_line{7} = [region_line{7}(:,1) region_line{6}(:,end) nan(2,1),...
    region_line{6}(:,1) region_line{7}(:,end)]; 

region_line{8} = [-1000 2049;slope2.*([-1000 2049]-xc)+yc+2900];
region_line{9} = [0 3049;slope2.*([0 3049]-xc)+yc-3200];
region_line{10} = [-1000 2049;slope1.*([-1000 2049]-xc)+yc-700];
region_line{11} = [0 3049;slope1.*([0 3049]-xc)+yc+750];
% hold on; plot((region_line{8}(1,:)-xc).*scale,(region_line{8}(2,:)-yc).*scale,'m--','LineWidth',1)

[x1,y1] = polyxpoly(region_line{11}(1,:),region_line{11}(2,:),...
    region_line{8}(1,:),region_line{8}(2,:));
[x2,y2] = polyxpoly(region_line{11}(1,:),region_line{11}(2,:),...
    region_line{4}(1,:),region_line{4}(2,:));
[x3,y3] = polyxpoly(region_line{10}(1,:),region_line{10}(2,:),...
    region_line{4}(1,:),region_line{4}(2,:));
[x4,y4] = polyxpoly(region_line{10}(1,:),region_line{10}(2,:),...
    region_line{8}(1,:),region_line{8}(2,:));
pgon{1} = [x1 x2 x3 x4;y1 y2 y3 y4];

[x1,y1] = polyxpoly(region_line{11}(1,:),region_line{11}(2,:),...
    region_line{3}(1,:),region_line{3}(2,:));
[x2,y2] = polyxpoly(region_line{11}(1,:),region_line{11}(2,:),...
    region_line{9}(1,:),region_line{9}(2,:));
[x3,y3] = polyxpoly(region_line{10}(1,:),region_line{10}(2,:),...
    region_line{9}(1,:),region_line{9}(2,:));
[x4,y4] = polyxpoly(region_line{10}(1,:),region_line{10}(2,:),...
    region_line{3}(1,:),region_line{3}(2,:));
pgon{2} = [x1 x2 x3 x4;y1 y2 y3 y4];

[x1,y1] = polyxpoly(region_line{11}(1,:),region_line{11}(2,:),...
    region_line{2}(1,:),region_line{2}(2,:));
[x2,y2] = polyxpoly(region_line{11}(1,:),region_line{11}(2,:),...
    region_line{1}(1,:),region_line{1}(2,:));
[x3,y3] = polyxpoly(region_line{10}(1,:),region_line{10}(2,:),...
    region_line{1}(1,:),region_line{1}(2,:));
[x4,y4] = polyxpoly(region_line{10}(1,:),region_line{10}(2,:),...
    region_line{2}(1,:),region_line{2}(2,:));
pgon{3} = [x1 x2 x3 x4;y1 y2 y3 y4];

% center at (1024,1024)
xc = 1024;
yc = 1024;

figure('Position',[911   368   880   420])
tiledlayout(1,2,'TileSpacing','tight')
nexttile
scatter((induction_site.x-xc).*scale,(induction_site.y-yc).*scale,[],signal(:,1),'filled')
set(gca,'ydir','reverse')
axis square
xlim(([1 2048]-xc).*scale)
ylim(([1 2048]-yc).*scale)
clim(climit)

hold on
% plot((region_line{1}(1,:)-xc).*scale,(region_line{1}(2,:)-yc).*scale,'m--','LineWidth',1)
% plot((region_line{2}(1,:)-xc).*scale,(region_line{2}(2,:)-yc).*scale,'m--','LineWidth',1)
% plot((region_line{3}(1,:)-xc).*scale,(region_line{3}(2,:)-yc).*scale,'m--','LineWidth',1)
% plot((region_line{4}(1,:)-xc).*scale,(region_line{4}(2,:)-yc).*scale,'m--','LineWidth',1)
% plot((region_line{5}(1,:)-xc).*scale,(region_line{5}(2,:)-yc).*scale,'LineWidth',5,'Color',[1 0 0 0.3])
% plot((region_line{6}(1,:)-xc).*scale,(region_line{6}(2,:)-yc).*scale,'LineWidth',5,'Color',[0 0 1 0.3])
% plot((region_line{7}(1,:)-xc).*scale,(region_line{7}(2,:)-yc).*scale,'LineWidth',5,'Color',[0 0 0 0.3])

p1 = plot(polyshape((pgon{3}(1,:)-xc).*scale,(pgon{3}(2,:)-yc).*scale),'EdgeColor','none','FaceColor',[1 0 0],'FaceAlpha',0.2);
p2 = plot(polyshape((pgon{1}(1,:)-xc).*scale,(pgon{1}(2,:)-yc).*scale),'EdgeColor','none','FaceColor',[0 0 0],'FaceAlpha',0.2);
plot(polyshape((pgon{2}(1,:)-xc).*scale,(pgon{2}(2,:)-yc).*scale),'EdgeColor','none','FaceColor',[0 0 0],'FaceAlpha',0.2);

hold off
set(gca,'Children',circshift(get(gca,'Children'),1))
set(gca,'ydir','reverse','Layer','top','LineWidth',1,'FontSize',16,'TickDir','out')
yticks([-500 0 500])
title("Before photoinduction")
xlabel("Distance (μm)")
ylabel("Distance (μm)")
legend([p1 p2],["Center" "Edge"],'FontSize',12,'Location','southeast')
% exportgraphics(gcf,"../result/before_photoinduction.pdf",'ContentType','vector')
source = [(induction_site.x-xc).*scale,(induction_site.y-yc).*scale,signal(:,1)];
% plot((x-xc-1457).*scale,(y-yc-3492).*scale,'m','LineWidth',1)

nexttile
scatter((induction_site.x-xc).*scale,(induction_site.y-yc).*scale,[],signal(:,3),'filled')
hold on
p1 = plot(polyshape((pgon{3}(1,:)-xc).*scale,(pgon{3}(2,:)-yc).*scale),'EdgeColor','none','FaceColor',[1 0 0],'FaceAlpha',0.2);
p2 = plot(polyshape((pgon{1}(1,:)-xc).*scale,(pgon{1}(2,:)-yc).*scale),'EdgeColor','none','FaceColor',[0 0 0],'FaceAlpha',0.2);
plot(polyshape((pgon{2}(1,:)-xc).*scale,(pgon{2}(2,:)-yc).*scale),'EdgeColor','none','FaceColor',[0 0 0],'FaceAlpha',0.2);
hold off
set(gca,'Children',circshift(get(gca,'Children'),1))
set(gca,'ydir','reverse','Layer','top','LineWidth',1,'FontSize',16,'TickDir','out')
axis square
xlim(([1 2048]-xc).*scale)
ylim(([1 2048]-yc).*scale)
clim(climit)
set(gca,'ydir','reverse','Layer','top','LineWidth',1,'FontSize',16,'TickDir','out','YTickLabel',[])
yticks([-500 0 500])
title("After photoinduction (12 min)")
xlabel("Distance (μm)")
% ylabel("Distance (μm)")
% exportgraphics(gcf,"../result/after_photoinduction.pdf",'ContentType','vector')
cbr = colorbar; 
cbr.Label.String = sLabel;
cbr.LineWidth = 1;
% exportgraphics(gcf,"../result/photoinduction_20231230.pdf",'ContentType','vector')
source = [source;(induction_site.x-xc).*scale,(induction_site.y-yc).*scale,signal(:,3)];
tbl_source = table(source(:,1),source(:,2),source(:,3),repelem(["before" "after"],135)');
tbl_source.Properties.VariableNames = ["x" "y" "Oxidized C11-B/C11-B","Condition"]
% writetable(tbl_source,"fig5.xlsx","Sheet","h")

%% plot the quantification result (project to x-axis)
figure('position',[673     2   420   980])
Y = discretize(score(:,1).*scale,-650:50:700); % bin the photoinduction sites based on their x-coordiantes
B = cell(1,size(signal,2));
for i = 1:4    
    [B{i},BG,BC] = groupsummary(signal(:,i),Y,"mean");

    nexttile
    plot(score(:,1).*scale,signal(:,i),'.','MarkerSize',10)
    ylim(climit)
    title("Time = "+(i-1))
    ylabel(sLabel)
    xlim([-700 750])

    hold on
    plot(-625:50:700,movmean(B{i},7),'.-','LineWidth',1)
    hold off
    if i == size(signal,2)
        xlabel("Distance (μm)")
    end
end

figure
colororder(turbo(6))
hold on
for i = 1:numel(B)
    plot(-625:50:700,movmean(B{i},7),'.-','LineWidth',1)
end
hold off
xlabel("Distance (μm)")
xlim([-700 750])
ylabel("moving average of "+sLabel)
legend("Time = "+(0:(i-1)))

%% plot the ROS dynamics by groupped photoinduction sites
% close all
% group photoinduction sites based on their distance to the x-center
grp = discretize(abs(score(:,1).*scale),0:50:700);
nGrp = length(unique(grp));
color_grp = flipud(turbo(nGrp));

figure
for i = 1:nGrp
    nexttile
    plot([0 1 2 3],signal(grp==i,:)','o-',...
        'color',[color_grp(i,:) 0.3],...
        'MarkerFaceColor',color_grp(i,:),'MarkerEdgeColor','w','LineWidth',1)
    xlim([-0.3 3.3])
    xticks([0 1 2 3])
    ylabel(sLabel)
    xlabel("Time")
    title("distance \geq "+(i-1)*50+" and < "+(i)*50+"μm")
    ylim(climit)    
    
    [i nnz((signal(grp==i,4)-signal(grp==i,3))./signal(grp==i,3)<-0.5)/nnz(grp==i)]
end

% further group photoinduction sites based on their dynamic patterns
Y = discretize(abs(score(:,1).*scale),[0 100 350 700]);
nGrp = length(unique(Y));
color_grp = fliplr(["k" "b" "r"]); %
offset_grp = linspace(0,1,nGrp+2)-0.5;

figure
hold on
p = cell(nGrp,1);
for j = 1:nGrp
    x = signal(Y==j,:);
    if ~isempty(x)
        plot(offset_grp(j+1)+(0:3)+0.05,median(x),color_grp(j))
        boxplot(x,'PlotStyle','compact','Positions',offset_grp(j+1)+(0:3)+0.05,...
            'Symbol','','Colors',color_grp(j),'Labels',repelem({' '},4)) %

        xJitter = 0.05.*(rand(size(x,1),1)-0.5);
        xPos = repmat(0:3,size(x,1),1)+offset_grp(j+1)-0.05;%+repmat(xJitter,1,size(x,2));
        %             p{j} = plot(xPos(:),x(:),'o','MarkerFaceColor',color_grp(j),'MarkerEdgeColor','w','MarkerSize',4);
        p{j} = swarmchart(xPos(:),double(x(:)),24,color_grp(j),'o',"filled",...
            "XJitter","rand","XJitterWidth",0.05,'MarkerEdgeColor','w');
    end
end
hold off
xticks(0:3)
xticklabels(string(0:3))
xlabel('Time')
ylabel(sLabel)
%     legend([p{:}],["Edge (4-6)" "Other (7-11)" "Central (12-15)"],...
%         'Location','best','fontsize',12)
legend([p{:}],["Center (< 100μm)" "Other" "Edge (\geq 350μm)"],...
    'Location','best','fontsize',12)
set(gca,'Layer','top','TickDir','out','FontSize',16,'LineWidth',1)

% median, q1, q3
% mx = arrayfun(@(i) groupsummary(signal(:,i),Y,"median"),1:4,'UniformOutput',0);
% mx = horzcat(mx{:});
% q1x = arrayfun(@(i) groupsummary(signal(:,i),Y,{@(x)prctile(x,25)}),1:4,'UniformOutput',0);
% q1x = horzcat(q1x{:});
% q3x = arrayfun(@(i) groupsummary(signal(:,i),Y,{@(x)prctile(x,75)}),1:4,'UniformOutput',0);
% q3x = horzcat(q3x{:});
% pgon = arrayfun(@(i) polyshape([0:3 3:-1:0],[q1x(i,:) fliplr(q3x(i,:))]),1:3,'UniformOutput',0);

% mean, tsd
mx = arrayfun(@(i) groupsummary(signal(:,i),Y,"mean"),1:4,'UniformOutput',0);
mx = horzcat(mx{:});
sx = arrayfun(@(i) groupsummary(signal(:,i),Y,"std"),1:4,'UniformOutput',0);
sx = horzcat(sx{:});

time_stamp = [0 0.28 12.18 17.65];
time_stamp = [0 1 2 3];
pgon = arrayfun(@(i) polyshape([time_stamp fliplr(time_stamp)],...
    [mx(i,:)-sx(i,:) fliplr(mx(i,:)+sx(i,:))]),1:3,'UniformOutput',0);



% figure('Position',[317         558        1280         420])
% tiledlayout(1,3,'TileSpacing','compact')

figure
p = cell(nGrp,1);
for j = [1 nGrp]

%     nexttile
    hold on
    plot(pgon{j},'EdgeColor','none','FaceColor',color_grp(j),'FaceAlpha',0.2)
    % p{j} = plot(time_stamp,mx(j,:),color_grp(j),'Marker','o','MarkerEdgeColor','w','MarkerFaceColor',color_grp(j))
    p{j} = plot(time_stamp,mx(j,:),color_grp(j),'LineWidth',1)
    hold off
    ylim([0    1.6])
    ylim([0 0.7])
%     xlim([-1 19])
    xlim([-0.3 3.3])
    xlabel('')
    if j==1
        ylabel(sLabel)
    else
%         set(gca,'YTickLabel',[]);
    end
    set(gca,'Layer','top','TickDir','out','FontSize',16,'LineWidth',1)
end
% legend([p{:}],["Center (<100μm)" "Other" "Edge (≥350μm)"],...
%     'Location','best','fontsize',12)
% legend([p{:}],["Center (<100μm)" "Edge (≥350μm)"],...
%     'Location','best','fontsize',12)
legend([p{:}],["Central" "Lateral"],...
    'Location','best','fontsize',12)
ylabel("Oxidized C11-B/C11-B")
xticklabels(["before" "1 min" "12 min" "17 min"])
% exportgraphics(gcf,"../result/dynamics_20231231.pdf",'ContentType','vector')

tbl_source = table([time_stamp,time_stamp]',[mx(1,:),mx(3,:)]',repelem(["Central","Lateral"],4)');
tmp = ["before" "1 min" "12 min" "17 min"];
tbl_source.Var1 = tmp(tbl_source.Var1+1)';
tbl_source.Properties.VariableNames = ["Time points","Oxidized C11-B/C11-B","Condition"];
% writetable(tbl_source,"fig5.xlsx","Sheet","i")

%% test significance
% p = ranksum(signal(Y==1,3),signal(Y==1,4))
% p = ranksum(signal(Y==1,3),signal(Y==3,3))
% p = ranksum(signal(Y==1,2),signal(Y==3,2))
% p = ranksum(signal(Y==1,1),signal(Y==2,1))
% 
% [p,tbl,stats] = kruskalwallis(signal(:,4),Y)
% c = multcompare(stats)
% 
% x = signal(Y==3,:);
% group = repmat([1 2 3 4],size(x,1),1);
% [p,tbl,stats] = kruskalwallis(x(:),group(:));
% c = multcompare(stats)

g1 = repmat(Y,1,4);
g2 = repmat([1 2 3 4],135,1);
[G,ID1,ID2] = findgroups(g1(:),g2(:))
x = signal;
[p,tbl,stats] = kruskalwallis(x(:),G);
c = multcompare(stats)