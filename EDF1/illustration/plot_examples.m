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

%%% regular
prefix = "regular";
[X,Y] = meshgrid(linspace(-1,1,650),linspace(0.6,2.4,650));
Z = peaks(X,Y);
surf(Z,'EdgeColor','none')
[Y,E] = discretize(Z,6);
Z = 7-Y;
center{1} = [324.9987;358.0300];

%%% irregular
% prefix = "irregular";
% z = zeros(650);
% r = 20;
% % imshow(z)
% close all
% J = imnoise(z,'salt & pepper',0.0003);
% J = imdilate(J,strel("disk",r));
% figure;imshow(J)
% 
% mask{1} = J;
% 
% for k = 2:5
%     stats = regionprops('table',logical(mask{k-1}),'Centroid');
% 
%     rng(10+k*10)
%     dx = (rand(height(stats),1)-0.5).*r*2.5;
%     rng(500+k*100)
%     dy = (rand(height(stats),1)-0.5).*r*2.5;
% 
%     newX = round(stats.Centroid(:,1)+dx);
%     newX(newX<1) = 1;
%     newY = round(stats.Centroid(:,2)+dy);
%     newY(newY<1) = 1;
% 
%     B = z;
%     for i = 1:length(newX)
%         B(newY(i),newX(i)) = 1;
%     end
%     B = imdilate(B,strel("disk",r));
% 
%     mask{k} = B(1:650,1:650);
% end
% landscape = (cat(3,mask{:}));
% [a,Z]=max(landscape,[],3);
% Z(a==0) = size(landscape,3)+1;
% center{1} = [325;325];

%%
% calculate gradient based on the landscape
sz = 40; % every sz grid points get a vector. Smaller value will take longer time.
[Xq,Yq] = meshgrid(1:sz:size(Z,2),1:sz:size(Z,1));
Vq = Z(1:sz:size(Z,1),1:sz:size(Z,2));
[U,V] = gradient(Vq); % generate gradient based on the all frames of interest

% solve the conflicts of vectors' direction (should ignore length average?)
UG = imgaussfilt(U,1);
VG = imgaussfilt(V,1);
arrow_angle = atan2(VG,UG);

% set the same length for all vectors
L = sqrt(UG.^2+VG.^2);
UG = sz.*UG./L;
VG = sz.*VG./L;

% determine if the arrows are valid for entropy calculation
isValid = true(size(Xq));
isValid(Vq==max(Z(:))) = 0; % within the frame range (frame 1 to 5)
isValid(sqrt(UG.^2+VG.^2)==0) = 0; % length of arrow > 0

%% plot contours 
close all
figure;imshow(Z-0.5,[min(Z(:))-1 max(Z(:))],'Border','tight')
colormap(gray(max(Z(:))-min(Z(:))+1))

hold on
color_vector= colorcet('R4','N',max(Z(:))-1,'reverse',1);
for i = 1:max(Z(:))-1
    quiver(Xq(Vq==i),Yq(Vq==i),UG(Vq==i),VG(Vq==i),0,...
    'color',color_vector(i,:),'ShowArrowHead','off','Alignment','tail','LineWidth',1.5)
end

% exportgraphics(gcf,prefix+"_propagation.pdf","ContentType","vector");

%% plot vector field
figure;imshow(Z-0.5,[0 0.1],'Border','tight')
hold on
color_vector= colorcet('R4','N',max(Z(:))-1,'reverse',1);
for i = 1:max(Z(:))-1
    quiver(Xq(Vq==i),Yq(Vq==i),UG(Vq==i),VG(Vq==i),0,...
    'color',color_vector(i,:),'ShowArrowHead','off','Alignment','tail','LineWidth',1.5)
end

ROI_width = 75;
ROI_length = 275;

pgon = arrayfun(@(i)polyshape(center{i}(1)+[-1 -1 1 1 -1].*ROI_width./2,...
    center{i}(2)+[0 -1 -1 0 0].*ROI_length),1:length(center),'UniformOutput',0);
hold on
plot(pgon{1},'EdgeColor','k','FaceColor','none','LineWidth',3)
hold off

% exportgraphics(gcf,prefix+"_vector_field.pdf","ContentType","vector");

%% get vector angles to compute entropy
% calculate gradient based on the landscape
sz = 20; % every sz grid points get a vector. Smaller value will take longer time.
[Xq,Yq] = meshgrid(1:sz:size(Z,2),1:sz:size(Z,1));
Vq = Z(1:sz:size(Z,1),1:sz:size(Z,2));
[U,V] = gradient(Vq); % generate gradient based on the all frames of interest

% solve the conflicts of vectors' direction (should ignore length average?)
UG = imgaussfilt(U,1);
VG = imgaussfilt(V,1);
arrow_angle = atan2(VG,UG);

