close("*"); close("Results"); close("ROI Manager");

// set the folder containing the raw images to be processed
folder = "ftw_paper_figures_v2/fig5_erastin_titration";
Table.open("D:/"+folder+"/data/preprocess.csv");

for (i = 0; i < Table.size; i++) {
	// set parameters
	fname = Table.getString("imgname", i); // filename of the image stack to be processed
	well = Table.get("well", i); // the well where the image stack is obtained
	ch = Table.get("ch", i); // the channel of the image stack
	signal = Table.getString("signal", i); // the signal of the channel	
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
	+" pixel_width="+pxSize+" pixel_height="+pxSize+" voxel_depth=1");
	
	// save the processed images in the img folder
	saveAs("Tiff", "D:/"+folder+"/img/s"+well+"_"+signal+"_ff1_10.tif");
	
	close("*");

}
