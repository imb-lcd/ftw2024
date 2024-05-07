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

//working_folder = "Z:/Chia-Chou/20240115_Diffusion_molecule";
working_folder = File.directory()+"..";
print(folder);

/* no_cell_erastin_nuc 
open(working_folder+"/raw/2023-12-19-z1-supernatant-02-Create Image Subset-03.czi"); j = 1;
*/

/* filtered 
open(working_folder+"/raw/2024-01-08-Z4-supernatant-02-Create Image Subset-02.czi"); j = 1;
*/

/* Catalase 250 U/mL 
open(working_folder+"/raw/2024-01-04-Z4-supernatant-02-Create Image Subset-04.czi"); j = 1;
*/

/* Control 
open(working_folder+"/raw/2023-12-27-z4-supernatant-02-Control.czi"); j = 2;
*/

/* DFO 
open(working_folder+"/raw/2023-12-27-z4-supernatant-02-DFO.czi"); 
sig = newArray("dic","nuc");
prefix = "dfo";
nI = 4;
*/

/* Tempo 
open(working_folder+"/raw/2023-12-27-z4-supernatant-02-Tempo.czi"); j = 2;
*/

/* Trolox 
open(working_folder+"/raw/2023-12-27-z4-supernatant-02-Trolox.czi"); j = 2;
*/

/* Fer-1 
open(working_folder+"/raw/2023-12-27-z4-supernatant-02-Fer1.czi"); j = 2;
*/

/* Tiron */
open(working_folder+"/raw/2023-12-25-z1-supernatant-02-Tiron.czi"); j = 2;


rename("source");
run("Split Channels");
selectImage("C"+j+"-source");
getPixelSize(unit, pixelWidth, pixelHeight);
getDimensions(width, height, channels, slices, frames);
	
run("Properties...", "channels=1 slices="+frames+" frames=1");
run("BaSiC ", "processing_stack=[C"+j+"-source] flat-field=None dark-field=None shading_estimation=[Estimate shading profiles] shading_model=[Estimate flat-field only (ignore dark-field)] setting_regularisationparametes=Automatic temporal_drift=Ignore correction_options=[Compute shading and correct images] lambda_flat=0.50 lambda_dark=0.50");
selectImage("Corrected:C"+j+"-source");
run("Cyan Hot");
setMinAndMax(500, 1200);

Stack.setXUnit(unit);
Stack.setYUnit(unit);
run("Properties...", "channels=1 slices=1 frames="+frames+" pixel_width="+pixelWidth+" pixel_height="+pixelHeight);


