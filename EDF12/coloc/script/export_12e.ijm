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
working_folder = "Z:/Chia-Chou/20231219_colocalization";
working_folder = File.directory()+"..";
print(folder);

run("Table... ", "open="+working_folder+"/script/filename.csv");

i = 2;
sample = Table.getString("sname", i);
ch = Table.getString("c1",i);
open(working_folder+"/img/"+sample+"_"+ch+".tif");
run("Z Project...", "projection=[Max Intensity]");
rename(ch);

ch = Table.getString("c2",i);
open(working_folder+"/img/"+sample+"_"+ch+".tif");
run("Z Project...", "projection=[Max Intensity]");
rename(ch);

run("Subtract Background...", "rolling=200");


//ch = Table.getString("c3",i);
//open(working_folder+"/img/"+sample+"_"+ch+".tif");
//run("Z Project...", "projection=[Max Intensity]");
//rename(ch);

close(sample+"*");

run("Merge Channels...", "c6=dead_muscle c7=4HNE create keep ignore");
run("Median...", "radius=2");
//makeRectangle(13, 2, 5716, 3912);
//run("Crop");
setSlice(1);
setMinAndMax(0,65);
//setMinAndMax(5,70);
setSlice(2);
setMinAndMax(49,94);

run("RGB Color");
saveAs("Tiff", working_folder+"/fig/"+sample+"_"+Table.getString("c1",i)+"_composite.tif");

selectImage("Composite");
run("Split Channels");
selectWindow("C1-Composite");
run("RGB Color");
saveAs("Tiff", working_folder+"/fig/"+sample+"_"+Table.getString("c2",i)+".tif");

selectWindow("C2-Composite");
run("RGB Color");
saveAs("Tiff", working_folder+"/fig/"+sample+"_"+Table.getString("c1",i)+".tif");

close(sample+"*");

run("Merge Channels...", "c2=TUNEL c6=dead_muscle create keep ignore");
setSlice(1);
setMinAndMax(0,120);
setSlice(2);
setMinAndMax(20,60);

run("RGB Color");
saveAs("Tiff", working_folder+"/fig/"+sample+"_"+Table.getString("c2",i)+"_composite.tif");

selectImage("Composite");
run("Split Channels");
selectWindow("C1-Composite");
run("RGB Color");
saveAs("Tiff", working_folder+"/fig/"+sample+"_"+Table.getString("c2",i)+".tif");

close(sample+"*");
close("C2*");

/* TUNEL (green) and 4HNE (magenta) */
run("Merge Channels...", "c2=TUNEL c6=4HNE create keep ignore");
setSlice(1);
setMinAndMax(0,120);
setSlice(2);
setMinAndMax(15,50);

run("RGB Color");
saveAs("Tiff", working_folder+"/fig/"+sample+"_composite_"+Table.getString("c2",i)+"_"+Table.getString("c1",i)+".tif");

selectImage("Composite");
run("Split Channels");
selectWindow("C2-Composite");
run("RGB Color");
saveAs("Tiff", working_folder+"/fig/"+sample+"_"+Table.getString("c1",i)+"_magenta.tif");

close(sample+"*");
close("C1*");