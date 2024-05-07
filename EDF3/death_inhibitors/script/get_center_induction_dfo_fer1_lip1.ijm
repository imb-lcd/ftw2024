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

working_folder = "Z:/Chia-Chou/20240108_DFO_Fer1_Lip1_photoinduction";
working_folder = File.directory();
working_folder = working_folder+"..";
print(folder);

open(working_folder+"/img/control.tif");
run("BaSiC ", "processing_stack=control.tif flat-field=None dark-field=None shading_estimation=[Estimate shading profiles] shading_model=[Estimate flat-field only (ignore dark-field)] setting_regularisationparametes=Automatic temporal_drift=Ignore correction_options=[Compute shading and correct images] lambda_flat=0.50 lambda_dark=0.50");
selectImage("Flat-field:control.tif");
setAutoThreshold("Default dark");
setThreshold(1.0300, 1000000000000000000000000000000.0000);
setOption("BlackBackground", true);
run("Convert to Mask");
run("Analyze Particles...", "size=126050-Infinity show=Masks");
run("Invert LUT");
run("Measure");

// center = newArray(1401.9,1474.2) // (x,y)