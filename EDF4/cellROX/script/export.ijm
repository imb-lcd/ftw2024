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
//folder = "ftw_paper_figures_v2/figS7_cellROX";
folder = File.directory()+"..";
print(folder);

// load the image to be exported
open(folder+"/img/s30_cy5_ff1_10.tif");
run("Duplicate...", "duplicate range=2-24");
rename("cy5");

// take difference of ros
open(folder+"/img/s30_ros_ff1_10.tif");
rename("ros");
selectWindow("ros");
run("Duplicate...", "duplicate range=1-23");
run("16-bit");
selectWindow("ros");
run("Duplicate...", "duplicate range=2-24");
run("16-bit");
imageCalculator("Subtract create stack", "ros-2","ros-1");
rename("dros");

// assemble cy5 and ros channels
run("Merge Channels...", "c1=cy5 c2=dros create");
run("Flip Vertically");
run("Median...", "radius=2 stack");
rename("source"); close("\\Others");

// set display range
selectWindow("source");
setSlice(1);
setMinAndMax(185, 440); // median2
run("Cyan Hot");
setSlice(2);
setMinAndMax(5, 26); // median2
run("Yellow");

// 3000
selectWindow("source");
run("Duplicate...", "duplicate frames=8");
run("RGB Color");
//saveAs("Tiff", "D:/"+folder+"/fig/s30_composite_med2_wo_scaleBar.tif");
// scale bar
run("Scale Bar...", "width=400 height=24 font=100 color=White background=None location=[Upper Right] bold");
//saveAs("Tiff", "D:/"+folder+"/fig/s30_composite_med2_w_scaleBar.tif");

// zoom-in
selectWindow("source");
run("Duplicate...", "duplicate frames=8");
//makeRectangle(742, 602, 1500, 1500);
makeRectangle(868, 612, 1500, 1500);
run("Crop");
run("RGB Color");
//saveAs("Tiff", "D:/"+folder+"/fig/s30_composite_med2_zoomIn_wo_scaleBar.tif");
// scale bar
run("Scale Bar...", "width=250 height=12 font=50 color=White background=None location=[Upper Right] bold");
//saveAs("Tiff", "D:/"+folder+"/fig/s30_composite_med2_zoomIn_w_scaleBar.tif");

// bright field zoom-in
/*
open("D:/"+folder+"/img/s30_dic_ff1_10.tif");
Stack.setXUnit("um");
run("Properties...", "channels=1 slices=1 frames=24 pixel_width=1.266 pixel_height=1.266 voxel_depth=1.266");

run("Flip Vertically");
run("Duplicate...", "duplicate range=9");
makeRectangle(742, 602, 1500, 1500);
run("Crop");
run("Enhance Contrast", "saturated=2");
run("RGB Color");
saveAs("Tiff", "D:/"+folder+"/fig/s30_dic_zoomIn.tif");
*/

// Montage of sliced images
folder = "ftw_paper_figures_v2/figS7_cellROX";
open("D:/"+folder+"/img/s30_cy5_ff1_10_sliced.tif");
rename("nuc")
run("Cyan Hot")
run("Delete Slice");

open("D:/"+folder+"/img/s30_ros_ff1_10_sliced.tif");
rename("lipid")
run("Yellow")

run("Duplicate...", "duplicate range=1-23");
selectWindow("lipid");
run("Duplicate...", "duplicate range=2-24");
imageCalculator("Subtract create stack", "lipid-2","lipid-1");
selectWindow("Result of lipid-2");

run("Merge Channels...", "c1=nuc c2=[Result of lipid-2] create");
run("Median...", "radius=2 stack");

setSlice(1);
setMinAndMax(185, 440); // median2
setSlice(2);
setMinAndMax(5, 26); // median2
run("Yellow")

run("Make Montage...", "columns=14 rows=1 scale=1 first=1 last=14 border=12");
run("RGB Color");
saveAs("Tiff", "D:/"+folder+"/fig/s30_composite_sliced_montaged.tif");

// movie
selectWindow("source");
close("\\Others");
run("Duplicate...", "duplicate frames=1-16");
run("RGB Color", "frames keep");

selectWindow("source-2");
run("Duplicate...", " ");
selectWindow("source-2");
run("Duplicate...", " ");
imageCalculator("Subtract create", "source-2-1","source-2-2");
selectWindow("Result of source-2-1");
run("Concatenate...", "open image1=[Result of source-2-1] image2=source-2 image3=[-- None --]");

setSlice(1);
run("Duplicate...", " ");
setForegroundColor(0, 255, 255);
makeOval(340, 2240, 394, 394);
run("Dotted Line", "line=20 dash=20,20");

run("Concatenate...", "open image1=Untitled-1 image2=Untitled image3=[-- None --]");
setSlice(2);
run("Delete Slice");

run("Scale Bar...", "width=400 height=24 font=100 color=White background=None location=[Upper Right] bold label");
run("AVI... ", "compression=JPEG frame=3 save=D:/"+folder+"/fig/s30_med2.avi");
