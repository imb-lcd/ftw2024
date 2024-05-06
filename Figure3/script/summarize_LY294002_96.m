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

%% prepare the filename to be analyzed
wells = 1:96;
wells = reshape(wells,12,[])';
wells(2,:) = fliplr(wells(2,:));
wells(4,:) = fliplr(wells(4,:));
wells(6,:) = fliplr(wells(6,:));
wells(8,:) = fliplr(wells(8,:));
wells = wells(:);

conc = [100 50 25 12.5 6.25 100/32 100/64 100/128 100/256 100/512 100/1024 0]; % 25/8192 is 0
level = 1:length(conc);
conc = repmat(conc,6,1);
conc = [conc;100/2048.*ones(2,3),100/4096*ones(2,3),100/8192.*ones(2,3),50/8192.*ones(2,3)];
conc = conc(:);

level = fliplr(level);
level(1:end-1) = level(1:end-1)+4;
level = repmat(level,6,1);
level = [level;5.*ones(2,3),4*ones(2,3),3.*ones(2,3),2.*ones(2,3)];
level = level(:);

fname = "kymograph_cy5_LY294002_96_s"+(1:96)+"_c1_ff10.mat";
frame1_treat = 5.*ones(size(fname));

frame_interval = 1; % hr
scale = 1.266; % um

%% organize the measured speed
speeds = nan(length(wells),1);
angle = speeds;
pct = speeds;
frame_strt = speeds;
frame_stop = speeds;
for i = 1:length(wells)
    load("..\data\"+fname(wells(i)))
    speeds(i) = abs(kymograph{5}{1}(1))/3600;
    
    load("..\data\"+strrep(fname(wells(i)),"kymograph_cy5","setting"))
    angle(i) = speed.rotation_angle;
    pct(i) = speed.cy5.pct;
    frame_strt(i) = speed.cy5.frame_strt;
    frame_stop(i) = speed.cy5.frame_stop;

end

result = table(wells,conc,level,speeds,angle,pct,frame_strt,frame_stop);

%% fit a curve for the dose-speed relationship
y = result.speeds.*60;%(result.isoutlier==0);
well = result.wells;%(result.isoutlier==0);
x = result.conc;
isUsed = true(size(x));
isUsed(ismember(result.level,[3,4,6,7,8,10])) = false;
x = x(isUsed);
y = y(isUsed);
well = well(isUsed);

F = @(z,xdata) z(1) +  (z(2)-z(1)).*(z(3)./(z(3)+xdata));
z0 = [0,1,25];

[z,resnorm,residual,exitflag,output,lambda,jacobian] = lsqcurvefit(F,z0,x,y);
ci = nlparci(z,residual,'jacobian',jacobian);

fx = 0:min(abs(diff(unique(x)))):max(x);
[ypred,delta] = nlpredci(F,fx,z,-1.*residual,'Jacobian',jacobian,'alpha',0.05);
lower = ypred - delta;
upper = ypred + delta;
xq = 10.^(linspace(log10(min(unique(x(x>0)))),log10(max(unique(x(x>0)))),101));
lower = interp1(fx,lower,xq,'spline');
upper = interp1(fx,upper,xq,'spline');
ypred = interp1(fx,ypred,xq,'spline');
fx = xq;

%% plot dose-response curve
close all
figure('position',[1020 500 420 420])
t = tiledlayout(1,34,'TileSpacing','tight');
bgAx = axes(t,'XTick',[],'YTick',[],'Box','off');
axis square
bgAx.Layout.TileSpan = [1 34];

ax1 = axes(t);
ax1.Layout.Tile = 1;
ax1.Layout.TileSpan = [1 5];
p = plot(x(x==0),y(x==0),'o','color',[59, 73, 146]/255,'MarkerFaceColor','none');
row = dataTipTextRow('Well',well(x==0));
p.DataTipTemplate.DataTipRows(end+1) = row;
set(ax1,'fontsize',16,'YLim',[0 6.5],'LineWidth',1,'XTick',0,'XTickLabel',0,'Box','off','XLim',[-0.1 0.1])

ax2 = axes(t);
ax2.Layout.Tile = 6;
ax2.Layout.TileSpan = [1 34-ax2.Layout.Tile+1];
ax2.YAxis.Visible = 'off';
set(ax2,'Box','off','XScale','log','XLim',[0.005 200],'YLim',[0 6.5],'FontSize',16,...
    'LineWidth',1,'XTick',10.^(-2:2),'XTickLabel',10.^(-2:2),'XTickLabelRotation',0)
hold on
patch([fx,fliplr(fx)],[lower,fliplr(upper)],[.6 .6 .6],'facecolor',[.9 .9 .9],'edgecolor','none')
plot(fx,ypred,'k--','LineWidth',1)
plot(fx,[lower;upper],'LineWidth',1,'color',[.6 .6 .6])
p = plot(x(x>0),y(x>0),'o','color',[59, 73, 146]/255,'MarkerFaceColor','none');
row = dataTipTextRow('Well',well(x>0));
p.DataTipTemplate.DataTipRows(end+1) = row;
hold off

% Link the axes
linkaxes([ax1 ax2], 'y')
set(bgAx,'Color','w','XColor','none')
xlabel(t,"LY294002 (µM)",'fontsize',16)
ylabel(t,"Speed (µm/min)",'fontsize',16)

text(0.01,2,'$$y=y_0+(y_M-y_0)\frac{K}{K+x}$$',"Interpreter","latex")
text(0.01,1.5,sprintf('$$y_0=%.3f\\pm%.3f$$',z(1),z(1)-ci(1,1)),"Interpreter","latex")
text(0.01,1,sprintf('$$y_M=%.3f\\pm%.3f$$',z(2),z(2)-ci(2,1)),"Interpreter","latex")
text(0.01,0.5,sprintf('$$K=%.3f\\pm%.3f$$',z(3),z(3)-ci(3,1)),"Interpreter","latex")