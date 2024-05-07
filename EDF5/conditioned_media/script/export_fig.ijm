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
//close("filename.csv");

/**/
// loading
//working_folder = "Z:/Chia-Chou/20240115_Diffusion_molecule";
working_folder = File.directory()+"..";
print(folder);
run("Table... ", "open="+working_folder+"/script/filename.csv");

/* export */
index  = newArray(  0,  1,   9, 11,  14, 18, 19, 20, 29,   6,  24);
strt_x = newArray(928,556,2140,644,1373,732,840,  0,140,2084,0);
strt_y = newArray(717, 16,1064,  0,1427,922,  8,916,280,2472,0);
//group = newArray(3,2,1,1,2,4,2,2,4);
for (i = 10; i < index.length; i++) {
	fname = Table.getString("fname",index[i]);
	fname = fname.substring(0,fname.indexOf("_nuc_BaSiC"));
	
	// nuclear signal
	open(working_folder+"/img/cropped/"+fname+"_nuc.tif");
	run("RGB Color");
	//getDimensions(width, height, channels, slices, frames);
	//makeRectangle((group[i]%2==0)*width/2, ((group[i]/2)>1)*height/2, width/2, height/2);
	makeRectangle(strt_x[i],strt_y[i],600,600);
	//makeRectangle(0,0,600,600);
	run("Duplicate...", "use");
	saveAs("Tiff", working_folder+"/fig/image/"+fname+"_nuc.tif");
	
	if (i==0) {
		run("Scale Bar...", "width=100 height=50 thickness=10 font=50 bold");
		saveAs("Tiff", working_folder+"/fig/image/"+fname+"_nuc_scaleBar.tif");		
	}
	close("*");
	
	// dic
	open(working_folder+"/img/cropped/"+fname+"_dic.tif");
	run("RGB Color");
	//getDimensions(width, height, channels, slices, frames);
	//makeRectangle((group[i]%2==0)*width/2, ((group[i]/2)>1)*height/2, width/2, height/2);
	makeRectangle(strt_x[i],strt_y[i],600,600);
	run("Duplicate...", "use");
	saveAs("Tiff", working_folder+"/fig/image/"+fname+"_dic.tif");
	close("*");
	
}

/* prepare images */
index = newArray(0,1,9,11,14,18,19,20,29,6,24);
group = newArray(1,3,0,4,0,1,2,4,1,0,0);

//setBatchMode("hide");
for (i = 10; i < index.length; i++) {
	print(i);
	// dic
	fname = Table.getString("fname",index[i]);
	fname = fname.substring(0,fname.indexOf("_nuc_BaSiC"));
	
	open(working_folder+"/img/"+fname+"_dic.tif");
	rename("dic");
	getPixelSize(unit, pixelWidth, pixelHeight);
	getDimensions(width, height, channels, slices, frames);
	int = Stack.getFrameInterval();
	
	run("Properties...", "channels=1 slices="+frames+" frames=1");
	run("BaSiC ", "processing_stack=dic flat-field=None dark-field=None shading_estimation=[Estimate shading profiles] shading_model=[Estimate flat-field only (ignore dark-field)] setting_regularisationparametes=Automatic temporal_drift=Ignore correction_options=[Compute shading and correct images] lambda_flat=0.50 lambda_dark=0.50");
	selectImage("Corrected:dic");	
	Stack.setXUnit(unit);
	Stack.setYUnit(unit);
	run("Properties...", "channels=1 slices=1 frames="+frames+" pixel_width="+pixelWidth+" pixel_height="+pixelHeight+" voxel_depth=1.0000000 frame=["+int+" sec]");
	
	run("Median...", "radius=2 stack");
	run("Enhance Contrast", "saturated=0.35");
	setSlice(Table.get("frame",index[i]));
	
	//i = 3;
	//getPixelSize(unit, pixelWidth, pixelHeight);
	//getDimensions(width, height, channels, slices, frames);
	//group = newArray(1,3,1,4,1,1,2,4,1);
	//print(((group[i]/2)>1));
	//print((group[i]%2==0)*width/2);
	//print((Math.floor(group[i]/2)));
	
	if (group[i]>0) {
		makeRectangle((group[i]%2==0)*width/2, ((group[i]/2)>1)*height/2, width/2, height/2);
	}	
	run("Duplicate...", "use");	
	rename("dic1");	
	run("Set Label...", "label="+fname+"_dic");
	if (i==10) {
		run("Enhance Local Contrast (CLAHE)", "blocksize=127 histogram=256 maximum=3 mask=*None* fast_(less_accurate)");
	}
	//run("RGB Color");
	saveAs("Tiff", "Z:/Chia-Chou/20240115_Diffusion_molecule/img/cropped/"+fname+"_dic.tif");
	
	// nuclear
	name = Table.getString("fname", index[i]);
	open(working_folder+"/img/"+name+".tif");
	frame = Table.get("frame", index[i]);
	run("Slice Keeper", "first="+frame+" last="+frame+" increment=1");
	run("Subtract Background...", "rolling=50");
	run("Median...", "radius=2");
	run("Enhance Contrast", "saturated=0.35");
	
	if (group[i]>0) {
		makeRectangle((group[i]%2==0)*width/2, ((group[i]/2)>1)*height/2, width/2, height/2);
	}
	run("Duplicate...", "use");
	rename("nuc");
	run("Set Label...", "label="+fname+"_nuc");
	
	//run("RGB Color");
	saveAs("Tiff", "Z:/Chia-Chou/20240115_Diffusion_molecule/img/cropped/"+fname+"_nuc.tif");
	
	close("*");
}
//setBatchMode("exit and display");


