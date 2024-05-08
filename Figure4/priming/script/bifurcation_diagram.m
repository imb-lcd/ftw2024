%% initialize environment
clc; clear; close all

%% set parameters
%%% input
era = [0 0.15 0.3 0.6 1.25 2.5 5 10];
s = 10.*era./(3+era);
s = [s,3:0.05:9.9,0.003:0.001:3];
s = unique(s);

%%% parameter of interest (gap of parameteres > 1e-4)
para = [3 2 1]; name_para = "nNOX"; formal_name = "n_{positive_{fb}}";

%%% all combinations of selected input strengths and parameters
[S,Para] = meshgrid(s,para);
LSS = nan(size(S));
USS = LSS;
HSS = LSS;

%%% original parameter setting
% parameters = struct('D',D,'h',h,'kf',1.2,...
%     'nNOX',3,'KNOX',1,'kg',1.5,'c',0.1,...
%     'nGSH',3,'KGSH',2,'kd',0.26,'nI',0,'nCell',201,'tStart',0,...
%     'tFinal',300,'delay',30,'kdd',0.5,'S',10*era(end)/(3+era(end)));

%%% calculate steady states
tic
parfor i = 1:numel(LSS)
    parameters = struct('kf',1.2,...
    'nNOX',3,'KNOX',1,'kg',1.5,'c',0.1,...
    'nGSH',3,'KGSH',2,'kd',0.26,'nI',0,'nCell',201,'tStart',0,...
    'tFinal',300,'delay',30,'kdd',0.5,'S',S(i));
    parameters.(name_para) = Para(i);

    tmp = calculate_steady_states(parameters);
    if ~isempty(tmp)
    LSS(i) = min(tmp);    
    HSS(i) = max(tmp);
    USS(i) = tmp(min([length(tmp),2]));
    end
end
toc

% get number of steady state at each erastin and parameter setting
nSS = 3.*ones(size(LSS));
nSS((HSS-LSS)<1e-4) = 1;

LSS(nSS==1&LSS>1) = nan;
USS(nSS==1) = nan;
HSS(nSS==1&LSS<1) = nan;

E = 3.*S./(10-S);

%% bifurcation diagram
close all
for ta = para
    figure

    isUsed = abs(Para(:)-ta)<1e-4;
    x = E(isUsed);
    y = Para(isUsed);
    z1 = LSS(isUsed);
    z2 = USS(isUsed);
    z3 = HSS(isUsed);
    X = [x;flipud(x);x];
    Y = [y;flipud(y);y];
    Z = [z1;flipud(z2);z3];
    isUsed = ~isnan(Z);

    X = X(isUsed);
    Y = Y(isUsed);
    Z = Z(isUsed);
    
    p1 = plot3(X,Y,Z,'LineWidth',2,'Color',[(ta~=3) 0 0]);

    set(gca,'XScale','log','View',[0 0],'ZScale','linear',...
        'YScale','linear','FontSize',16,'LineWidth',1,'FontName','Arial','TickDir','out')
    axis padded
    zlim([-0.3 8])
    xlim([0.007 500])
    xlabel("Erastin (μM)")
    zlabel("ROS steady state (A.U.)")
    legend(formal_name+" = "+ta,'Location','best')
    exportgraphics(gcf,name_para+".pdf","ContentType","vector","Append",(ta~=3))
end
