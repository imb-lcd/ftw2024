function plotKymo(X,frame_interval,scale)
%plotKymo plot kymograph
%   Detailed explanation goes here

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

if isempty(frame_interval)
    frame_interval = 1;
elseif numel(frame_interval)>1
    % frame_interval is different
    lci = min(diff(frame_interval)); % least common interval
    % [X1,X2] = meshgrid(frame_interval./lci,1:size(X,2));
    [X1,X2] = ndgrid((frame_interval./lci)+1,1:size(X,2));
    % frame_interval./lci
    F = griddedInterpolant(X1,X2,double(X),'makima');
    [xq1,xq2] = ndgrid(1:floor(max(frame_interval./lci)),1:size(X,2));
    X = F(xq1,xq2);
    frame_interval = lci;
end

if isempty(scale)
    scale = 1;
end


len_px = max(size(X));
B = imresize(X,[len_px len_px]);
H = fspecial('average',11);
MotionBlur = imfilter(B,H,'replicate');
MotionBlur = imadjust(uint16(MotionBlur));

% imagesc([0 size(X,1)-1].*frame_interval,[0 size(X,2)-1].*scale,...
%     MotionBlur')

imagesc([1-1-0.5 size(X,1)-1+0.5].*frame_interval,[0 size(X,2)-1].*scale,...
    MotionBlur')

xlimit = [0-0.5 size(X,1)-1+0.5].*frame_interval;
% xlimit(1) = min([xlimit(1) -0.5]);

xlim(xlimit)
ylim([0 size(X,2)-1].*scale)
axis xy
colormap gray
end