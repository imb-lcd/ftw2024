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

color_vector = [0.8418    0.0203    0.0521;...
    0.9871    0.6706    0.0758;...
    0.5344    0.7579    0.0178;...
    0.1132    0.3093    0.9220;...
    0.0150    0.0019    0.4251];

tblAngle = [0:10:350]';
tblAngle = [tblAngle,circshift(flipud(tblAngle),10)];

%% settings
old = cd("./data");

% RPE, Erastin
% data = load("entropy_rpe_erastin_center2.mat");
% pixelsize = 1.266;
% label_cell = "RPE, Erastin";
% alpha = 180;   % angle for rotation
% sz = 40; scale = 0; isOut = 0;
% sname = "edf1e";

% RPE, RSL3
% data = load("entropy_rpe_rsl3_s3.mat");
% pixelsize = 1.2720;
% label_cell = "RPE, RSL3";
% alpha = 180;   % angle for rotation
% sz = 40; scale = 0; isOut = 0;
% sname = "edf1g";

% RPE, Staurosporine
% data = load("entropy_rpe_staurosporine_center1.mat");
% pixelsize = 1.26;
% label_cell = "RPE, Staurosporine";
% alpha = 180;   % angle for rotation
% sz = 15; scale = 0.1; isOut = 0;
% sname = "edf1i";

% RPE, BSO + FC
% data = load("entropy_rpe_bsofc_center1.mat");
% pixelsize = 1.26;
% label_cell = "BSO+FC";
% alpha = 220;   % angle for rotation
% sz = 40; scale = 0; isOut = 1;
% sname = "edf1j_BSO_FC";

% RPE, -Cys
% data = load("entropy_rpe_cys2starv_center1.mat");
% pixelsize = 1.26;
% label_cell = "-Cys2";
% alpha = 160;   % angle for rotation
% sz = 40; scale = 0; isOut = 1;
% sname = "edf1j_noCys2";

% RPE, Sodium iodate
% data = load("entropy_rpe_sodium_iodate_center1.mat");
% pixelsize = 1.26;
% label_cell = "RPE, Sodium iodate";
% alpha = 220;   % angle for rotation
% sz = 40; scale = 0; isOut = 0;
% sname = "edf1j_Sodium_iodate";

% RPE, Ionomycin
% data = load("entropy_rpe_ionomycin_center2.mat");
% pixelsize = 1.260;
% label_cell = "RPE, Ionomycin";
% alpha = 80;   % angle for rotation
% sz = 15; scale = 0.1; isOut = 0;
% sname = "edf1j_Ionomycin";

% 786-O
% data = load("entropy_786o_center1.mat");
% pixelsize = 1.260;
% label_cell = "786-O";
% alpha = 20;   % angle for rotation
% sz = 80; scale = 0; isOut = 1;
% sname = "edf1k_"+label_cell;

% HuH-7
% data = load("entropy_huh7_center2.mat");
% pixelsize = 1.260;
% label_cell = "HuH-7";
% alpha = 0;   % angle for rotation
% alpha = 60;   % angle for rotation
% sz = 40; scale = 0; isOut = 0;
% sname = "edf1k_"+label_cell;

% A-172
% data = load("entropy_a172_center1.mat");
% pixelsize = 1.260;
% label_cell = "A-172";
% alpha = 80;   % angle for rotation
% alpha = 200;   % angle for rotation
% sz = 40; scale = 0; isOut = 1;
% sname = "edf1k_"+label_cell;

% Hs 895.T
% data = load("entropy_hs895t_center1.mat");
% pixelsize = 1.260;
% label_cell = "Hs 895.T";
% alpha = 140;   % angle for rotation
% sz = 40; scale = 0; isOut = 1;
% sname = "edf1k_"+label_cell;

% HeLa
% data = load("entropy_hela_center1.mat");
% pixelsize = 1.260;
% label_cell = "HeLa";
% alpha = 160;   % angle for rotation
% sz = 40; scale = 0; isOut = 1;
% sname = "edf1k_"+label_cell;

% SH-SY5Y
% data = load("entropy_shsy5y_center1.mat");
% pixelsize = 1.260;
% label_cell = "SH-SY5Y";
% alpha = 100;   % angle for rotation
% sz = 80; scale = 0; isOut = 0;
% sname = "edf1k_"+label_cell;

% G-402
% data = load("entropy_g402_center2.mat");
% pixelsize = 1.260;
% label_cell = "G-402";
% alpha = 280;   % angle for rotation
% sz = 40; scale = 0; isOut = 1;
% sname = "edf1k_"+label_cell;

% MDA-MB-231
% data = load("entropy_mdamb231_center1.mat");
% pixelsize = 1.260;
% label_cell = "MDA-MB-231";
% alpha = 40;   % angle for rotation
% sz = 40; scale = 0; isOut = 0;
% sname = "edf1k_"+label_cell;

% HOS
% data = load("entropy_hos_center1.mat");
% pixelsize = 1.260;
% label_cell = "HOS";
% alpha = 80;   % angle for rotation
% sz = 40; scale = 0; isOut = 1;
% sname = "edf1k_"+label_cell;

