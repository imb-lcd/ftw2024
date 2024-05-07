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

// working_folder = "Z:/Chia-Chou/20240103_feedack_loop_perturbation";
working_folder = File.directory()+"..";
print(folder);
/**/
name = newArray("a549_erastin_fac","a549_erastin","u2os_erastin_fac","u2os_erastin");
range = newArray("20-42","20-42","27-33","27-33");
cname = newArray("A549, Erastin+FAC","A549, Erastin","U2OS, Erastin+FAC","U2OS, Erastin");

//setBatchMode("hide");
for (i = 3; i < name.length; i++) {
	open(working_folder+"/img/"+name[i]+".tif");
	if (i==2) {
		setMinAndMax(680, 2200);
	}
	if (i==3) {
		setMinAndMax(780, 2200);
	}
	run("Duplicate...", "duplicate range="+range[i]+" use");
	
	if (i==1) {
		run("Subtract Background...", "rolling=50 stack");
		setMinAndMax(50, 650);
	}
	
	run("RGB Color");
	n = nSlices;
	for (j = 0; j < n; j++) {
		setSlice(j+1);
		run("Set Label...", "label=["+j+"h]");
	}
	run("Image Sequence... ", "select="+working_folder+"/fig/ dir="+working_folder+"/fig/ format=TIFF name="+name[i]+"_frame start=1 digits=2");
	setSlice(1);
	run("Duplicate...", "use");
	run("Scale Bar...", "width=100 height=100 font=18 horizontal bold label");
	saveAs("Tiff", working_folder+"/fig/"+name[i]+"_scaleBar.tif");
	
	/* for movie 
	run("Label...", "format=Label starting=0 interval=1 x=5 y=5 font=36 text=[] range=1-"+n);
	run("Label...", "format=Text starting=0 interval=1 x=263 y=5 font=36 text="+cname[i]+" range=1-"+n);
	run("Scale Bar...", "width=100 height=100 font=18 horizontal bold label");
	run("AVI... ", "compression=JPEG frame=3 save="+working_folder+"/img/"+name[i]+".avi");
	*/
	
	close("*");
}
