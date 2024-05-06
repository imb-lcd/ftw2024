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
folder = "ftw_paper_figures_v2/fig3_chemical_perturbation";
Table.open("D:/"+folder+"/data/filename.csv");

for (i = 0; i < Table.size; i++) {
	// set parameters
	fname = Table.getString("imgname", i); // filename of the image stack to be processed
	pxSize = Table.get("pxSize", i); // pixel size of the image stack
	
	// load raw image
	open(fname);
	rename("source");
	
	// measure the mean intensity of the first frame
	setSlice(1); 
	run("Select All"); 
	run("Measure");
	meanLv = getResult("Mean", 0);	print(meanLv);	close("Results");	
	
	// background estimation using the first frame
	run("Duplicate...", " "); rename("background");
	run("Gaussian Blur...", "sigma=10");
	
	// flat-field correction based on the background from the first frame
	selectWindow("source");
	run("Calculator Plus", "i1=source i2=background "
	+"operation=[Divide: i2 = (i1/i2) x k1 + k2] k1="+meanLv+" k2=0 create");
	
	// set the properties of images
	Stack.setXUnit("um");
	Stack.setYUnit("um");
	run("Properties...", "channels=1 slices=1 frames="+nSlices
	+" pixel_width="+pxSize+" pixel_height="+pxSize+" voxel_depth=1.266");
	
	// save the processed images in the img folder
	oname = fname.replace("ORG","ff1_10");
	oname = oname.trim;
	saveAs("Tiff", oname);
	
	close("*");

}

/*
run("Table... ", "open=D:/ftw_paper_figures_v2/fig3_chemical_perturbation/data/filename.csv");
IJ.renameResults("filename.csv","Results");
filename = newArray(nResults);
for (i = 0; i < nResults; i++) {
	filename[i] = getResultString("Filename", i);
}
print(filename[78].replace("ORG","ff1_10"));
close("Results");
*/