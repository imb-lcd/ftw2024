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

/* 0.15uM, xy47 */
run("Close All");
setBatchMode("hide");

folder = File.directory();
print(folder);
open(folder+"../raw/rsl3_s3_nuc.tif");

rename("source");
getPixelSize(unit, pixelWidth, pixelHeight);
getDimensions(width, height, channels, slices, frames);
int = Stack.getFrameInterval();

run("Properties...", "channels=1 slices="+frames+" frames=1");
run("BaSiC ", "processing_stack=source flat-field=None dark-field=None shading_estimation=[Estimate shading profiles] shading_model=[Estimate flat-field only (ignore dark-field)] setting_regularisationparametes=Automatic temporal_drift=Ignore correction_options=[Compute shading and correct images] lambda_flat=0.50 lambda_dark=0.50");
Stack.setXUnit(unit);
Stack.setYUnit(unit);
run("Properties...", "channels=1 slices=1 frames="+frames+" pixel_width="+pixelWidth+" pixel_height="+pixelHeight+" voxel_depth=1.0 frame=["+int+" sec]");

run("Cyan Hot");
setSlice(nSlices);
run("Enhance Contrast", "saturated=0.35");
saveAs("Tiff", folder+"../img/rsl3_s3_nuc_BaSiC.tif");

/* v1 */
//makeRectangle(1980, 1165, 1088, 880);
//run("Duplicate...", "duplicate range=1-44 use");
//saveAs("Tiff", "Z:/Chia-Chou/20240119_RSL3/img/rsl3_s3_nuc_BaSiC_cropped.tif");
makeRectangle(1980, 1165, 1000, 1000);
run("Duplicate...", "duplicate range=1-44 use");
saveAs("Tiff", folder+"../img/rsl3_s3_nuc_BaSiC_cropped.tif");

selectWindow("rsl3_s3_nuc_BaSiC.tif");
makeRectangle(1944, 1865, 1000, 1000);
run("Duplicate...", "duplicate range=1-44 use");
saveAs("Tiff", folder+"../img/rsl3_s3_nuc_BaSiC_cropped_site2.tif");

selectWindow("rsl3_s3_nuc_BaSiC.tif");
makeRectangle(1872, 353, 1000, 1000);
run("Duplicate...", "duplicate range=1-44 use");
saveAs("Tiff", folder+"../img/rsl3_s3_nuc_BaSiC_cropped_site3.tif");

run("Close All");
setBatchMode("hide");
open(folder+"../raw/rsl3_s3_dic.tif");

rename("source");
getPixelSize(unit, pixelWidth, pixelHeight);
getDimensions(width, height, channels, slices, frames);
int = Stack.getFrameInterval();

run("Properties...", "channels=1 slices="+frames+" frames=1");
run("BaSiC ", "processing_stack=source flat-field=None dark-field=None shading_estimation=[Estimate shading profiles] shading_model=[Estimate flat-field only (ignore dark-field)] setting_regularisationparametes=Automatic temporal_drift=Ignore correction_options=[Compute shading and correct images] lambda_flat=0.50 lambda_dark=0.50");
Stack.setXUnit(unit);
Stack.setYUnit(unit);
run("Properties...", "channels=1 slices=1 frames="+frames+" pixel_width="+pixelWidth+" pixel_height="+pixelHeight+" voxel_depth=1.0 frame=["+int+" sec]");

setSlice(nSlices);
run("Enhance Contrast", "saturated=0.35");
saveAs("Tiff", folder+"../img/rsl3_s3_dic_BaSiC.tif");

// makeRectangle(1980, 1165, 1088, 880); // v1
makeRectangle(1980, 1165, 1000, 1000);
run("Duplicate...", "duplicate range=1-44 use");
saveAs("Tiff", folder+"../img/rsl3_s3_dic_BaSiC_cropped.tif");

