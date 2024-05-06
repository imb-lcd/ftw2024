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

folder_script = File.directory();
fname = folder_script+"../raw/s41c3_ORG.tif";
print(File.directory());
setBatchMode("hide");

// load raw image
open(fname);
rename("source");

// measure the mean intensity of the first frame
setSlice(1); 
run("Select All"); 
run("Measure");
meanLv = getResult("Mean", 0);	print(meanLv);	close("Results");	

// background estimation using the first frame
run("Duplicate...", " "); rename("background");
run("Gaussian Blur...", "sigma=10");

// flat-field correction based on the background from the first frame
selectWindow("source");
run("Calculator Plus", "i1=source i2=background "
+"operation=[Divide: i2 = (i1/i2) x k1 + k2] k1="+meanLv+" k2=0 create");

// set the properties of images
Stack.setXUnit("um");
Stack.setYUnit("um");
run("Properties...", "channels=1 slices=1 frames="+nSlices
+" pixel_width=1.266 pixel_height=1.266 voxel_depth=1");

// save the processed images in the img folder
saveAs("Tiff", folder_script+"../img/s41_cy5_ff1_10.tif");

// load raw image
fname = folder_script+"../raw/s41c1_ORG.tif";
open(fname);
rename("den");
fname = folder_script+"../raw/s41c2_ORG.tif";
open(fname);
rename("num");
	
// take ratio
run("Subtract Background...", "rolling=50 stack");
imageCalculator("Divide create 32-bit stack", "num","den");

// set the properties of images
setSlice(12);
run("Enhance Contrast", "saturated=0.35");
run("Yellow");
Stack.setXUnit("um");
run("Properties...", "channels=1 slices=1 frames="+nSlices
+" pixel_width=1.266 pixel_height=1.266 voxel_depth=1.266");
run("16-bit");
	
// save the processed images in the img folder
saveAs("Tiff", folder_script+"../img/s41_ros_bgsub50.tif");

