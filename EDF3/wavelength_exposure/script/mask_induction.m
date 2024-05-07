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

%% intensity
% pos = "s"+(1:60); % well to process
% prefix = "Intensity20X";
% 
% for i = 1:length(pos)
%     fname = "..\raw\"+prefix+"_"+pos(i)+"_c1_induction_ORG.tif";
%     if exist(fname,"file")
%         img = imread(fname);
%         img = medfilt2(img);
%         mask = imbinarize(imadjust(img),0.05);
%         stats = regionprops('table',mask,'Area');
%         [~,I] = max(stats.Area);
%         mask = bwlabel(mask)==I;
% 
%         maskD = imfill(bwdist(mask)<25,'holes');    
%         maskDS = bwdist(~maskD)>25;
% 
%         B = labeloverlay(imadjust(img,[120 172]./2^16),maskDS);
%         imshow(B)
%         
%         exportgraphics(gcf,"..\img\check_mask_induction\induction_"+pos(i)+".jpg","Resolution",300)
%         imwrite(uint8(maskDS.*255),strrep(strrep(fname,"ORG","mask"),"raw","img"))
%     end
% end

%%
pos = "s"+(1:84); % well to process
prefix = "Wavelength20X";

% 1:12, 0.07
% 49:60, 0.1
% 51, 0.08
% 73:84, 0.06

for i = 73:84%length(pos)
    fname = "..\raw\"+prefix+"_"+pos(i)+"_c1_induction_ORG.tif";
    if exist(fname,"file")
        img = imread(fname);
        img = medfilt2(img);
        mask = imbinarize(imadjust(img),0.06);
        mask = imfill(mask,'holes');
        stats = regionprops('table',mask,'Area');
        [~,I] = max(stats.Area);
        mask = bwlabel(mask)==I;

        maskD = imfill(bwdist(mask)<40,'holes');    
        maskDS = bwdist(~maskD)>40;

        B = labeloverlay(imadjust(img,[120 200]./2^16),maskDS);
        imshow(B)
        
        exportgraphics(gcf,"..\img\check_mask_induction\induction_"+prefix+"_"+pos(i)+".jpg","Resolution",300)
        imwrite(uint8(maskDS.*255),strrep(strrep(fname,"ORG","mask"),"raw","img"))
    end
end