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
folder = File.directory();
print(folder);
wells   = newArray("6","6");
signals = newArray("dic","cy5");
ch      = newArray(1,2);
// pxSize  = 1.266;

for (i = 0; i < wells.length; i++) {
	// load raw image
	open(folder+"../raw/s"+wells[i]+"c"+ch[i]+"_ORG.tif");
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
	
	// for re-stitch and alignment	
	close("\\Others");
	if (getHeight()==3000) {
		// 3*3
		startX = newArray(0,1000,2000,2000,1000,0,0,1000,2000);
		startY = newArray(0,0,0,1000,1000,1000,2000,2000,2000);
	}
	if (getHeight()==2000) {
		// 2*2
		startX = newArray(0,1000,1000,0);
		startY = newArray(0,0,1000,1000);
	}
	for (j = 0; j < startX.length; j++) {
		selectWindow("Result");
		makeRectangle(startX[j], startY[j], 1000, 1000); run("Duplicate...", "duplicate");
		rename("tile"+(j+1));
		setSlice(nSlices-1);
		resetMinAndMax();
		run("Enhance Contrast", "saturated=0.35");
		saveAs("Tiff", folder+"../img/s"+wells[i]+"/"+signals[i]+"_m"+(j+1)+"_ff1_10.tif");
	}
	close("*");
}
