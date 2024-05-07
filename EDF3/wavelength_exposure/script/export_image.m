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

%% wavelength
% well = [81 62 60 39 34 14 11]; % wells to be exported
% wavelength = fliplr([646 587 550 509 495 434 358]);
% for i = 1:length(well)
%     img = imread("..\img\Wavelength20X_s"+well(i)+"_ros_ff1_10_induction.tif");
%     mask = imread("..\img\Wavelength20X_s"+well(i)+"_c1_induction_mask.tif");
% 
%     D = bwdist(~(mask>0));
%     [~,I] = max(D(:));
%     [row,col] = ind2sub(size(D),I);
%     r = floor(sqrt(nnz(mask>0)/pi));
% 
%     bo = bwboundaries(mask>0);
%     imshow(imadjust(img),'border','tight')
%     viscircles([col,row],r);
% 
%     print(gcf,"..\fig\"+wavelength(i)+".svg",'-dsvg')
% 
%     close all
% %     hold on
% %     plot(bo{1}(:,2),bo{1}(:,1),"c",'LineWidth',2)
% %     hold off
% end

%% intensity
well = [3 23 27 47 50]; % wells to be exported
duration = [0.625 1.25 2.5 5 10];
for i = 1:length(well)
    img = imread("..\img\Intensity20X_s"+well(i)+"_ros_ff1_10_induction.tif");
    mask = imread("..\img\Intensity20X_s"+well(i)+"_c1_induction_mask.tif");

    D = bwdist(~(mask>0));
    [~,I] = max(D(:));
    [row,col] = ind2sub(size(D),I);
    r = floor(sqrt(nnz(mask>0)/pi));

    bo = bwboundaries(mask>0);
    imshow(imadjust(img),'border','tight')
    viscircles([col,row],r);

    print(gcf,"..\fig\D"+i+".svg",'-dsvg')

    close all
%     hold on
%     plot(bo{1}(:,2),bo{1}(:,1),"c",'LineWidth',2)
%     hold off
end

