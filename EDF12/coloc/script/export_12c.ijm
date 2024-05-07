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

i = 10;
sample = Table.getString("sname", i);
ch = Table.getString("c1",i);
open(working_folder+"/img/"+sample+"_"+ch+".tif");
run("Z Project...", "projection=[Max Intensity]");
run("Subtract Background...", "rolling=50");
rename(ch);

ch = Table.getString("c2",i);
open(working_folder+"/img/"+sample+"_"+ch+".tif");
run("Z Project...", "projection=[Max Intensity]");
rename(ch);

ch = Table.getString("c3",i);
open(working_folder+"/img/"+sample+"_"+ch+".tif");
run("Z Project...", "projection=[Max Intensity]");
rename(ch);

close(sample+"*");

/* 4HNE (green) and dead muscle (magenta) 
run("Merge Channels...", "c2=4HNE c6=dead_muscle create keep ignore");
setSlice(1);
setMinAndMax(5,25);
setSlice(2);
setMinAndMax(5,20);

run("RGB Color");
saveAs("Tiff", working_folder+"/fig/"+sample+"_"+Table.getString("c1",i)+"_composite.tif");

selectImage("Composite");
run("Split Channels");
selectWindow("C1-Composite");
run("RGB Color");
saveAs("Tiff", working_folder+"/fig/"+sample+"_"+Table.getString("c1",i)+".tif");

selectWindow("C2-Composite");
run("RGB Color");
saveAs("Tiff", working_folder+"/fig/"+sample+"_"+Table.getString("c3",i)+".tif");

close(sample+"*");
*/
/* TUNEL (green) and dead muscle (magenta) 
run("Merge Channels...", "c5=TUNEL c6=dead_muscle create keep ignore");
setSlice(1);
setMinAndMax(3,255);
setSlice(2);
setMinAndMax(5,20);

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
/* TUNEL (green) and 4HNE (magenta) */
//run("Merge Channels...", "c2=4HNE c5=TUNEL create keep ignore");
run("Merge Channels...", "c7=4HNE c5=TUNEL create keep ignore");
setSlice(2);
//setMinAndMax(5,25);
setMinAndMax(9,11);
setSlice(1);
//setMinAndMax(3,255);
setMinAndMax(33,94);

run("RGB Color");
saveAs("Tiff", working_folder+"/fig/"+sample+"_composite_"+Table.getString("c2",i)+"_"+Table.getString("c1",i)+".tif");
/**/
selectImage("Composite");
run("Split Channels");
selectWindow("C2-Composite");
run("RGB Color");
saveAs("Tiff", working_folder+"/fig/"+sample+"_"+Table.getString("c2",i)+".tif");
selectWindow("C1-Composite");
run("RGB Color");
saveAs("Tiff", working_folder+"/fig/"+sample+"_"+Table.getString("c1",i)+".tif");

close(sample+"*");
close("C1*");