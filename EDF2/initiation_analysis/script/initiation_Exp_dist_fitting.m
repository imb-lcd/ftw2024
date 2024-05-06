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

load("..\data\initiations_for_prob_dist_fitting.mat")

number_initiation_per_position = sum(occurrence,2);
mean_inititaion = mean(number_initiation_per_position);
lambda = mean_inititaion; % parameter for a Poisson distribution
mu = 6/lambda; % parameter for an Exponential distribution
phat = 1-exp(-1/mu); % parameter for a Geometric distribution

%%% get interval
data = occurrence';

data = data(:); % join all the occurrence into a long time series
test = diff(find(data)); % interval between initiation
test2 = data(data~=0); % number of initiation
count = nan(size(test));
for j = 1:length(test)
    count(j) = test2(j)*test2(j+1); % count for the interval
end
count0 = 0; % conunt for interval = 0
for j = 1:length(test2)
    if test2(j)>1
        count0 = count0 + nchoosek(test2(j),2);
    end
end
interval = repelem([0;test],[count0;count]);
mu = mean(interval); % parameter for an Exponential distribution
phat = 1-exp(-1/mu); % parameter for a Geometric distribution

%%% kstest compared to exponential distribution
rng(0)
% random_data = random('Exponential',mu,length(interval),1);
random_data = random('Exponential',mu,100,1);
% random_data = floor(random_data);
[h,p] = kstest2(interval,random_data);
if h==0
    disp("cannot reject null hypothesis (p-value="+p+")")
else
    disp("reject null hypothesis (p-value="+p+")")
end

%%% kstest compared to geometric distribution
rng(0)
random_data = random('Geometric',phat,100,1);
[h,p] = kstest2(interval,random_data);
if h==0
    disp("cannot reject null hypothesis (p-value="+p+")")
else
    disp("reject null hypothesis (p-value="+p+")")
end

%%%
rng(0)
rdata1 = random('Exponential',mu,100,1);
rng(0)
rdata2 = random('Geometric',phat,100,1);
[h,p] = kstest2(rdata1,rdata2);

%%% chi2 test compared to exponential distribution
%%% const width
pd = makedist('Exponential','mu',mu);
gap = 1:max(interval);
p = nan(size(gap));
ngrp = p;
for m = 1:length(gap)
    edges = 0:gap(m):ceil(max(interval)/gap(m))*gap(m);    
    exp_freq = diff(pd.cdf(edges))*numel(interval);
    [obs_freq,~] = histcounts(interval,edges);
    chi_stat = sum((obs_freq-exp_freq).^2./exp_freq);
    dof = length(obs_freq)-1-1;
    p(m) = 1-chi2cdf(chi_stat,dof);
    ngrp(m) = length(obs_freq);
end
figure;plot(ngrp,p,'.-');yline(0.05)
ylabel("p-value")
xlabel("#classes, const width")
if any(p>0.05)
    [~,I] = max(p);
    figure;plot(0:0.1:ceil(max(interval)/gap(I))*gap(I),pd.pdf(0:0.1:ceil(max(interval)/gap(I))*gap(I)))
    xline(0:gap(I):ceil(max(interval)/gap(I))*gap(I))
end

%%% chi2 test compared to geometric distribution
%%% const width
gap = 1:max(interval);
p = nan(size(gap));
ngrp = p;
for m = 1:length(gap)
    edges = 0:gap(m):ceil(max(interval)/gap(m))*gap(m);    
    exp_freq = diff(geocdf(edges,phat))*numel(interval);
    [obs_freq,~] = histcounts(interval,edges);
    chi_stat = sum((obs_freq-exp_freq).^2./exp_freq);
    dof = length(obs_freq)-1-1;
    p(m) = 1-chi2cdf(chi_stat,dof);
    ngrp(m) = length(obs_freq);
end
figure;plot(ngrp,p,'.-');yline(0.05)
ylabel("p-value")
xlabel("#classes, const width")
if any(p>0.05)
    [~,I] = max(p);
    figure;plot(0:0.1:ceil(max(interval)/gap(I))*gap(I),pd.pdf(0:0.1:ceil(max(interval)/gap(I))*gap(I)))
    xline(0:gap(I):ceil(max(interval)/gap(I))*gap(I))
end

%% plot result
close all
figure
hold on
h = histogram(interval,'Normalization','pdf','EdgeColor','w','BinWidth',4);
ctrs = h.BinEdges(1:end-1)+h.BinWidth/2;
ydata = h.Values;

yhat = geopdf(ctrs,phat);
plot(ctrs,yhat,'r','LineWidth',3);

hold off

axis padded
set(gca,'Layer','top','LineWidth',1,'FontSize',16,'TickDir','out')
xlabel("Interval between initiaitons")
ylabel("PDF")
legend(["Observed" "Geometric distribution fit"],...
    'Box','off','Location','northeast')

% tbl_source = table([ctrs';ctrs'],[ydata';yhat'],repelem(["Observed" "Fitting"],length(ctrs))');
% tbl_source.Properties.VariableNames = ["Interval between initiaitons","PDF","Condition"];
% writetable(tbl_source,"../../../ftw_paper_figures_v2/source_data/figS2.xlsx","Sheet","d")