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

era = 10;
D = 2.9744; % Difusion rate (um^2/min)
h = 5;%sqrt(25.*scale); % distance between cells (um)
parameters = struct('D',D,'h',h,'kf',1.2,...
    'nNOX',3,'KNOX',1,'kg',1.5,'c',0.1,...
    'nGSH',3,'KGSH',2,'kd',0.26,'nI',0,'nCell',201,'tStart',0,...
    'tFinal',300,'delay',30,'kdd',0.5,'S',10*era/(3+era));

% determine steady states
syms f(x) kb kf kd kg k_nox n_nox k_gsh n_gsh s c
f(x) = c-1*kd*x+kf*(x^n_nox/(x^n_nox+k_nox^n_nox))-...
    x*(1/(1+s))*kg*(k_gsh^n_gsh/(x^n_gsh+k_gsh^n_gsh));
fx = subs(f,{kf kd kg k_nox n_nox k_gsh n_gsh s c},...
    {parameters.kf,parameters.kd,parameters.kg,...
    parameters.KNOX,parameters.nNOX,parameters.KGSH,parameters.nGSH,...
    parameters.S,parameters.c});
SS = double(vpasolve(fx,x,[0 Inf]));

parameters.y0 = min(SS)*ones(parameters.nCell^2,1);
mask = zeros(parameters.nCell);
mask(1:13,:) = 1;
parameters.idx_center = find(mask); 

if length(SS)==1
    parameters.y0(parameters.idx_center) = 2.5862;
    parameters.death_threshold = 3.5456;
else
    parameters.y0(parameters.idx_center) = 0.5*SS(2)+0.5*SS(3);
    parameters.death_threshold = 0.9*max(SS);
end

parameters.ROS_boundary = 0*[1 1 1 1];

% simulation
tic
fcn_1([],[])
options = odeset('Refine',4,'NonNegative',1:length(parameters.y0));
sol = ode45(@(t,y) mos2D(t,y,parameters),...
    [parameters.tStart parameters.tFinal], parameters.y0, options);
[idx_Dead,time_Dead] = fcn_2;
toc

%% plot simulated wave
r = 0:parameters.nCell-1;
nphi = parameters.nCell-2;
delta_phi = 2*pi/nphi;
phi = [];
phi(1) = 0;
for j = 2:nphi+2
    phi(j) = phi(1) + (j-1)*delta_phi;
end
[Phi,R] = meshgrid(phi,r);

% snapshot at a specific time (5hr)
y = deval(sol,300);
Z = reshape(y,parameters.nCell,[]);  % T1 .* Phi./Phi;
figure
h = surf(R.*cos(Phi), R.*sin(Phi), Z,'EdgeColor','none');
set(gca,'view',[0   90.0000])
grid off
axis equal
xlim(89.*[-1 1])
ylim(89.*[-1 1])
shading interp;
set(gca,'BoxStyle','full','Layer','top','LineWidth',1,'XTick',[],'YTick',[],'Box','on')

load("custom_parula_v3.mat")
CustomColormap(1:2,:) = repmat([0 0 0],2,1);
J = CustomColormap(2:end,:);
colormap(J)
shading interp;

cbr = colorbar;
cbr.Ticks = 0:4;
cbr.FontSize = 16;
cbr.LineWidth = 1;
cbr.Label.String = 'ROS (A.U.)';

%% 2D model
function dmdt = mos2D(t,y,parameters)

N = parameters.nCell^2;
D = parameters.D;
h = parameters.h;
kd = parameters.kd*ones(N,1);

S = parameters.S;
kf = parameters.kf*ones(N,1); % positive feedback strength (h^-1)
kg = parameters.kg*ones(N,1); % positive feedback strength (h^-1)
n_nox = parameters.nNOX*ones(N,1);
n_gsh = parameters.nGSH*ones(N,1);
K_nox = parameters.KNOX*ones(N,1); % Dissociation constant in Hill equation
K_gsh = parameters.KGSH*ones(N,1); % Dissociation constant in Hill equation

c = parameters.c*ones(N,1);

global idx_Dead time_Dead

% to remove undead cells when time jumps backward
if ~isempty(time_Dead)
    idx_Dead(time_Dead(:,2)>t) = [];
    time_Dead(time_Dead(:,2)>t,:) = [];
end

