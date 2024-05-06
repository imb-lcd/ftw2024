/*
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
*/

close("*"); close("Results"); close("ROI Manager");

// export the images for outlining wave
folder = "ftw_paper_figures_v2/fig5_erastin_titration";
wells   = newArray(8,16,21,24);
frames = "8-9";

for (i = 0; i < wells.length; i++) {
	open("D:/"+folder+"/img/s"+wells[i]+"_ros_ff1_10.tif");
	run("Duplicate...", "duplicate range="+frames);
	run("Image Sequence... ", "dir=D:/"+folder+"/img/s"+wells[i]+"/for_outline/"+
	" format=TIFF name=ros_t start=1 digits=1");
	close("*");
}


