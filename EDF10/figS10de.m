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

conc_era = log10([0.31;0.63;1.25;2.5;5;10]);

speed_model = [0;0;3.0312;4.9104;6.3816;7.7842]; % D=2.97, h=5 

figure
hold on
plot(conc_era,speed_model,'s--',...
    'markersize',16,'color','k','LineWidth',1)
hold off
xticks(log10([0.31 0.63 1.25 2.5 5 10]))
xticklabels(string([0.31 0.63 1.25 2.5 5 10]))
set(gca,'fontsize',16,'xscale','linear','TickDir','out','LineWidth',1,'Layer','top')
xlim(log10([0.2 15]))
ylim([-0.8 8.8])

box off
axis square
xlabel('Erastin (µM)')
ylabel('Speed (µm/min)')
tbl_source = table([0.31;0.63;1.25;2.5;5;10],[0;0;3.0312;4.9104;6.3816;7.7842],...
    'VariableNames',["Erastin (µM)" "Speed (µm/min)"]);
% writetable(tbl_source,"figS15.xlsx","Sheet","d")

%%
width_model = [0;0;9;13;16;19].*21;
amp_model = [0;0;4.3913;4.5875;4.6867;4.7369];

conc_era = log10([0.31;0.63;1.25;2.5;5;10]);

figure

% width, simulated
plot(conc_era,width_model,'s--',...
    'markersize',16,'color','k','LineWidth',1)
ylabel('Wave front width (µm)'); 
ylim([-40 440])

% amp, simulated
% plot(conc_era,amp_model,'s--',...
%     'markersize',16,'color','k','LineWidth',1)
% ylabel('Wave front amplitude (A.U.)');
% ylim([-0.4 5.4])

hold off
set(gca,'fontsize',16,'xscale','linear','TickDir','out','LineWidth',1)
xlim(log10([0.2 15]))
xticks(log10([0.31 0.63 1.25 2.5 5 10]))
xticklabels(string([0.31 0.63 1.25 2.5 5 10]))
% ylim([-0.01 0.115])
box off
axis square
xlabel('Erastin (µM)')

figure

% amp, simulated
plot(conc_era,amp_model,'s--',...
    'markersize',16,'color','k','LineWidth',1)
ylabel('Wave front amplitude (A.U.)');
ylim([-0.4 5.4])

hold off
set(gca,'fontsize',16,'xscale','linear','TickDir','out','LineWidth',1)
xlim(log10([0.2 15]))
xticks(log10([0.31 0.63 1.25 2.5 5 10]))
xticklabels(string([0.31 0.63 1.25 2.5 5 10]))
% ylim([-0.01 0.115])
box off
axis square
xlabel('Erastin (µM)')

% exportgraphics(gcf,".\simulated_amp.pdf",'ContentType','vector')
tbl_source = table([0.31;0.63;1.25;2.5;5;10],[0;0;9;13;16;19].*21,...
    'VariableNames',["Erastin (µM)" "Wave front width (µm)"]);
% writetable(tbl_source,"figS15.xlsx","Sheet","e_width")
tbl_source = table([0.31;0.63;1.25;2.5;5;10],[0;0;4.3913;4.5875;4.6867;4.7369],...
    'VariableNames',["Erastin (µM)" "Wave front amplitude (AU)"]);
% writetable(tbl_source,"figS15.xlsx","Sheet","e_amplitude")