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
// folder = "ftw_paper_figures_v2/figS7_cellROX";
folder = File.directory()+"..";
print(folder);
wells   = "30";
frames = "2-14";

open(folder+"/img/s"+wells+"_cy5_ff1_10.tif");
run("Duplicate...", "duplicate range="+frames);
run("Image Sequence... ", "dir="+folder+"/img/s"+wells+"/for_outline/ format=TIFF name=cy5_t start=1 digits=2");

// export the images for outlining wave
folder = "ftw_paper_figures_v2/figS7_cellROX";
wells   = "30";
frames = "2-14";

open(folder+"/img/s"+wells+"_ros_ff1_10.tif");
run("Duplicate...", "duplicate range="+frames);
run("Image Sequence... ", "dir="+folder+"/img/s"+wells+"/for_outline/ format=TIFF name=ros_t start=1 digits=2");
