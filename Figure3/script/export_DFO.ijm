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
folder = "ftw_paper_figures_v2/fig3_chemical_perturbation";

open("D:/"+folder+"/img/DFO_24_s14_c1_ff1_10.tif");

Stack.setXUnit("um");
run("Properties...", "channels=1 slices=1 frames="+nSlices
+" pixel_width=1.266 pixel_height=1.266 voxel_depth=1.266");
rename("source")
run("Median...", "radius=2 stack");
run("Cyan Hot");

setSlice(12);
run("Duplicate...", " ");
setMinAndMax(197,383);
run("RGB Color");

// save for figure 3C
saveAs("Tiff", "D:/"+folder+"/fig/DFO_24_s14_ff1_10_med2_wo_scaleBar.tif");
run("Scale Bar...", "width=1000 height=40 font=165 color=White background=None location=[Upper Right] bold");
saveAs("Tiff", "D:/"+folder+"/fig/DFO_24_s14_ff1_10_med2_w_scaleBar.tif");

selectWindow("source"); close("\\Others");
setMinAndMax(192,603); // gblur0
run("Duplicate...", "duplicate range=1-"+nSlices);

run("RGB Color", "frames keep");
makeRectangle(0, 500, 4500, 4500);
run("Crop");

setSlice(1);
run("Duplicate...", " ");
setForegroundColor(0, 255, 255);
makeOval(217, 3894, 394, 394);
run("Dotted Line", "line=20 dash=20,20");

run("Concatenate...", "open image1=source-2 image2=source-1 image3=[-- None --]");
setSlice(2);
run("Delete Slice");

// add text
for (i = 12; i < 48; i++) {
	setSlice(i);
	setFont("Sanserif", 200);
	makeText("+DFO", 3900, 50);
	roiManager("Add", "white");
}
roiManager("Select", newArray(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35));
run("Select All");
setForegroundColor(255, 255, 255);
roiManager("Draw");
roiManager("Deselect");
run("Scale Bar...", "width=1000 height=40 font=165 color=White background=None location=[Lower Right] bold label");

// save for movie
run("AVI... ", "compression=JPEG frame=7 save=D:/"+folder+"/fig/DFO_24_s14.avi");
