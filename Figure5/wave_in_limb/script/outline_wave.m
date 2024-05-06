clc;clear;close all;

% mask = tiffreadVolume("Mask of MASK_C1-source-1-2.tif");
% 
% for i = 1:size(mask,3)
%     BW = mask(:,:,i);
%     BW = imgaussfilt(BW,5)>0.3;
%     % imshow(BW)
%     [B,L] = bwboundaries(BW,8,'noholes');
%     img  = imread("C1-source-1-1"+pad(string(i),2,'left','0')+".tif");
% 
%     close all
%     imshow(img,[4 20])
%     colormap([abyss;flipud(sky)])
%     hold on
%     x = B{1}(:,2);
%     y = B{1}(:,1);
%     x(x==1 | x==size(img,2))=nan;
%     y(y==1 | y==size(img,1))=nan;
%     plot(x,y,'y','LineWidth',2)
%     hold off
% 
%     exportgraphics(gcf,"outline_"+i+".pdf",'ContentType','vector')
% end

% for i = 2:12
%     BW = imread("mask"+pad(string(i),2,'left','0')+".tif");
%     % BW = mask(:,:,i);
%     BW = imgaussfilt(BW,5)>0.3;
%     % imshow(BW)
%     [B,L] = bwboundaries(BW,8,'noholes');
%     img  = imread("frame"+pad(string(i),2,'left','0')+".tif");
% 
%     close all
%     imshow(img,[4 20])
%     colormap([abyss;flipud(sky)])
    % hold on
    % x = B{1}(:,2);
    % y = B{1}(:,1);
    % x(x==1 | x==size(img,2))=nan;
    % y(y==1 | y==size(img,1))=nan;
    % plot(x,y,'y','LineWidth',2)
    % hold off
% 
%     exportgraphics(gcf,"outline_"+i+".pdf",'ContentType','vector')
% end

load("cyanHot.mat")
for th = 6
    close all

    tiledlayout(1,9)
    for i = 1:9
        img = imread("C1-source-1-1"+pad(string(i),2,'left','0')+".tif");

        mask = imgaussfilt(img,15);
        mask = mask>=th;        

        mask = imgaussfilt(double(mask),5)>0.3;        
        mask = bwareafilt(mask,[3000,numel(img(:))]);

        [B,~] = bwboundaries(mask,8,'noholes');

        % nexttile
        imshow(img,[4 20],'border','tight')
        colormap(cyanHot)

        if ~isempty(B)
            hold on
            for j = 1:length(B)
                x = B{j}(:,2);
                y = B{j}(:,1);
                x(x==1 | x==size(img,2))=nan;
                y(y==1 | y==size(img,1))=nan;
                plot(x,y,'y','LineWidth',2)
            end
            hold off
        end
        exportgraphics(gcf,"outline_"+i+".pdf",'ContentType','vector')
        % title("frame="+(i+14))
        close all
    end
    sgtitle("th="+th)
end