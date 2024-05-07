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

//working_folder = "Z:/Chia-Chou/20240108_H2O2_wave_propagation";
working_folder = File.directory();
print(folder);
names = newArray("h2o2_1204_s10","h2o2_1204_s15","h2o2_1206_s15","h2o2_1206_s17");

/* separate channels 
setBatchMode("hide");
for (i = 0; i < names.length; i++) {
	name = names[i];
	
	open(working_folder+"/img/"+name+".tif");
	run("Split Channels");
	
	selectImage("C1-"+name+".tif");
	saveAs("Tiff", working_folder+"/img/"+name+"_c1.tif");
	selectImage("C2-"+name+".tif");
	saveAs("Tiff", working_folder+"/img/"+name+"_c2.tif");
	close("*");
}
*/
/* correct background 
setBatchMode("hide");
for (i = 0; i < names.length; i++) {
	name = names[i];
	
	open(working_folder+"/img/"+name+"_c1.tif");
	getPixelSize(unit, pixelWidth, pixelHeight);
	getDimensions(width, height, channels, slices, frames);
	run("Properties...", "channels=1 slices="+frames+" frames=1");
	
	run("BaSiC ", "processing_stack="+name+"_c1.tif flat-field=None dark-field=None shading_estimation=[Estimate shading profiles] shading_model=[Estimate flat-field only (ignore dark-field)] setting_regularisationparametes=Automatic temporal_drift=Ignore correction_options=[Compute shading and correct images] lambda_flat=0.50 lambda_dark=0.50");
	
	selectImage("Corrected:"+name+"_c1.tif");
	Stack.setXUnit(unit);
	run("Properties...", "channels=1 slices=1 frames="+frames+" pixel_width=1.26 pixel_height=1.26 voxel_depth=1.0000");
	run("Cyan Hot");
	setMinAndMax(200, 1200);
	saveAs("Tiff", working_folder+"/img/"+name+"_c1_BaSiC.tif");
	
	close("*");
}

for (i = 0; i < names.length; i++) {
	name = names[i];
	
	open(working_folder+"/img/"+name+"_c2.tif");
	getPixelSize(unit, pixelWidth, pixelHeight);
	getDimensions(width, height, channels, slices, frames);
	run("Properties...", "channels=1 slices="+frames+" frames=1");
	
	run("BaSiC ", "processing_stack="+name+"_c2.tif flat-field=None dark-field=None shading_estimation=[Estimate shading profiles] shading_model=[Estimate flat-field only (ignore dark-field)] setting_regularisationparametes=Automatic temporal_drift=Ignore correction_options=[Compute shading and correct images] lambda_flat=0.50 lambda_dark=0.50");
	
	selectImage("Corrected:"+name+"_c2.tif");
	Stack.setXUnit(unit);
	run("Properties...", "channels=1 slices=1 frames="+frames+" pixel_width=1.26 pixel_height=1.26 voxel_depth=1.0000");
	run("Yellow Hot");
	setMinAndMax(150, 300);
	saveAs("Tiff", working_folder+"/img/"+name+"_c2_BaSiC.tif");
	
	close("*");
}
*/
/* outline high intensity region 
setBatchMode("hide");
for (i = 0; i < names.length; i++) {
	name = names[i];
	
	open(working_folder+"/img/"+name+"_c2_BaSiC.tif");
	
	run("Gaussian Blur...", "sigma=50 stack");
	setThreshold(150, 65535, "raw");
	setOption("BlackBackground", true);
	run("Convert to Mask", "background=Dark black create");
	run("Fill Holes", "stack");
	
	run("Analyze Particles...", "size=20000-Infinity show=Masks stack");
	run("Invert LUT");
	saveAs("Tiff", working_folder+"/img/"+name+"_c2_BaSiC_mask.tif");
	close("*");
}
for (i = 0; i < names.length; i++) {
	name = names[i];
	
	open(working_folder+"/img/"+name+"_c1_BaSiC.tif");
	
	run("Gaussian Blur...", "sigma=50 stack");
	setThreshold(222, 65535, "raw");
	setOption("BlackBackground", true);
	run("Convert to Mask", "background=Dark black create");
	run("Fill Holes", "stack");
	
	run("Analyze Particles...", "size=20000-Infinity show=Masks stack");
	run("Invert LUT");
	saveAs("Tiff", working_folder+"/img/"+name+"_c1_BaSiC_mask.tif");
	close("*");
}
*/