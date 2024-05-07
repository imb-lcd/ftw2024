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

%% wavelength, plate map
wells = reshape(1:84,12,[])';
wells(2,:) = fliplr(wells(2,:));
wells(4,:) = fliplr(wells(4,:));
wells(6,:) = fliplr(wells(6,:));
wells = wells(:);

trf = repmat(repelem([1.6 1.3 0.6],4),7,1);
trf = trf(:);

light = repmat(["cy5" "mcherry" "tritc" "yfp" "fitc" "cfp" "dapi"]',1,12);
light = light(:);
wavelength = repmat([646 587 550 509 495 434 358]',1,12);
wavelength = wavelength(:);

platemap = table(trf,light,wavelength,wells);
platemap = sortrows(platemap,["trf","wavelength"]);
[G,ID] = findgroups(platemap(:,[1 2]));

%% wavelength, speed
list = dir("..\data\kymograph_Wavelength10X_s*.mat");
tbl = [];
for i = 1:length(list)
    well = extractBetween(list(i).name,"_s",".mat");
    well = str2double(well{1});
    result = nan(8,2);

    load(fullfile(list(i).folder,list(i).name))
    for j = 1:height(kymograph)
        if ~isempty(kymograph.speed{j})
            speed = kymograph.speed{j}{1}(1)/3600;

            if diff(kymograph.frame_range{j})>=2
                result(kymograph.index_angle(j),kymograph.index_img(j)) = speed;
            end
        end
    end
    result = [result,(0:45:359)'];
    result(sum(isnan(result),2)>0,:) = [];
    result = [result,abs(result(:,1)-result(:,2))];
    result = [well.*ones(size(result,1),1),result];
    result = array2table(result,'VariableNames',["well" "cy5" "ros" "angle" "diff"]);
    result(result.diff>0.01,:) = [];

    tbl = [tbl;result];
end
speed = tbl;
clearvars -except platemap G ID speed

% all available speed measurement
platemap.speed = arrayfun(@(x)[speed.cy5(speed.well==x) speed.angle(speed.well==x)],...
    platemap.wells,'UniformOutput',0);

clearvars -except platemap G ID

%% wavelength, ros
list = dir("..\data\Wavelength20X_s*.csv");
tbl = [];
for i = 1:length(list)
    well = extractBetween(list(i).name,"_s",".csv");
    well = str2double(well{1});
    
    result = readtable(fullfile(list(i).folder,list(i).name));
    tbl(:,well) = result.Mean1;
end

for i = 1:height(platemap)
    platemap.ros{i} = tbl(:,platemap.wells(i))';
end

%% ros
close all
trf = 0.6;%[0.6 1.3 1.6];
color_wavelength = turbo(8);
color_wavelength(8,:) = [];
color_wavelength = flipud(color_wavelength);
% figure('Position',[319         495        1200         420])
% tiledlayout(1,length(trf),'TileSpacing','compact','Padding','tight')
frame_stop = 5;
for i = 1:length(trf)
    tmp = platemap(platemap.trf==trf(i),:);

    wavelength = [646 587 550 509 495 434 358];
    x = [];
    y = [];
    for j = 1:height(tmp)
        if ~isempty(tmp.ros{j})
            y = [y;tmp.ros{j}(1:frame_stop)];
            x = [x;tmp.wavelength(j)];
        end
    end
    [r,c] = find(wavelength==x);
    [~,I] = sort(r);
    c = c(I);
    y = y-repmat(y(:,1),1,size(y,2));

end

tbl_source = array2table([repmat(x,5,1),repelem((0:15:60)',28,1),y(:)]);
tbl_source.Properties.VariableNames = ["Wavelength (nm)","Time (min)","ROS"];
% writetable(tbl_source,"figS3.xlsx","Sheet","edf3f")

% summarize data based on wavelength
summary = cell(length(wavelength),3); % c1: mean, c2: std, c3: shade
for i = 1:length(wavelength)
    summary{i,1} = mean(y(x==wavelength(i),:));
    summary{i,2} = std(y(x==wavelength(i),:));
    summary{i,3} = polyshape([1:frame_stop,fliplr(1:frame_stop)],[summary{i,1}-summary{i,2},fliplr(summary{i,1}+summary{i,2})]);
end

figure
hold on
arrayfun(@(i)plot(summary{i,3},'FaceColor',color_wavelength(i,:),'EdgeColor','none'),1:length(wavelength));
p = arrayfun(@(i)plot(summary{i,1},'color',color_wavelength(i,:),'linewidth',2),1:length(wavelength),'UniformOutput',0);
plot(1.5,-2,'k^','MarkerFaceColor','k')
hold off
ylim([-5 50])
xticks([1:frame_stop])
xticklabels(([1:frame_stop]-1).*15)
xlim([0.5 frame_stop+.5])
xlabel('Time (min)')
ylabel("Mean ROS (A.U.)")
set(gca,'FontSize',16,'TickDir','out','LineWidth',1)
% xline(1.5,'--','color',[.7 .7 .7])

name_light = ["Cy5" "mCherry" "TRITC" "YFP" "FITC" "CFP" "DAPI"];
legend(fliplr([p{:}]),string(fliplr(name_light)),'Location','northwest','Box','off')

% exportgraphics(gcf,'..\fig\wavelength_ROS.pdf','ContentType','vector')

meanRos = horzcat(summary{:,1})';
Wavelength = repelem(wavelength,5)';
Time = repmat(0:15:60,1,7)';

tbl_source = table(Wavelength,Time,meanRos);
tbl_source.Properties.VariableNames = ["Wavelength (nm)","Time (min)","Mean ROS (AU)"];
% writetable(tbl_source,"figS4.xlsx","Sheet","f")

%% speed, intensity
tmp = platemap(platemap.trf==0.6,:);
x = [];
y = [];
wavelength = unique(tmp.wavelength);
for i = 1:height(tmp)
    if ~isempty(tmp.speed{i})
        y = [y;tmp.speed{i}(:,1)*60];
        index = find(wavelength==tmp.wavelength(i));
        x = [x;index.*ones(length(tmp.speed{i}(:,1)),1)];
    end
end

% pad zero for no speed measurement conditions
nZero = tabulate(x);
nZero = max(nZero(:,2));
for i = 1:length(wavelength)
    if ~any(ismember(x,i))
        x = [x;i.*ones(nZero,1)];
        y = [y;zeros(nZero,1)];
    end
end

tbl = table(x,y,'VariableNames',["cond","speed"]);

tblG = groupsummary(tbl,"cond",{'mean' 'std'},{'speed'});
tblG.wavelength = wavelength(tblG.cond);
tblG = movevars(tblG,"wavelength","After","cond");
% writetable(tbl,"..\data\wavelength_speed_available.csv")

figure
s = swarmchart(x-0.25,y,24,[59, 73, 146]/255,'XJitterWidth',0.5);
xlim([0.5 7.5])
ylim([-0.3 8.3])
set(gca,'XTick',1:length(wavelength),'XTickLabel',wavelength,'TickDir','out','FontSize',16,'LineWidth',1);
ylabel("Speed (µm/min)")
xlabel('Wavelength (nm)')

[B,BG,BC] = groupsummary(y,x,{'mean' 'std'});
hold on
errorbar(BG,B(:,1),B(:,2),B(:,2),'ko','LineWidth',1,'CapSize',9,'MarkerSize',6,'MarkerFaceColor','k')
hold off

% exportgraphics(gcf,'..\fig\wavelength_speed.pdf','ContentType','vector')
tbl_source = table(x,y);
tbl_source.Properties.VariableNames = ["Wavelength (nm)","Speed (µm/min)"];
tbl_source.("Wavelength (nm)") = wavelength(tbl_source.("Wavelength (nm)"))
% writetable(tbl_source,"../../../ftw_paper_figures_v2/source_data/figS4.xlsx","Sheet","c")

