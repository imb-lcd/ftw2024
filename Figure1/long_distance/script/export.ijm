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
open(folder+"../img/s19_cy5_ff1_10.tif");
rename("cy5");

// determine display range
makeRectangle(992, 2527, 45, 45);
run("Measure");
meanLv = getResult("Mean", 0);
print(meanLv);
close("Results");
run("Select None");
setMinAndMax(meanLv, meanLv+255);
run("Cyan Hot");

// apply median filter to reduce noise
run("Median...", "radius=2 stack");

// convert to RGB images and save
setSlice(13);
run("Duplicate...", " ");
makeRectangle(0, 500, 4500, 4500);
run("Crop");
run("RGB Color");
//saveAs("Tiff", folder+"../s19_cy5_ff1_10_med2_crop4500_wo_scaleBar.tif");

// add a scale bar
run("Scale Bar...", "width=1000 height=36 font=150 color=White background=None location=[Upper Right] bold");
//saveAs("Tiff", folder+"D../s19_cy5_ff1_10_med2_crop4500_w_scaleBar.tif");
close("s19*");

// export the images around the initiation
selectWindow("cy5");
run("Duplicate...", "duplicate range=1-5");
makeRectangle(199, 3845, 901, 901);
run("Crop");
run("RGB Color");
run("Image Sequence... ", "select="+folder+"/../ dir="+folder+"/../ format=TIFF name=s19_cy5_ff1_10_crop900_f digits=1");

setSlice(1);
run("Duplicate...", " ");
run("Scale Bar...", "width=400 height=12 font=50 color=White background=None location=[Upper Right] bold");
saveAs("Tiff", folder+"../s19_cy5_ff1_10_crop900_f1_w_scaleBar.tif");

// export the bright field images around the initiation
open(folder+"../img/s19_dic_ff1_10.tif");
rename("bright_field")
makeRectangle(199, 3845, 901, 901);
run("Crop");
run("Enhance Contrast", "saturated=2");
run("Duplicate...", "duplicate range=1-5");
run("RGB Color");
run("Image Sequence... ", "select="+folder+"/fig/ dir="+folder+"/fig/ format=TIFF name=s19_dic_ff1_10_crop900_f digits=1");

// export cropped images
open(folder+"../img/s19_cy5_ff1_10_sliced.tif");
run("Median...", "radius=2 stack");
setMinAndMax(234, 526);
run("Cyan Hot");
run("Make Montage...", "columns=16 rows=1 scale=1 first=1 last=16 border=12");
run("RGB Color");
saveAs("Tiff", folder+"../s19_cy5_ff1_10_sliced_montaged.tif");
