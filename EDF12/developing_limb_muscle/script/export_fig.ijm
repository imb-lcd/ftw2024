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

//working_folder = "Z:/Chia-Chou/20231024_muscle_at_different_stage";
working_folder = File.directory()+"..";
print(folder);

samples = newArray("6_5","7","7_8","8");
angles = newArray(-10.7,-33,18.8,-13);
x = newArray(492,1104,1308,540, 1224,1960,2024,1000);
y = newArray(1172,384,564,336, 2536,2208,2448,2576);
w = newArray(2550,2550,2550,2550, 1440,1440,1440,1440);
//h = newArray(4960,5964,5789,5855,2720,2720,2720,2720);
h = newArray(3730,4620,4900,5265, 2720,2720,2720,2720);
imgname = newArray("MAX_C1-xy5-6.5-day-Stitching-z25.czi - xy5-6.5-day-Stitching-z25.czi #1.tif",
"MAX_C1-xy1-7-day-Stitching-z27.czi - xy1-7-day-Stitching-z27.czi #1.tif",
"MAX_C1-xy4-7.5day-Stitching-z26.czi - xy4-7.5day-Stitching-z26.czi #1.tif",
"MAX_C1-xy3-8-day-Stitching-z25.czi - xy3-8-day-Stitching-z25.czi #1.tif");

//setBatchMode("hide");

for (i = 0; i < samples.length; i++) {
	open(working_folder+"/img/"+imgname[i]);
	getPixelSize(unit, pixelWidth, pixelHeight);
	print(pixelWidth+" "+unit);
	close();
	
	//i = 0;
	print("load day_"+samples[i]);
	open(working_folder+"/img/fixed_day_"+samples[i]+".tif");
	run("Median...", "radius=2");
	run("Rotate... ", "angle="+angles[i]+" grid=1 interpolation=Bilinear enlarge");
	makeRectangle(x[i], y[i], w[i], h[i]);
	run("Duplicate...", " ");
	rename("source");
	//run("mpl-inferno");
	run("Magenta");
	setMinAndMax(0, 50);
	saveAs("Tiff", working_folder+"/img/day-"+samples[i]+"_whole_limb.tif");
	run("RGB Color");
	Stack.setXUnit(unit);
	run("Properties...", "channels=1 slices=1 frames=1 pixel_width="+pixelWidth+" pixel_height="+pixelHeight);
	
	print("export day_"+samples[i]+"_whole_limb");
	//saveAs("Tiff", working_folder+"/fig/day-"+samples[i]+"_whole_limb.tif");
	//close();
	
	makeRectangle(x[i+samples.length], y[i+samples.length], w[i+samples.length], h[i+samples.length]);
	run("Duplicate...", " ");
	rename("source");
	//run("mpl-inferno");
	run("Magenta");
	setMinAndMax(0, 50);
	saveAs("Tiff", working_folder+"/img/day-"+samples[i]+"_zoomIn.tif");
	run("RGB Color");
	Stack.setXUnit(unit);
	run("Properties...", "channels=1 slices=1 frames=1 pixel_width="+pixelWidth+" pixel_height="+pixelHeight);
	
	print("export day_"+samples[i]+"_zoomIn");
	saveAs("Tiff", working_folder+"/fig/day-"+samples[i]+"_zoomIn.tif");
	
	close("*"); 
}

