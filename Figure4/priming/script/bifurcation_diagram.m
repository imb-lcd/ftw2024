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

load("..\data\bifurcation_diagram.mat")

% bistability regime
pgon = polyshape([stimulus2era([bp_left bp_right bp_right bp_left bp_left])],[-0.1 -0.1 6.1 6.1 -0.1]);

% steady state
xx = [stimulus2era(x(~isnan(LSS)));flipud(stimulus2era(x(~isnan(USS))));stimulus2era(x(~isnan(HSS)))];
yy = [LSS(~isnan(LSS));flipud(USS(~isnan(USS)));HSS(~isnan(HSS))];

% intersection points at erastin = 2.5uM
[xB,yB] = polyxpoly(xx,yy,[2.5 2.5],[-0.1 5.1]);

close all
figure
hold on
plot(pgon,'EdgeColor','none','FaceColor',[240 217 65]/255,'FaceAlpha',0.2)
plot(stimulus2era(x(~isnan(LSS))),LSS(~isnan(LSS)),'k','LineWidth',1)
plot(stimulus2era(x(~isnan(USS))),USS(~isnan(USS)),'k--','LineWidth',1)
plot(stimulus2era(x(~isnan(HSS))),HSS(~isnan(HSS)),'k','LineWidth',1)
plot(xB(1),yB(1),'o','MarkerEdgeColor','k','MarkerFaceColor',[112 180 255]/255)
plot(xB(2),yB(2),'o','MarkerEdgeColor','k','MarkerFaceColor','w')
plot(xB(3),yB(3),'o','MarkerEdgeColor','k','MarkerFaceColor',[255 242 0]/255)
hold off
set(gca,'xscale','log','fontsize',16,'yscale','linear','layer','top','linewidth',1)
xline(2.5,'k-')

xticks([0.1 1 10 100])
xlim([0.0459 100])
ylim([-0.1 6.1])
box on
xlabel('Erastin (µM)')
ylabel('ROS (A.U.)')

box off