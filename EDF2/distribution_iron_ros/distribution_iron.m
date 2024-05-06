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

load("quantification_iron.mat")

tbl = tbl_cell;
tbl = sortrows(tbl,"era");

% remove outliers
[G,ID] = findgroups(tbl.era);
tbl.x = G;
y = false(height(tbl),1);
for i = 1:length(ID)
    tmp = tbl.mean_intensity(G==i);
    y(G==i) = isoutlier(tmp);
end
tbl(y==1,:) = [];

cellcount = tabulate(tbl.era);

era = [0 0.15 0.3 0.6 1.25 2.5 5 10];

%% fit to all available distribution
era = [0 0.15 0.3 0.6 1.25 2.5 5 10];
f = 38;
distname = {'BirnbaumSaunders',...
'Burr',...
'Exponential',...
'Extreme Value',...
'Gamma',...
'Generalized Extreme Value',...
'Half Normal',...
'InverseGaussian',...
'Logistic',...
'Loglogistic',...
'Lognormal',...
'Nakagami',...
'Normal',...
'Poisson',...
'Rayleigh',...
'Rician',...
'tLocationScale',...
'Weibull'};

X2 = nan(length(distname),length(era));
h = X2;
p = X2;
ks2stat = X2;

for j = 1:length(era)
    X = tbl.mean_intensity(tbl.era==era(j))./mean(tbl.mean_intensity(tbl.era==era(1)));
    for i = 1:length(distname)
        % fit data to a distribution
        pd = fitdist(X,distname{i});
        % k-s test
        rng('default') % For reproducibility
        R = random(pd,size(X));
        [h(i,j),p(i,j),ks2stat(i,j)] = kstest2(X,R);
    end
end

%%
C = nchoosek(1:length(distname),2);
D = nan(length(distname));
for i = 1:size(C,1)
    a = C(i,1);
    b = C(i,2);
    tmpa = sum(ks2stat(a,:)<ks2stat(b,:));
    tmpb = sum(ks2stat(b,:)<ks2stat(a,:));
    if tmpa>tmpb
        D(a,b) = 1;
        D(b,a) = 0;
    elseif tmpa<tmpb
        D(a,b) = 0;
        D(b,a) = 1;
    else
        D(a,b) = 0.5;
        D(b,a) = 0.5;
    end
end

%% check the goodness-of-fit for distributions
close all
figure('position',[673     2   779   994])
imagesc(ks2stat,'AlphaData',h==0)
set(gca,'color',0*[1 1 1]);
yticks(1:length(distname))
yticklabels(distname)
xticks(1:8)
xticklabels(string(era))
title("Test statistics of KS-test")
xlabel("Erastin (\muM)")
ylabel("Distribution name")
colorbar
set(gca,'layer','top','fontsize',16,'LineWidth',1,'TickDir','out')

[m,I]=sort(sum(D==1,2));
I = flipud(I);

c = turbo(size(ks2stat,1));
figure('position',[673     2   994 574])
hold on
for i = 1:length(I)
    
    y = ks2stat(I(i),:);
    x = i+0.3.*(rand(size(y))-0.5);
    scatter(x,y,[],c(i,:),'.')
    errorbar(i,mean(y),std(y),'o','Color',c(i,:),'LineWidth',2)
end
hold off
xticks(1:length(distname))
xticklabels(distname(I))
ylabel("Test statistics of KS-test")
set(gca,'layer','top','fontsize',16,'LineWidth',1,'TickDir','out')

figure('position',[673     2   779   994])
xvalues = string(era);
yvalues = distname;
heatmap(xvalues,yvalues,ks2stat,"Title","Test statistics of KS-test",...
    'XLabel',"Erastin (\muM)",'YLabel',"Distribution name",'FontSize',16)

%% plot histogram and fitted distribution
close all
mu = nan(size(era));
sigma = mu;
k = mu;
binwidth = 0.2;
for i = 8%:length(era)
    X = tbl.mean_intensity(tbl.era==era(i));
    
    nexttile
    h = histogram(X,'Normalization','pdf','EdgeColor','w');
    title("Iron distribution ([Era]="+era(i)+")")
    xlabel("Iron right before photoinduction")
    ylabel("PDF")
    set(gca,'layer','top','fontsize',16,'LineWidth',1,'TickDir','out')

    pd = fitdist(X,'Logistic');
    mu(i) = pd.mu;
    sigma(i) = pd.sigma;
    x_values = min(X):0.01:max(X);
    y = pdf(pd,x_values);

    hold on
    plot(x_values,y,'LineWidth',2)
    hold off

end

axis padded
% exportgraphics(gcf,'iron_distribution.pdf','ContentType','vector')

tbl_source = table([h.BinEdges(1:end-1)'+h.BinWidth/2;x_values'],[h.Values';y'],repelem(["Observed" "Fitting"],[length(h.Values) length(y)])');
tbl_source.Properties.VariableNames = ["Cellular iron level (AU)","PDF","Condition"];
% writetable(tbl_source,"../../ftw_paper_figures_v2/source_data/figS2.xlsx","Sheet","e")
