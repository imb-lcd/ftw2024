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

// working_folder = "Z:/Chia-Chou/20240108_H2O2_wave_propagation";
working_folder = File.directory();
print(folder);
names = newArray("h2o2_1204_s10","h2o2_1204_s15","h2o2_1206_s15","h2o2_1206_s17");

//setBatchMode("hide");
/*
for (i = 0; i < names.length; i++) {
	open(working_folder+"/img/"+names[i]+"_c1_BaSiC.tif");
	run("Median...", "radius=2 stack");
	run("Cyan Hot");
	setMinAndMax(250,450);
	run("RGB Color");
	
	//run("Image Sequence... ", "dir="+working_folder+"/fig/image/ format=TIFF name="+names[i]+"_c1_BaSiC_frame start=1 digits=2");
	
	n = nSlices;
	for (j = 0; j < n; j++) {
		setSlice(j+1);
		run("Set Label...", "label=[frame"+String.pad(j+1, 2)+"]");
	}
	run("Label...", "format=Label starting=0 interval=1 x=5 y=5 font=300 text=[] range=1-"+n);
	run("AVI... ", "compression=JPEG frame=3 save="+working_folder+"/img/"+names[i]+"_c1_BaSiC.avi");
	
	close("*");
}
*/
for (i = 1; i < names.length; i++) {
	open(working_folder+"../img/"+names[i]+"_c1_BaSiC.tif");
	run("Median...", "radius=2 stack");
	run("Cyan Hot");
	setMinAndMax(200,450);
	open(working_folder+"../img/"+names[i]+"_c2_BaSiC.tif");
	run("Median...", "radius=2 stack");
	run("Yellow");
	setMinAndMax(150,250);
	run("Merge Channels...", "c1="+names[i]+"_c1_BaSiC.tif c2="+names[i]+"_c2_BaSiC.tif create");
	run("RGB Color");
	
	//run("Image Sequence... ", "dir="+working_folder+"/fig/image/ format=TIFF name="+names[i]+"_c1_BaSiC_frame start=1 digits=2");
	
	n = nSlices;
	for (j = 0; j < n; j++) {
		setSlice(j+1);
		run("Set Label...", "label=[frame"+String.pad(j+1, 2)+"]");
	}
	run("Label...", "format=Label starting=0 interval=1 x=5 y=5 font=300 text=[] range=1-"+n);
	run("AVI... ", "compression=JPEG frame=3 save="+working_folder+"../img/"+names[i]+"_BaSiC.avi");
	
	close("*");
}