% LN-18
% data = load("entropy_ln18_center1.mat");
% pixelsize = 1.260;
% label_cell = "LN-18";
% alpha = 320;   % angle for rotation
% sz = 40; scale = 0; isOut = 0;
% sname = "edf1k_"+label_cell;

% U-118 MG
% data = load("entropy_u118mg_center1.mat");
% pixelsize = 1.260;
% label_cell = "U-118 MG";
% alpha = 40;   % angle for rotation
% sz = 40; scale = 0; isOut = 1;
% sname = "edf1k_"+label_cell;

% PANC-1
% data = load("entropy_panc1_center2.mat");
% pixelsize = 1.260;
% label_cell = "PANC-1";
% alpha = 0;   % angle for rotation
% sz = 40; scale = 0; isOut = 0;
% sname = "edf1k_"+label_cell;

% A549
% data = load("entropy_a549_s61.mat");
% pixelsize = 1.2665;
% label_cell = "A549";
% alpha = 340;   % angle for rotation
% data.center{1} = [246;201];
% sz = 40; scale = 0; isOut = 1;
% sname = "edf1k_"+label_cell;

% U-2 OS
% data = load("entropy_u2os_s65_1.mat");
% pixelsize = 1.2665;
% label_cell = "U-2 OS";
% alpha = 320;   % angle for rotation
% sz = 40; scale = 0; isOut = 1;
% sname = "edf1k_"+label_cell;

% HT-1080
% data = load("entropy_ht1080_center1.mat");
% pixelsize = 1.2720;
% label_cell = "HT-1080";
% alpha = 220;   % angle for rotation
% sz = 40; scale = 0; isOut = 1;
% sname = "edf1k_"+label_cell;

% NCI-H1650
% data = load("entropy_h1650_center1.mat");
% pixelsize = 1.2665;
% label_cell = "NCI-H1650";
% alpha = 80;   % angle for rotation
% sz = 40; scale = 0; isOut = 1;
% sname = "edf1k_"+label_cell;

% A549, RSL3
% data = load("entropy_a549_rsl3_center1.mat");
% pixelsize = 1.2720;
% label_cell = "A549, RSL3";
% alpha = 20;   % angle for rotation
% sz = 40; scale = 0; isOut = 1;
% sname = "edf1l_A549";

% U-2 OS, RSL3
data = load("entropy_u2os_rsl3_center3.mat");
pixelsize = 1.2720;
label_cell = "U-2 OS, RSL3";
alpha = 340;   % angle for rotation
sz = 40; scale = 0; isOut = 1;
sname = "edf1l_U-2 OS";

%% prepare landscape (rotated)
cd(old)
P = data.center{1};
P2 = data.ROI_length.*[cosd(alpha-90);sind(alpha-90)]+P;

Z = data.Z;

Alpha = -(tblAngle(tblAngle(:,2)==alpha,1)-90);
RotatedIm = imrotate(Z,Alpha);   % rotation of the main image (im)
RotMatrix = [cosd(-Alpha) -sind(-Alpha); sind(-Alpha) cosd(-Alpha)]; 
% RotMatrix = [cosd(Alpha) -sind(Alpha); sind(Alpha) cosd(Alpha)]; 
ImCenterA = (size(Z,1,2)/2)';         % Center of the main image
ImCenterB = (size(RotatedIm,1,2)/2)';  % Center of the transformed image
if label_cell=="U-2 OS"
    ImCenterA = flipud(ImCenterA);
    ImCenterB = flipud(ImCenterB);
end
RotatedP = RotMatrix*(P-ImCenterA)+ImCenterB;
RotatedP2 = RotMatrix*(P2-ImCenterA)+ImCenterB;

% close all
% figure;imagesc(Z);hold on;plot(P(1),P(2),'rx','LineWidth',2,'MarkerSize',20);plot(P2(1),P2(2),'bx','LineWidth',2,'MarkerSize',20)
% figure;imagesc(RotatedIm);axis square;hold on;plot(RotatedP(1),RotatedP(2),'rx','LineWidth',2,'MarkerSize',20);plot(RotatedP2(1),RotatedP2(2),'bx','LineWidth',2,'MarkerSize',20)

Z = RotatedIm;
center{1} = RotatedP;

%% calculate gradient based on the landscape
% sz = 40; % every sz grid points get a vector. Smaller value will take longer time.
[Xq,Yq] = meshgrid(1:sz:size(Z,2),1:sz:size(Z,1));
Vq = Z(1:sz:size(Z,1),1:sz:size(Z,2));
[U,V] = gradient(Vq); % generate gradient based on the all frames of interest

% solve the conflicts of vectors' direction (should ignore length average?)
UG = imgaussfilt(U,1);
VG = imgaussfilt(V,1);

% set the same length for all vectors
L = sqrt(UG.^2+VG.^2);
UG = sz.*UG./L;
VG = sz.*VG./L;