% set the same length for all vectors
L = sqrt(UG.^2+VG.^2);
UG = sz.*UG./L;
VG = sz.*VG./L;

% determine if the arrows are valid for entropy calculation
isValid = true(size(Xq));
isValid(Vq==max(Z(:))) = 0; % within the frame range (frame 1 to 5)
isValid(sqrt(UG.^2+VG.^2)==0) = 0; % length of arrow > 0

%% collect information of valid arrows for each initiation
% set the angles of view
alpha = (0:20:359)'; % the angle of view, up=0, right=90, down=180, left=270   

% identify the position of valid arrows
valid_grid = cell(size(alpha));
for i = 1:length(alpha)

    % rotate the bounding box
    polyout = cellfun(@(p,c)rotate(p,alpha(i),c'),pgon,center,'UniformOutput',0);

    % identify the arrow within the rotated bounding box
    in = cellfun(@(p)reshape(inpolygon(Xq(:),Yq(:),p.Vertices(:,1),p.Vertices(:,2)),size(Xq,1),[]),...
        polyout,'UniformOutput',0);
    [a,BC] = max(uint8(reshape([in{:}],size(in{1},1),size(in{1},2),length(in))),[],3);
    BC(a==0) = 0;
    valid_grid{i} = isValid.*BC;
    
    % check if the arrows obtained from at least 3 frames
    index = find(arrayfun(@(j)length(unique(Vq(valid_grid{i}==j))),1:length(center))<3);
    if ~isempty(index)
        valid_grid{i}(ismember(valid_grid{i},index)) = 0;
    end

    % check if the number of valid arrows is greater than 20
    index = find(arrayfun(@(j)nnz(valid_grid{i}==j),1:length(center))<=0);
    if ~isempty(index)
        valid_grid{i}(ismember(valid_grid{i},index)) = 0;
    end
    
end

% collect valid arrows
data_arrow = [];
for i = 1:length(valid_grid)
    index = arrayfun(@(j)find(valid_grid{i}==j),1:length(center),'UniformOutput',0);
    
    % get rid of 20% of arrows, which are deviated from the angle of view
    % if the number of remaining arrows is less than 100, keep all arrows; 
    % otherwise, use 80% of the arrows
    tmp = cellfun(@(c)angdiff(arrow_angle(c),repelem(deg2rad(alpha(i)-90),length(c),1)),...
        index,'UniformOutput',0);
    [~,II] = cellfun(@(a)sort(abs(a),'ascend'),tmp,'UniformOutput',0);
    for j = 1:length(II)
        if length(II{j})>100
            II{j} = II{j}(1:fix(0.8*length(II{j})));
        end
    end
    index = cellfun(@(a,b)a(b),index,II,'UniformOutput',0);
    
    % collect valid arrows
    nArrow = cellfun('length',index);
    index = vertcat(index{:});
    tmp = [repelem(alpha(i),length(index),1),Xq(index),Yq(index),...
        UG(index),VG(index),arrow_angle(index),repelem(1:length(center),nArrow)'];
    data_arrow = [data_arrow;tmp];
end
data_arrow = array2table(data_arrow,'VariableNames',["angleBox" "x" "y" "u" "v" "angleArrow" "centerID"]);

%% plot polarhistogram and calculate entropy
binedges = linspace(0,2*pi,31);
H = nan(length(alpha),length(center));
for i = 1:length(center)
    figure('Name',"Center "+i,'Position',[50 50 960 480])
    tiledlayout(3,6,'TileSpacing','compact','Padding','compact')
    for j = 1
        a = data_arrow.angleArrow(data_arrow.angleBox==alpha(j)&data_arrow.centerID==i & ~isnan(data_arrow.u));
        if ~isempty(a)
            nexttile(j)
            h = polarhistogram(-1.*a,'BinEdges',binedges,'Normalization','probability');
            p = h.Values;
            p(p==0)=[]; % remove the zero probability
            
            H(j,i) = -sum(p.*log2(p)); % calculate the entropy

            h.EdgeColor = 'w';
            h.FaceColor = [28 117 188]./255; % 'w';
            h.FaceAlpha = 1;
            ax = gca;
            set(gca,'GridColor','k','FontSize',11,'Layer','bottom',...
                'RAxisLocation',0,'LineWidth',1,'Color','none',...
                'GridAlpha',1,'GridColor',[.7 .7 .7],"FontName","Arial")

            title("H="+round(H(j,i),2),'FontSize',20)
            thetaticks([0 45 90 135 180 225 270 315])
            thetaticklabels({'90^\circ','45^\circ','0^\circ','315^\circ','270^\circ','225^\circ','180^\circ','135^\circ'})
        end
    end
    % exportgraphics(gcf,prefix+"_entropy.pdf","ContentType","vector");

end