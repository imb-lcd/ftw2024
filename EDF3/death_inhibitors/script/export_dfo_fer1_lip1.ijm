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

//working_folder = "Z:/Chia-Chou/20240108_DFO_Fer1_Lip1_photoinduction";
working_folder = File.directory();
working_folder = working_folder+"..";
print(folder);

/**/
name = "DFO";
//name = "Lip1";
//name = "Fer1";

open(working_folder+"/img/"+name+"_nuclearDye.tif");
setMinAndMax(148, 195);
if (name == "Fer1") {
	setMinAndMax(150, 205);
}
center = newArray(1401.9,1474.2);
makeRectangle(center[0]-375, center[1]-375, 750, 750);
run("Duplicate...", "duplicate range=1-5");
run("Properties...", "channels=1 slices="+nSlices+" frames=1");
run("BaSiC ", "processing_stack="+name+"_nuclearDye-1.tif flat-field=None dark-field=None shading_estimation=[Estimate shading profiles] shading_model=[Estimate flat-field only (ignore dark-field)] setting_regularisationparametes=Automatic temporal_drift=Ignore correction_options=[Compute shading and correct images] lambda_flat=0.50 lambda_dark=0.50");
run("Median...", "radius=2 stack");

run("RGB Color");
run("Image Sequence... ", "select="+working_folder+"/img/ dir="+working_folder+"/img/ format=TIFF name="+name+"_frame start=1 digits=1");