%% local view of vector field (around initiations)
ROI_length = data.ROI_length;
blankspace = ceil(ROI_length*(1/0.85-1)/10)*10;
xlimit = cellfun(@(c)[max([c(1)-ROI_length-blankspace 1]) min([c(1)+ROI_length+blankspace size(Z,2)])],center,'UniformOutput',0);
ylimit = cellfun(@(c)[max([c(2)-ROI_length-blankspace 1]) min([c(2)+ROI_length+blankspace size(Z,1)])],center,'UniformOutput',0);
side_length = cellfun(@(c)min([c(1)-1 size(Z,2)-c(1) c(2)-1 size(Z,1)-c(2)]),center);

[r,c] = find([vertcat(xlimit{:}),vertcat(ylimit{:})]== ...
    repmat([1 size(Z,2) 1 size(Z,1)],length(center),1));

% if the default axis limit touches the edge, using the minimal distance as
% sidelength to determine the distance
if ~isempty(r)
    for i = 1:length(r)
        xlimit{r(i)} = [max([center{r(i)}(1)-side_length(r(i)) 1]) min([center{r(i)}(1)+side_length(r(i)) size(Z,2)])];
        ylimit{r(i)} = [max([center{r(i)}(2)-side_length(r(i)) 1]) min([center{r(i)}(2)+side_length(r(i)) size(Z,1)])];
    end
end

for j = 1%1:length(xlimit)
    % plot laandscape
    figure('Name','Examples','Position',[680   50   250   500])
    ax1 = subplot(2,1,1);
    % figure;
    imshow(Z-0.5,[min(Z(:))-1 max(Z(:))],'Border','tight')
    cmap = gray(max(Z(:))-min(Z(:))+1);
    if isOut
        cmap = [1 1 1;cmap];
    end
    colormap(cmap)

    % plot arrows
    hold on
    % color_vector= colorcet('R4','N',max(Z(:))-1,'reverse',1);
    arrayfun(@(i)quiver(Xq(Vq==i),Yq(Vq==i),UG(Vq==i),VG(Vq==i),scale,...
        'color',color_vector(i,:),'ShowArrowHead','off','Alignment','tail','LineWidth',1.5),1:max(Z(:))-1);

    % mark initiation and bounding boxes of entropy calculation
    for i = 1%1:length(center)
        pgon = rotate(nsidedpoly(8,'Center',center{i}','Radius',ROI_length),45/2,center{i}');
        x = [reshape(pgon.Vertices(:,1),4,[]),nan(4,1)]';
        y = [reshape(pgon.Vertices(:,2),4,[]),nan(4,1)]';
        plot(x(:),y(:),'k--','LineWidth',2)
    end

    % set axit limit
    xlim(xlimit{j})
    ylim(ylimit{j})

    % add scale bar (200 um)
    hold on    
    pgon = polyshape(xlimit{j}(1)+10+[0 200/pixelsize 200/pixelsize 0 0],...
        ylimit{j}(1)+10+[0 0 20 20 0]);
    p = plot(pgon);
    p.EdgeColor='none';
    p.FaceAlpha=1;
    p.FaceColor='k';
    hold off
    text(xlimit{j}(1)+10+100/pixelsize,ylimit{j}(1)+10+30,"200 um",'HorizontalAlignment','center')

    title(label_cell,'FontSize',20)
    set(ax1,'Position',[0 0.5 1 0.45])
    
end



angle = alpha;
Alpha = -(tblAngle(tblAngle(:,2)==alpha,1)-90);
data_arrow = data.data_arrow;
H = data.H;

for k = 1
    subplot(2,1,2);
    index_angle = find(0:20:359==angle(k));
    a = data_arrow.angleArrow(data_arrow.centerID==1 & data_arrow.angleBox==angle(k),:);
    
    a = a-deg2rad(Alpha);    
    h = polarhistogram(-1.*a,'BinEdges',linspace(0,2*pi,31),'Normalization','probability');
    h.EdgeColor = 'w'; % [59, 73, 146]/255;
    h.FaceColor = [28 117 188]./255; % 'w';
    h.FaceAlpha = 1;
    ax = gca;
    set(gca,'GridColor','k','FontSize',11,'Layer','bottom',...
        'RAxisLocation',0,'LineWidth',1,'Color','none','GridAlpha',1,'GridColor',[.7 .7 .7])

    % title(sprintf("%d^\\circ, H=%.2f",angle(k),H(index_angle,1)),'FontSize',20)
    title("H="+pad(string(round(H(index_angle,1),2)),4,'right','0'),'FontSize',20)
    thetaticks([0 45 90 135 180 225 270 315])
    thetaticklabels({'90^\circ','45^\circ','0^\circ','315^\circ','270^\circ','225^\circ','180^\circ','135^\circ'})
end

center = 6:12:360; % real
center = 0:12:359; % label
center = fliplr(center);
center = [center(end-7:end),center(1:22)]';
tbl_source = table(center,h.Values','VariableNames',["Degree","Frequency"]);
writetable(tbl_source,"edf1hist.xlsx","Sheet",sname)


exportgraphics(gcf,label_cell+".pdf",'ContentType','vector')