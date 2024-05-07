close("*"); close("Results"); close("ROI Manager");

// set the folder containing the images to be exported
folder = "ftw_paper_figures_v2/fig4_erastin_priming";

// load iron image
open("D:/"+folder+"/img/iron/iron_bgsub50.tif");
rename("iron");
run("Median...", "radius=2 stack");

// set imaging condition
Stack.setXUnit("um");
Stack.setYUnit("um");
run("Properties...", "channels=1 slices=1 frames=160 pixel_width=0.633 pixel_height=0.633 voxel_depth=1");

// set the parameters for showing images
index = newArray(131, 60, 11, 51, 83, 86, 26, 157); // high to low erastin
x = newArray(390,115,645,315,650, 85,705,700); // x-coordinate for cropping
y = newArray(545,685,695, 40,535,555,680,710); // y-coordinate for cropping
run("mpl-inferno");
setMinAndMax(20,150);

// zoom-in view
for (i = 0; i < index.length; i++) {
	
	// crop
	selectWindow("iron"); close("\\Others");
	setSlice(index[i]);
	makeRectangle(x[i], y[i], 281, 281);
	run("Duplicate...", "use");
	
	// save cropped images
	saveAs("Tiff", "D:/"+folder+"/fig/iron_lv"+(8-i)+"_cropped.tif");
	if (i==0) {
		run("Scale Bar...", "width=50 height=10 font=30 color=White background=None location=[Upper Left] bold");
		saveAs("Tiff", "D:/"+folder+"/fig/iron_lv8_cropped_w_scaleBar.tif");
	}
	
}
