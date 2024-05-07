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

//working_folder = "Z:/Chia-Chou/20240103_feedack_loop_perturbation";
working_folder = File.directory()+"..";
print(folder);
name = "a549_erastin_fac";
/**/
//open(working_folder+"/raw/2023-06-12-z1-Resistant-PFL-FAC-01-Create Image Subset-01.czi");
open(working_folder+"/img/"+name+".tif");
getPixelSize(unit, pixelWidth, pixelHeight);
close("*");

/*
name = "a549_erastin_fac";
setBatchMode("hide");
File.openSequence(working_folder+"/raw/"+name+"/", " filter=(c1_ORG)");
makeRectangle(1920, 954, 980, 940);
run("Crop");
run("BaSiC ", "processing_stack="+name+" flat-field=None dark-field=None shading_estimation=[Estimate shading profiles] shading_model=[Estimate flat-field only (ignore dark-field)] setting_regularisationparametes=Automatic temporal_drift=Ignore correction_options=[Compute shading and correct images] lambda_flat=0.50 lambda_dark=0.50");
close("\\Others");
run("Cyan Hot");
setMinAndMax(680, 1280);
Stack.setXUnit(unit);
Stack.setYUnit(unit);
run("Properties...", "channels=1 slices="+nSlices+" frames=1 pixel_width="+pixelWidth+" pixel_height="+pixelHeight);
run("Median...", "radius=2 stack");

n = nSlices;
for (i = 0; i < n; i++) {
	setSlice(i+1);
	run("Set Label...", "label=["+i+"h]");
}
saveAs("Tiff", working_folder+"/img/"+name+".tif");
setBatchMode("exit and display"); close("*");
*/
/*
name = "a549_erastin";
setBatchMode("hide");
File.openSequence(working_folder+"/raw/"+name+"/", " filter=(c1_ORG)");
makeRectangle(1920, 954, 980, 940);
run("Crop");
run("BaSiC ", "processing_stack="+name+" flat-field=None dark-field=None shading_estimation=[Estimate shading profiles] shading_model=[Estimate flat-field only (ignore dark-field)] setting_regularisationparametes=Automatic temporal_drift=Ignore correction_options=[Compute shading and correct images] lambda_flat=0.50 lambda_dark=0.50");
close("\\Others");
run("Cyan Hot");
setMinAndMax(720, 1280);
Stack.setXUnit(unit);
Stack.setYUnit(unit);
run("Properties...", "channels=1 slices="+nSlices+" frames=1 pixel_width="+pixelWidth+" pixel_height="+pixelHeight);
run("Median...", "radius=2 stack");

n = nSlices;
for (i = 0; i < n; i++) {
	setSlice(i+1);
	run("Set Label...", "label=["+i+"h]");
}
saveAs("Tiff", working_folder+"/img/"+name+".tif");
setBatchMode("exit and display"); close("*");
*/
/**/
name = "u2os_erastin_fac";
setBatchMode("hide");
for (i = 1; i < 55; i++) {
	run("Grid/Collection stitching", "type=[Positions from file] order=[Defined by TileConfiguration] directory="+working_folder+
	"/raw/"+name+"/tiles/ layout_file=TileConfiguration.registered."+String.pad(i, 2)+
	".txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap subpixel_accuracy computation_parameters=[Save memory (but be slower)] image_output=[Fuse and display]");
	
	if (i==1) {
		rename(name);
	} else {
		run("Concatenate...", "  title=u2os_erastin_fac open image1=u2os_erastin_fac image2=Fused");
	}
}
setBatchMode("exit and display");
//File.openSequence(working_folder+"/raw/"+name+"/", " filter=(c1_ORG)");
//makeRectangle(672, 952, 737, 737);
makeRectangle(679, 24, 737, 737);
run("Crop");
run("Properties...", "channels=1 slices="+nSlices+" frames=1 pixel_width=1.0000 pixel_height=1.0000 voxel_depth=1.0000");
run("BaSiC ", "processing_stack="+name+" flat-field=None dark-field=None shading_estimation=[Estimate shading profiles] shading_model=[Estimate flat-field only (ignore dark-field)] setting_regularisationparametes=Automatic temporal_drift=Ignore correction_options=[Compute shading and correct images] lambda_flat=0.50 lambda_dark=0.50");
close("\\Others");
run("Cyan Hot");
setMinAndMax(720,1280);
Stack.setXUnit(unit);
Stack.setYUnit(unit);
run("Properties...", "channels=1 slices="+nSlices+" frames=1 pixel_width="+pixelWidth+" pixel_height="+pixelHeight);
run("Median...", "radius=2 stack");

n = nSlices;
for (i = 0; i < n; i++) {
	setSlice(i+1);
	run("Set Label...", "label=["+i+"h]");
}
saveAs("Tiff", working_folder+"/img/"+name+".tif");
setBatchMode("exit and display"); close("*");

/*
name = "u2os_erastin";
setBatchMode("hide");
File.openSequence(working_folder+"/raw/"+name+"/", " filter=(c1_ORG)");
makeRectangle(1036, 2072, 737, 737);
run("Crop");
run("BaSiC ", "processing_stack="+name+" flat-field=None dark-field=None shading_estimation=[Estimate shading profiles] shading_model=[Estimate flat-field only (ignore dark-field)] setting_regularisationparametes=Automatic temporal_drift=Ignore correction_options=[Compute shading and correct images] lambda_flat=0.50 lambda_dark=0.50");
close("\\Others");
run("Cyan Hot");
setMinAndMax(820,1280);
Stack.setXUnit(unit);
Stack.setYUnit(unit);
run("Properties...", "channels=1 slices="+nSlices+" frames=1 pixel_width="+pixelWidth+" pixel_height="+pixelHeight);
run("Median...", "radius=2 stack");

n = nSlices;
for (i = 0; i < n; i++) {
	setSlice(i+1);
	run("Set Label...", "label=["+i+"h]");
}
saveAs("Tiff", working_folder+"/img/"+name+".tif");
setBatchMode("exit and display"); close("*");
*/