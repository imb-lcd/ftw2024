close("*"); close("Results"); close("ROI Manager");

// export the images for outlining wave
folder = "ftw_paper_figures_v2/fig5_erastin_titration";
wells   = newArray(8,16,21,24);
frames = "8-9";

for (i = 0; i < wells.length; i++) {
	open("D:/"+folder+"/img/s"+wells[i]+"_ros_ff1_10.tif");
	run("Duplicate...", "duplicate range="+frames);
	run("Image Sequence... ", "dir=D:/"+folder+"/img/s"+wells[i]+"/for_outline/"+
	" format=TIFF name=ros_t start=1 digits=1");
	close("*");
}


