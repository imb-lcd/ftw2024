close("*"); close("Results"); close("ROI Manager");

// set working folder and image names for processing
working_folder = "G:/limb_quantification_working_folder/";
working_folder = "Z:/Chia-Chou/20231204_fiber_quantification";
img_name = newArray("main_control_xy4","supp_control_xy5","supp_control_xy7",
"main_long_xy11","supp_long_xy1","supp_long_xy2","supp_long_xy3","supp_long_xy10");
img_type = newArray("subset_fiber_image","subset_fiber_mask","binary_fiber");
//img_type = newArray("subset_fiber_image_rotated","subset_fiber_mask_rotated","binary_fiber_rotated");

setBatchMode("hide");

for (i = 3; i < img_name.length-1; i++) {
	// load binary fiber
	print(img_name[i]+", load binary fiber start");
	open(working_folder+"/img/"+img_name[i]+"_binary_fiber.tif");		
	rename("binary_fiber");
	
	// orientation analysis
	print(img_name[i]+", orientation analysis start");
	n = nSlices;
	
	for (j = 0; j < n; j++) {
		selectWindow("binary_fiber");
		setSlice(j+1);
		run("Duplicate...", " ");
		run("OrientationJ Analysis", "tensor=2.0 gradient=0 hsb=on hue=Orientation sat=Coherency bri=Original-Image orientation=on radian=off ");
		selectImage("OJ-Orientation-1");
		if (j==0) {
			rename("angle");
		} else {
			run("Concatenate...", "  title=angle open image1=angle image2=OJ-Orientation-1");
		}
		close("OJ*");
		close("binary_fiber-1");
		print((j+1)+"/"+n+" is done.");
	}
	//setBatchMode("exit and display");
	//selectWindow("binary_fiber");
	//run("OrientationJ Analysis", "tensor=2.0 gradient=0 hsb=on hue=Orientation sat=Coherency bri=Original-Image orientation=on radian=off ");
	//selectImage("OJ-Orientation-1");
	saveAs("Tiff", working_folder+"/img/"+img_name[i]+"_binary_fiber_orientation.tif");
	
	close("*"); close("Results"); close("ROI Manager");
}
