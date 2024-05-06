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

// set the folder containing the images to be exported
folder = File.directory();
print(folder);

/* 0.15uM RSL3, nuclear */
run("Close All");
open(folder+"../img/rsl3_s3_nuc_BaSiC_cropped.tif");
run("Median...", "radius=2 stack");
setMinAndMax(530,795);
rename("source");

setSlice(1);
run("Duplicate...", "use");
rename("frame1");
run("Set Label...", "label=frame1");

selectWindow("source");
run("Slice Keeper", "first=13 last=44 increment=2");
n = nSlices;
for (i = 0; i < n; i++) {
	setSlice(i+1);
	run("Set Label...", "label=frame"+(13+i*2));
}
run("Concatenate...", "  title=rsl3_s1 open image1=frame1 image2=[source kept stack] image3=[-- None --]");
saveAs("Tiff", folder+"../img/rsl3_s3_nuc_BaSiC_cropped_med2_selectedFrames.tif");
run("RGB Color");
run("Image Sequence... ", "select="+folder+"../fig/image/ dir="+folder+"../fig/image/ format=TIFF name=rsl3_0.15_s3_frame digits=2");

/* 0.15uM RSL3, dic */
run("Close All");
open(folder+"../img/rsl3_s3_dic_BaSiC_cropped.tif");
rename("source");

setSlice(1);
run("Duplicate...", "use");
rename("frame1");
run("Set Label...", "label=frame1");

selectWindow("source");
run("Slice Keeper", "first=13 last=44 increment=2");
n = nSlices;
for (i = 0; i < n; i++) {
	setSlice(i+1);
	run("Set Label...", "label=frame"+(13+i*2));
}
run("Concatenate...", "  title=rsl3_s1 open image1=frame1 image2=[source kept stack] image3=[-- None --]");
saveAs("Tiff", folder+"../img/rsl3_s3_dic_BaSiC_cropped_selectedFrames.tif");
run("RGB Color");
run("Image Sequence... ", "select="+folder+"../fig/image/ dir="+folder+"../fig/image/ format=TIFF name=rsl3_0.15_s3_dic_frame digits=2");