idx_passingTh = find(y-parameters.death_threshold>0);
idx_Dead_new = setdiff(idx_passingTh,idx_Dead);
idx_Dead = [idx_Dead,idx_Dead_new'];

if numel(idx_Dead)>=1
    time_Dead = [time_Dead;idx_Dead_new,t.*ones(length(idx_Dead_new),1)];
    
    idx = find(time_Dead(:,2)+parameters.delay<t);
    if ~isempty(idx)
        kf(time_Dead(idx,1)) = 0;
        kg(time_Dead(idx,1)) = 0;
        kd(time_Dead(idx,1)) = parameters.kdd.*kd(time_Dead(idx,1));
        c(time_Dead(idx,1)) = 0;
    end
end
% polar
y = reshape(y,parameters.nCell,[]); % row is radius, col is angle
nr = size(y,1)-1;
delta_r = h;
for i = 1:nr
    r(i) = 0+(i-1)*delta_r;
end

nphi = size(y,2)-2;
delta_phi = 2*pi/nphi;

dmdt = nan(size(y));
for j = 1:nphi+2
    for i = 1:nr-1
        ind = sub2ind(size(y),i,j);
        
        if i==1
            dmdt(i,j) = (D/delta_r^2)*(y(i+1,j)-y(i,j))+...
                c(ind) + (kf(ind)*y(i,j)^n_nox(ind))/(y(i,j)^n_nox(ind)+K_nox(ind)^n_nox(ind)) -...
                y(i,j)*(1/(1+S))*kg(ind)*(K_gsh(ind)^n_gsh(ind)/(y(i,j)^n_gsh(ind)+K_gsh(ind)^n_gsh(ind))) -...
                kd(ind)*y(i,j);
        elseif j==1
            dmdt(i,j) = D*((1/delta_r^2)*(y(i-1,j)-2*y(i,j)+y(i+1,j))+...
                (1/r(i))*(1/(2*delta_r))*(y(i+1,j)-y(i-1,j))+...
                (1/r(i)^2)*(1/delta_phi^2)*(y(i,nphi+1)-2*y(i,j)+y(i,j+1)))+...
                c(ind) + (kf(ind)*y(i,j)^n_nox(ind))/(y(i,j)^n_nox(ind)+K_nox(ind)^n_nox(ind)) -...
                y(i,j)*(1/(1+S))*kg(ind)*(K_gsh(ind)^n_gsh(ind)/(y(i,j)^n_gsh(ind)+K_gsh(ind)^n_gsh(ind))) -...
                kd(ind)*y(i,j);
        elseif j==nphi+2
            dmdt(i,j) = D*((1/delta_r^2)*(y(i-1,j)-2*y(i,j)+y(i+1,j))+...
                (1/r(i))*(1/(2*delta_r))*(y(i+1,j)-y(i-1,j))+...
                (1/r(i)^2)*(1/delta_phi^2)*(y(i,j-1)-2*y(i,j)+y(i,2)))+...
                c(ind) + (kf(ind)*y(i,j)^n_nox(ind))/(y(i,j)^n_nox(ind)+K_nox(ind)^n_nox(ind)) -...
                y(i,j)*(1/(1+S))*kg(ind)*(K_gsh(ind)^n_gsh(ind)/(y(i,j)^n_gsh(ind)+K_gsh(ind)^n_gsh(ind))) -...
                kd(ind)*y(i,j);
        else
            dmdt(i,j) = D*((1/delta_r^2)*(y(i-1,j)-2*y(i,j)+y(i+1,j))+...
                (1/r(i))*(1/(2*delta_r))*(y(i+1,j)-y(i-1,j))+...
                (1/r(i)^2)*(1/delta_phi^2)*(y(i,j-1)-2*y(i,j)+y(i,j+1)))+...
                c(ind) + (kf(ind)*y(i,j)^n_nox(ind))/(y(i,j)^n_nox(ind)+K_nox(ind)^n_nox(ind)) -...
                y(i,j)*(1/(1+S))*kg(ind)*(K_gsh(ind)^n_gsh(ind)/(y(i,j)^n_gsh(ind)+K_gsh(ind)^n_gsh(ind))) -...
                kd(ind)*y(i,j);
        end
    end
end
dmdt(isnan(dmdt)) = 0;
dmdt = dmdt(:);
end

function fcn_1(x,y)
global idx_Dead time_Dead
idx_Dead = x;
time_Dead = y;
end

function [x,y] = fcn_2()
global idx_Dead time_Dead
x = idx_Dead;
y = time_Dead;
end