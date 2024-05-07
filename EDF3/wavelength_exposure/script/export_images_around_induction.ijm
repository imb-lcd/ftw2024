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

// set the folder containing the raw images to be processed
// folder = "20220503_light_power_wavelength";
// folder = "ftw_paper_figures_v2/figS3_wavelength_v2";
folder = File.directory();
print(folder);
// cond = "Wavelength20X"; nWell = 4; frame_induction = 2; wells = newArray(1,3,4,2,2,3,3);
cond = "Intensity20X"; nWell = 3; frame_induction = 5; wells = newArray(3,2,3,2,2);
Table.open("D:/"+folder+"/data/export_"+cond+".csv");

/*all wells per wavelength 
for (i = 0; i < Table.size; i++) {
	for (j = 0; j < nWell; j++) {
		well = Table.get("well"+(j+1), i);
		open("D:/"+folder+"/img/"+cond+"_s"+well+"_ros_ff1_10_induction.tif");
		setSlice(frame_induction);
		run("Delete Slice");
		rename((j+1));
	}
	
	if (cond=="Wavelength20X") {
		run("Concatenate...", "  image1=1 image2=2 image3=3 image4=4");
		run("Median...", "radius=2 stack");
		setMinAndMax(150,500);
		run("RGB Color");
		run("Make Montage...", "columns=7 rows=4 scale=1 border=12");
		rename(Table.getString("light", i));
		//saveAs("Tiff", "D:/"+folder+"/fig/"+Table.getString("light", i)+".tif");
		//close("*");
	}
	if (cond=="Intensity20X") {
		run("Concatenate...", "  image1=1 image2=2 image3=3");
		run("Median...", "radius=2 stack");
		setMinAndMax(250,800);
		run("RGB Color");
		
		//run("Slice Remover", "first=1 last=30 increment=10");
		//run("Slice Remover", "first=3 last=27 increment=9");
		//run("Slice Remover", "first=7 last=24 increment=8");
		//run("Slice Remover", "first=7 last=21 increment=7");
		
		
		run("Make Montage...", "columns=10 rows=3 scale=1 border=12");
		rename(Table.getString("duration", i));
		//saveAs("Tiff", "D:/"+folder+"/fig/"+Table.getString("light", i)+".tif");
		//close("*");
	}
	
}
*/

/* one well per wavelength 
if (cond=="Wavelength20X") {
for (i = 0; i < Table.size; i++) {
	well = Table.get("well"+wells[i], i);
	open("D:/"+folder+"/img/Wavelength20X_s"+well+"_ros_ff1_10_induction.tif");
	setSlice(2);
	run("Delete Slice");
	rename(Table.getString("light", i));
	run("Median...", "radius=2 stack");
}
run("Concatenate...", "  image1=358 image2=434 image3=495 image4=509 image5=550 image6=587 image7=646");
setMinAndMax(150,500);
run("RGB Color");
rename("source");

Stack.setXUnit("um");
run("Properties...", "channels=1 slices=49 frames=1 pixel_width=0.629 pixel_height=0.629 voxel_depth=0.629");
run("Duplicate...", " ");
run("Scale Bar...", "width=200 height=200 thickness=20 font=50 color=White background=None location=[Lower Right] horizontal bold");
saveAs("Tiff", "D:/"+folder+"/fig/Wavelength20X_scalebar.tif");
close();

for (i = 1; i < 6; i++) {
	selectWindow("source");
	run("Slice Keeper", "first="+i+" last=49 increment=7");
	//run("Make Montage...", "columns=7 rows=1 scale=1 border=12");
	//saveAs("Tiff", "D:/"+folder+"/fig/frame"+i+".tif");
	run("Image Sequence... ", "select=D:/"+folder+"/fig/ dir=D:/"+folder+"/fig/ "+
	"format=TIFF name=wavelength_frame"+i+"_L start=1 digits=1");
}
}
*/
/**/
if (cond=="Intensity20X") {
for (i = 0; i < Table.size; i++) {
	well = Table.get("well"+wells[i], i);
	//open("D:/"+folder+"/img/"+cond+"_s"+well+"_ros_ff1_10_induction.tif");	
	//setSlice(frame_induction);
	//run("Delete Slice");
	
	open("D:/"+folder+"/img/"+cond+"_s"+well+"_cy5_ff1_10.tif");
	
	setSlice(frame_induction-1);
	run("Delete Slice");
	rename(Table.getString("duration", i));
	run("Median...", "radius=2 stack");
}
run("Concatenate...", "  image1=0.625 image2=1.250 image3=2.500 image4=5.000 image5=10.000");
//setMinAndMax(250,800);
setMinAndMax(400,655);
run("RGB Color");
rename("source");

/*
Stack.setXUnit("um");
run("Properties...", "channels=1 slices="+nSlices+" frames=1 pixel_width=0.633 pixel_height=0.633 voxel_depth=0.633");
run("Duplicate...", " ");
run("Scale Bar...", "width=200 height=200 thickness=20 font=50 color=White background=None location=[Lower Right] horizontal bold");
saveAs("Tiff", "D:/"+folder+"/fig/"+cond+"_scalebar.tif");
close();
*/

for (i = 2; i < 8; i++) {
	selectWindow("source");
	run("Slice Keeper", "first="+i+" last="+nSlices+" increment=9");
	//run("Make Montage...", "columns=7 rows=1 scale=1 border=12");
	//saveAs("Tiff", "D:/"+folder+"/fig/frame"+i+".tif");
	run("Image Sequence... ", "select=D:/"+folder+"/fig/ dir=D:/"+folder+"/fig/ "+
	"format=TIFF name=intensity_cy5_frame"+i+"_D start=1 digits=1");
}
}
