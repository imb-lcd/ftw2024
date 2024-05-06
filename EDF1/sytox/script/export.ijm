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

// set the folder containing the images to be exported
folder = File.directory();
print(folder);

setBatchMode("hide");

// load cy5 image
open(folder+"../img/s12_cy5_ff1.tif");
Stack.setXUnit("um");
run("Properties...", "channels=1 slices=1 frames=22 pixel_width=1.26 pixel_height=1.26 voxel_depth=1.26");
rename("cy5");
run("Median...", "radius=2 stack");
run("Cyan Hot");
setMinAndMax(250, 500);
setMinAndMax(250, 800);

// load sytox images
open(folder+"../img/s12_ros_ff1.tif");
Stack.setXUnit("um");
run("Properties...", "channels=1 slices=1 frames=22 pixel_width=1.26 pixel_height=1.26 voxel_depth=1.26");
rename("sytox");
run("Median...", "radius=2 stack");
run("Orange Hot");
setMinAndMax(0, 18000);
setMinAndMax(1500, 45000);

// load dic images
open(folder+"../img/s12_dic_ff1.tif");
Stack.setXUnit("um");
run("Properties...", "channels=1 slices=1 frames=22 pixel_width=1.26 pixel_height=1.26 voxel_depth=1.26");
run("Median...", "radius=2 stack");
rename("dic");
setMinAndMax(0, 2000);
setMinAndMax(0, 10000);

run("Merge Channels...", "c1=dic c2=cy5 c3=sytox create");

setBatchMode("exit and display");

makeRectangle(838, 1078, 300, 300);

run("Duplicate...", "duplicate frames=6-11");
run("Flip Horizontally", "stack");


