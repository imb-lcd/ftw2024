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

// set the folder containing the raw images to be processed
// folder = "ftw_paper_figures_v2/fig1_cellROX";
folder = File.directory()+"..";
print(folder);
wells   = newArray(   30,   30,   30,   25,   25,   28,   28,   29,   29);
signals = newArray("ros","cy5","dic","ros","cy5","ros","cy5","ros","cy5");
ch      = newArray(    1,    2,    3,    1,    2,    1,    2,    1,    2);

for (i = 0; i < wells.length; i++) {
	// load raw image
	open(folder+"/raw/s"+wells[i]+"c"+ch[i]+"_ORG.tif");
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
	+" pixel_width=1.266 pixel_height=1.266 voxel_depth=1.266");
	
	// save the processed images in the img folder
	saveAs("Tiff", folder+"/img/s"+wells[i]+"_"+signals[i]+"_ff1_10.tif");
	
	close("*");

}
