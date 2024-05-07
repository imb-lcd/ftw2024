close("*"); close("Results"); close("ROI Manager");

// set the folder containing the images to be exported
folder = "ftw_paper_figures_v2/fig4_erastin_priming";
folder = File.directory()+"..";
print(folder);

// set the parameters for showing images
index = newArray(13,14,15,29,17,18,39,1); // low to high erastin
x =  newArray(55-8,61-8,60-8,51-8,62-8,65-8,62-8,60-8); // x-coordinate for cropping
y =  newArray(75-6,44-6,96-6,81-6,89-6,65-6,80-6,94-6); // y-coordinate for cropping

// zoom-in view
for (i = 7; i < index.length; i++) {
	
	// load images, cy5
	open(folder+"/raw/s"+index[i]+"c1_ORG.tif");
	run("Subtract Background...", "rolling=50 stack");
	rename("well"+index[i]);
	run("MultiStackReg", "stack_1=well"+index[i]+" action_1=[Load Transformation File]"+
	" file_1=["+folder+"/data/TransformationMatrices_xy"+index[i]+
	".txt] stack_2=None action_2=Ignore file_2=[] transformation=[Rigid Body]");
	run("Median...", "radius=2 stack");
	
	setSlice(40);
	makeRectangle(x[i], y[i], 900, 900);
	run("Crop");
	
	run("Cyan Hot");
	setMinAndMax(0, 650);
	run("Make Substack...", "slices=38,39,41,44,50,53");
	rename("cy5");
	
	// load images
	open(folder+"/raw/s"+index[i]+"c2_ORG.tif");
	run("Subtract Background...", "rolling=50 stack");
	rename("well"+index[i]);
	run("MultiStackReg", "stack_1=well"+index[i]+" action_1=[Load Transformation File]"+
	" file_1=["+folder+"/data/TransformationMatrices_xy"+index[i]+
	".txt] stack_2=None action_2=Ignore file_2=[] transformation=[Rigid Body]");
	run("Median...", "radius=2 stack");
	
	setSlice(40);
	makeRectangle(x[i], y[i], 900, 900);
	run("Crop");
	
	run("Yellow");
	setMinAndMax(0, 225);
	run("Make Substack...", "slices=38,39,41,44,50,53");
	rename("ros");
	
	run("Merge Channels...", "c1=cy5 c2=ros create");
	close("\\Others");
	
}
