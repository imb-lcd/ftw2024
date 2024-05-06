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

folder = File.directory();
print(folder);

setBatchMode("hide");

signal = newArray("ros","ros","dic","cy5");
for (i = 1; i < 4; i++) {
	open(folder+"../raw/s12c"+i+"_ORG.tif");
	
	// get background for flatfield correction
	rename("raw");
	setSlice(1);
	run("Duplicate...", " ");
	rename("background");
	run("Select All");
	run("Measure");
	meanLv = getResult("Mean", 0);
	print(meanLv);
	close("Results");
	
	// flatfield correction
	selectWindow("background");
	run("Gaussian Blur...", "sigma=10");
	selectWindow("raw");
	run("Calculator Plus", "i1=raw i2=background operation=[Divide: i2 = (i1/i2) x k1 + k2] k1="+meanLv+" k2=0 create");
	
	// save processed images
	close("\\Others"); rename("Result");
	saveAs("Tiff", folder+"../img/s12_"+signal[i]+"_ff1.tif");
}
