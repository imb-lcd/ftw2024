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
folder = "ftw_paper_figures_v2/fig4_erastin_priming";

// set the parameters for showing images
index = newArray(13,14,15,29,17,18,39,1); // low to high erastin
x =  newArray(55-8,61-8,60-8,51-8,62-8,65-8,62-8,60-8); // x-coordinate for cropping
y =  newArray(75-6,44-6,96-6,81-6,89-6,65-6,80-6,94-6); // y-coordinate for cropping

// zoom-in view
for (i = 7; i < index.length; i++) {
	
	// load images
	// open("D:/"+folder+"/raw/ros/s"+index[i]+"c2_ORG.tif");
	open("D:/"+folder+"/raw/ros/s"+index[i]+"c1_ORG.tif");
	run("Subtract Background...", "rolling=50 stack");
	rename("well"+index[i]);
	run("MultiStackReg", "stack_1=well"+index[i]+" action_1=[Load Transformation File]"+
	" file_1=[D:/"+folder+"/data/ros/TransformationMatrices/TransformationMatrices_xy"+index[i]+
	".txt] stack_2=None action_2=Ignore file_2=[] transformation=[Rigid Body]");
	
	setSlice(40);
	makeRectangle(x[i], y[i], 900, 900);
	//run("Yellow");
	//setMinAndMax(0, 225);
	run("Cyan Hot");
	setMinAndMax(0, 650);
	run("Duplicate...", "use");
	run("Median...", "radius=2");
	run("RGB Color");
	
	saveAs("Tiff", "D:/"+folder+"/fig/ros_steadystate_lv"+(i+1)+"cropped.tif");
	if (i==0) {
		run("Scale Bar...", "width=50 height=10 font=30 color=White background=None location=[Upper Left] bold");
		saveAs("Tiff", "D:/"+folder+"/fig/ros_steadystate_lv1_cropped_w_scaleBar.tif");
	}
	close("*");
}
