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
close("filename.csv");

//working_folder = "D:/temp";
//working_folder = "G:/colocalization/20231218/stitched";
//working_folder = "G:/colocalization/20231220";
//working_folder = "Z:/Chia-Chou/20231219_colocalization";
working_folder = File.directory()+"..";
print(folder);

run("Table... ", "open="+working_folder+"/script/filename.csv");

i = 3;
sample = Table.getString("sname", i);
ch = Table.getString("c1",i); // 4HNE
open(working_folder+"/img/"+sample+"_4HNE.tif");
run("Z Project...", "projection=[Max Intensity]");
rename("4HNE");

ch = Table.getString("c2",i); // TUNEL
open(working_folder+"/img/"+sample+"_dead_muscle.tif");
run("Z Project...", "projection=[Max Intensity]");
rename("dead_muscle");

run("Subtract Background...", "rolling=200");

//ch = Table.getString("c3",i);  // dead muscle cells
//open(working_folder+"/img/"+sample+"_"+ch+".tif");
//run("Z Project...", "projection=[Max Intensity]");
//rename(ch);

//close(sample+"*");

/* 4HNE (green) and dead muscle (magenta) 
run("Merge Channels...", "c2=4HNE c6=dead_muscle create keep ignore");
setSlice(1); // 4HNE
setMinAndMax(10,35);
setSlice(2); // dead muscle cells
setMinAndMax(5,30);
*/
/* 4HNE (yellow) and dead muscle (magenta) */
run("Merge Channels...", "c6=dead_muscle c7=4HNE create keep ignore");
run("Median...", "radius=2");
//run("Rotate... ", "angle=4.7 grid=1 interpolation=Bilinear enlarge stack");

//run("Duplicate...", "duplicate slices=50-78");
//run("Z Project...", "projection=[Max Intensity]");
//makeRectangle(606, 828, 4746, 1506); run("Crop");

//makeRectangle(390, 840, 4746, 1506);

setSlice(2); // 4HNE
setMinAndMax(10,35);
setMinAndMax(13,33);
setSlice(1); // dead muscle cells
setMinAndMax(5,30);
setMinAndMax(0,30);
setMinAndMax(3,14);
setMinAndMax(0,15);

run("RGB Color");
saveAs("Tiff", working_folder+"/fig/"+sample+"_4HNE_composite.tif");

selectImage("Composite");
run("Split Channels");
selectWindow("C1-Composite");
run("RGB Color");
saveAs("Tiff", working_folder+"/fig/"+sample+"_dead_muscle.tif");

selectWindow("C2-Composite");
run("RGB Color");
saveAs("Tiff", working_folder+"/fig/"+sample+"_4HNE.tif");

close(sample+"*");

/* TUNEL (green) and dead muscle (magenta) 
run("Merge Channels...", "c5=TUNEL c6=dead_muscle create keep ignore");
setSlice(1);
setMinAndMax(0,70);
setSlice(2);
setMinAndMax(5,30);

run("RGB Color");
saveAs("Tiff", working_folder+"/fig/"+sample+"_"+Table.getString("c2",i)+"_composite.tif");

selectImage("Composite");
run("Split Channels");
selectWindow("C1-Composite");
run("RGB Color");
saveAs("Tiff", working_folder+"/fig/"+sample+"_"+Table.getString("c2",i)+".tif");

close(sample+"*");
close("C2*");
*/

/* TUNEL (cyan) and 4HNE (yellow) */
run("Merge Channels...", "c7=4HNE c5=TUNEL create keep ignore");
setSlice(2);
setMinAndMax(10,35);
setSlice(1);
setMinAndMax(0,70);

makeRectangle(0, 0, 3531, 1506); run("Crop");

run("RGB Color");
saveAs("Tiff", working_folder+"/fig/"+sample+"_composite_"+Table.getString("c2",i)+"_"+Table.getString("c1",i)+".tif");
/**/
selectImage("Composite");
run("Split Channels");
selectWindow("C1-Composite");
run("RGB Color");
saveAs("Tiff", working_folder+"/fig/"+sample+"_"+Table.getString("c2",i)+".tif");

close(sample+"*");
close("C1*");