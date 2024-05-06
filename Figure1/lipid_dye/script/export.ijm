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

// set the folder containing the images to be exported
folder = File.directory();

// load the image to be exported
open(folder+"../img/s41_cy5_ff1_10.tif");
run("Duplicate...", "duplicate range=2-25");
rename("cy5");

// take difference of ros
open(folder+"../img/s41_ros_bgsub50.tif");
rename("ros");
selectWindow("ros");
run("Duplicate...", "duplicate range=1-24");
run("16-bit");
selectWindow("ros");
run("Duplicate...", "duplicate range=2-25");
run("16-bit");
imageCalculator("Subtract create stack", "ros-2","ros-1");
rename("dros");

// assemble cy5 and ros channels
run("Merge Channels...", "c1=cy5 c2=dros create");
run("Flip Horizontally");
run("Flip Vertically");
run("Median...", "radius=2 stack");
rename("source"); close("\\Others");

// set display range
selectWindow("source");
setSlice(1);
setMinAndMax(212, 467); // median2
run("Cyan Hot");
setSlice(2);
setMinAndMax(248, 15000); // median2
run("Yellow");

// global view
selectWindow("source");
run("Duplicate...", "duplicate frames=8");
run("RGB Color");
saveAs("Tiff", folder+"../s41_composite_med2_wo_scaleBar.tif");
// add scale bar
run("Scale Bar...", "width=400 height=24 font=100 color=White background=None location=[Upper Right] bold");
saveAs("Tiff", folder+"../s41_composite_med2_w_scaleBar.tif");

// zoom-in view
selectWindow("source");
run("Duplicate...", "duplicate frames=8");
makeRectangle(646, 970, 1500, 1500);
run("Crop");
run("RGB Color");
saveAs("Tiff", folder+"../s41_composite_med2_crop1500_wo_scaleBar.tif");
// add scale bar
run("Scale Bar...", "width=250 height=12 font=50 color=White background=None location=[Upper Right] bold");
saveAs("Tiff", folder+"../s41_composite_med2_crop1500_w_scaleBar.tif");

// Montage of sliced images
open(folder+"../s41_cy5_ff1_10_sliced.tif");
rename("nuc")
run("Cyan Hot")
run("Delete Slice");

open(folder+"../s41_ros_bgsub50_sliced.tif");
rename("lipid")
run("Yellow")

run("Duplicate...", "duplicate range=1-24");
selectWindow("lipid");
run("Duplicate...", "duplicate range=2-25");
imageCalculator("Subtract create stack", "lipid-2","lipid-1");
selectWindow("Result of lipid-2");

run("Merge Channels...", "c1=nuc c2=[Result of lipid-2] create");
run("Median...", "radius=2 stack");

setSlice(1);
setMinAndMax(212, 467);
setSlice(2);
setMinAndMax(248, 15000);
run("Yellow")
run("Delete Slice", "delete=slice");

run("Make Montage...", "columns=12 rows=1 scale=1 first=2 last=13 border=12");
run("RGB Color");
saveAs("Tiff", folder+"../s41_composite_sliced_montaged.tif");
