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

cond = "Intensity10X";
cond = "Intensity20X";
cond = "Wavelength10X";
cond = "Wavelength20X";

Table.open(folder+"../data/preprocess_"+cond+".csv");

for (i = 0; i < Table.size; i++) {
	// set parameters
	fname = Table.getString("fname", i);
	well = Table.get("well", i);
	ch = Table.get("ch", i);
	signal = Table.getString("signal", i);
	
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
	
	setSlice(3);
	if (signal=="ros") {
		run("Yellow");
	}
	if (signal=="cy5") {
		run("Cyan Hot");
	}
	run("Enhance Contrast", "saturated=0.35");
	
	saveAs("Tiff", folder+"../img/"+cond+"_s"+well+"_"+signal+"_ff1_10.tif");
	close("*");
}
