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

%%% kstest
rng(0)
random_data = random('Poisson',lambda,100,1);
[h,p] = kstest2(number_initiation_per_position,random_data);
if h==0
    disp("cannot reject null hypothesis (p-value="+p+")")
else
    disp("reject null hypothesis (p-value="+p+")")
end

tbl = tabulate(number_initiation_per_position);
grp = 0:5; % combine 5 and 6
obs_freq = [tbl(1:5,2);sum(tbl(6:7,2))];

pd = makedist('Poisson','lambda',lambda);
exp_freq = [pd.pdf(0:4)*sum(tbl(:,2)),sum(tbl(:,2))*(1-sum(pd.pdf(0:4)))]';
chi_stat = sum((obs_freq-exp_freq).^2./exp_freq);
dof = numel(grp)-1-1;
p = 1-chi2cdf(chi_stat,dof);
if p>0.05
    disp("cannot reject null hypothesis (p-value="+p+")")
else
    disp("reject null hypothesis (p-value="+p+")")
end

%% plot result
close all
figure
hold on
h = histogram(number_initiation_per_position,'Normalization','pdf','EdgeColor','w');
ctrs = h.BinEdges(1:end-1)+h.BinWidth/2;
yhat = pd.pdf(ctrs);
ydata = h.Values;
plot(ctrs,yhat,'r','LineWidth',3);
hold off

axis padded
set(gca,'Layer','top','LineWidth',1,'FontSize',16,'TickDir','out','FontName','Arial')
xlabel("Number of initiations")
ylabel("PDF")
legend(["Observed" "Poisson distribution fit"],'Box','off','Location','northeast')
% exportgraphics(gcf,'../nI_Poisson.pdf','ContentType','vector')

tbl_source = table([ctrs';ctrs'],[ydata';yhat'],repelem(["Observed" "Fitting"],length(ctrs))');
tbl_source.Properties.VariableNames = ["Number of initiations","PDF","Condition"];
% writetable(tbl_source,"../../../ftw_paper_figures_v2/source_data/figS2.xlsx","Sheet","c")