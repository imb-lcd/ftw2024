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

pos = "s"+[21 16 8 24]; % well to process
alpha = 0:30:359;
half_width = 20;

%% organize measurements
result = [];
for i = 1:length(pos)

    % load image
    list = dir("..\img\"+pos(i)+"\for_outline\ros*.tif");
    img = arrayfun(@(x)imread(fullfile(x.folder,x.name)),list,'UniformOutput',0);

    % load initiation for center
    load("..\data\setting_"+pos(i)+".mat")
    S = regionprops(initiation.mask,'centroid');
    center = fix(S.Centroid);
    tmp = zeros(size(initiation.mask));
    tmp(center(2),center(1)) = 1;
    box_length = bwdist(tmp);
    box_length = max(box_length(:));
    pgon = polyshape(center(1)+[-1 1 1 -1]*0.1,center(2)+[0 0 -1 -1]*box_length);

    % load mask/outline
    load("..\data\mask_"+pos(i)+".mat","MASK")
    outlines = cellfun(@(x)bwboundaries(x),MASK,'UniformOutput',0);
    outlines = cellfun(@(x)x{1},outlines,'UniformOutput',0);
    
    % measure width
    displacement = -1*half_width:half_width;
    distanceMedian = nan(length(alpha),1);
    for j = 1:length(alpha)
        a = alpha(j);
        distance = nan(length(displacement),1);
        for k = 1:length(displacement)
            d = displacement(k);
            polyout = translate(rotate(pgon,a,center),d*cosd(a),d*sind(a));
            [xi,yi] = polyxpoly(outlines{1}(:,2),outlines{1}(:,1),polyout.Vertices(:,1),polyout.Vertices(:,2));
            [xo,yo] = polyxpoly(outlines{2}(:,2),outlines{2}(:,1),polyout.Vertices(:,1),polyout.Vertices(:,2));
            if ~isempty(xo)
                distance(k) = min(pdist2(fix([xi yi]),fix([xo,yo]),"euclidean"),[],'all');
            end
        end
        distanceMedian(j) = median(distance(~isnan(distance)));
    end
    
    % measure amplitude
    pgon = polyshape(center(1)+[-1 1 1 -1]*half_width,center(2)+[0 0 -1 -1]*box_length);
    outer = polyshape(outlines{2}(1:end-1,2),outlines{2}(1:end-1,1));
    inner = polyshape(outlines{1}(1:end-1,2),outlines{1}(1:end-1,1));
    wavefront = subtract(outer,inner);
    
    amplitude = nan(length(alpha),1);
    for j = 1:length(alpha)
        a = alpha(j);
        polyout = intersect(wavefront,rotate(pgon,a,center));
        isUsed = sum(isnan(polyout.Vertices),2)==0;
        x = polyout.Vertices(isUsed,1);
        y = polyout.Vertices(isUsed,2);
        BW = poly2mask(x,y,...
        size(initiation.mask,1),size(initiation.mask,2));
        tmp = regionprops(BW,img{2},'PixelValues');
        tmp = tmp.PixelValues;
        tmp(tmp<prctile(tmp,90)) = [];
        amplitude(j) = median(tmp);
    end

    % visualize
    imshow(imadjust(img{2}))
    hold on
    plot(outlines{1}(:,2),outlines{1}(:,1),'m')
    plot(outlines{2}(:,2),outlines{2}(:,1),'m')
    plot(center(1),center(2),'mx','MarkerSize',20)
    plot(polyout)
    plot(rotate(pgon,a,center))
    tbl = table(repelem(pos(i),length(alpha),1),alpha',distanceMedian,amplitude,...
        'VariableNames',["well" "angle" "width" "amplitude"]);

    result = [result;tbl] ;
    
end
result.level = repelem(1:length(pos),length(alpha))';
result.width = result.width.*1.260;

%% remove outliers
tmp = isoutlier(reshape(result.width,length(alpha),length(pos)),1);
result.isoutlier_width = tmp(:);
tmp = isoutlier(reshape(result.amplitude,length(alpha),length(pos)),1);
result.isoutlier_amplitude = tmp(:);
result.isoutlier = result.isoutlier_width|result.isoutlier_amplitude;
result.isoutlier(result.well=="s24"&ismember(result.angle,67:112)) = 1;
result.isSampled = true(height(result),1);

%% organize data
x = result.level(result.isSampled==1);
w = result.width(result.isSampled==1);
m = result.amplitude(result.isSampled==1);

%% select which attribute to plot (wavefront width: I=1; amplitude: I=2)
factor = ["width" "amp"];
index = [1 2];
y = [w,m];
text_ylabel = ["Width (µm)" "Amplitude (A.U.)"];
I = 2;

%% statistical test
close all
figure
[p,~,stats] = anova1(y(:,I),x,'off');
[c] = multcompare(stats);

PValues = nan(size(c,1),1);
for i = 1:length(PValues)
    xx = y(x==c(i,1),I);
    yy = y(x==c(i,2),I);
    PValues(i,1) = ranksum(xx,yy);
end
FDR = mafdr(PValues,'BHFDR',1);
c(:,7) = FDR;

effect = "cohen"
Effect = cell(size(c,1),1);
% x = well(:,4);
w = y(:,I);
for i = 1:size(c,1)
    Effect{i} = meanEffectSize(w(x==c(i,2)),w(x==c(i,1)),...
        Effect=effect,ConfidenceIntervalType="bootstrap");
    c(i,8) = Effect{i}.ConfidenceIntervals(1)*...
        Effect{i}.ConfidenceIntervals(2)>0;
    c(i,9) = Effect{i}.Effect;
end

figure
tmp = sparse(c(:,1),c(:,2),c(:,7),nnz(unique(x)),nnz(unique(x)));
heatmap(full(tmp+tmp'),'XDisplayLabels',string([1.25 2.5 5 10]),...
    'YDisplayLabels',string([1.25 2.5 5 10]),'title','Mann–Whitney U test, FDR','FontSize',16)

%% plot 
xx = 1; yy = 0; neg = 0; pos = 0;
for i = 1:length(Effect)
    xx = [xx;i+1];
    yy = [yy;Effect{i}.Effect];
    neg = [neg;Effect{i}.Effect-Effect{i}.ConfidenceIntervals(1)];
    pos = [pos;-Effect{i}.Effect+Effect{i}.ConfidenceIntervals(2)];
end

tblG = groupsummary(y(:,I),x,{'mean' 'std'});
figure
swarmchart(x-0.25,y(:,I),[],[59, 73, 146]/255,'XJitter','density','XJitterWidth',0.15)
hold on
errorbar((1:4),tblG(:,1),tblG(:,2),'o','color','k','LineWidth',1,'MarkerFaceColor','k')

xlabel("Erastin (µM)")
ylabel(text_ylabel(I))
set(gca,'Layer','top','LineWidth',1,'FontSize',16,'tickdir','out',...
    'XTick',1:4,'XTickLabel',string([1.25 2.5 5 10]),'xlim',[0.5 4.5])
box off

if I==2
    ylim([390 660]) % amp
elseif I==1
    ylim([80 520]) % width
end
% exportgraphics(gcf,"..\fig\"+factor(I)+"_dose.pdf")

% tbl_source = table(x,y(:,1),'VariableNames',["Erastin (uM)","Width (µm)"]);
% tmp = [1.25 2.5 5 10];
% tbl_source.("Erastin (uM)") = tmp(tbl_source.("Erastin (uM)"))';
% writetable(tbl_source,"../../source_data/fig4.xlsx","Sheet","f")
% tbl_source = table(x,y(:,2),'VariableNames',["Erastin (uM)","Amplitude (A.U.)"]);
% tmp = [1.25 2.5 5 10];
% tbl_source.("Erastin (uM)") = tmp(tbl_source.("Erastin (uM)"))';
% writetable(tbl_source,"../../source_data/fig4.xlsx","Sheet","g")


