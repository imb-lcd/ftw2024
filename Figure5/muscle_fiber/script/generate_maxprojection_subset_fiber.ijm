close("*"); close("Results"); close("ROI Manager");

// set working folder and image names for processing
//working_folder = "G:/limb_quantification_working_folder/";
working_folder = "Z:/Chia-Chou/20231204_fiber_quantification/";
img_name = newArray("main_control_xy4","supp_control_xy5","supp_control_xy7",
"main_long_xy11","supp_long_xy1","supp_long_xy2","supp_long_xy3","supp_long_xy10");

//setBatchMode("hide");

img_type = newArray("fiber_image","fiber_image_rotated","subset_fiber_image","subset_fiber_image_rotated");
img_type = newArray("subset_fiber_image","orientation_to_rotate");
img_type = img_type[0];

rotation_angle = newArray(-24,19,16,-16,-16,-11,7,-21);

lb = newArray(5,5,10,5,5,5,10,10);
ub = newArray(50,50,50,70,60,30,70,70);

// makeRectangle(188, 0, 1113, 1892); // xy5
// makeRectangle(268, 0, 1260, 3953); // xy1
// makeRectangle(150, 0, 1069, 2496); // xy10
// makeLine(114, 1956, 1362, 1686); // xy2

//setBatchMode("hide");
for (i = 0; i < img_name.length; i++) {
	// load image
	//print(img_name[i]+", load image start");
	open(working_folder+"img/"+img_name[i]+"_"+img_type+".tif");
	print(img_name[i]);
	getVoxelSize(width, height, depth, unit);
	print(width+", "+height+", "+depth+", "+unit);
	getDimensions(width, height, channels, slices, frames);
	print(slices);
	close("*");
	
	
}
setBatchMode("exit and display");

for (i = 0; i < img_name.length; i++) {
	// load image
	print(img_name[i]+", load image start");
	open(working_folder+"img/"+img_name[i]+"_"+img_type+".tif");
	//open(working_folder+"img/to_rotate/v1/"+img_name[i]+"_"+img_type+".tif");
	rename("source");
	
	run("Z Project...", "projection=[Max Intensity]");
	run("Enhance Contrast", "saturated=0.35");	
	run("Rotate... ", "angle="+rotation_angle[i]+" grid=1 interpolation=None enlarge");
	
	/*
	setAutoThreshold("Moments dark no-reset");
	setOption("BlackBackground", true);
	run("Convert to Mask");
	run("Select Bounding Box (guess background color)");
	getSelectionBounds(x, y, width, height);
	
	selectWindow("source");
	run("Z Project...", "projection=[Max Intensity]");
	run("Rotate... ", "angle="+rotation_angle[i]+" grid=1 interpolation=None enlarge");
	run("Enhance Contrast", "saturated=0.35");
	makeRectangle(x, y, width, height);
	print(x+","+y+","+width+","+height);
	if (i==1) {
		//makeRectangle(465, 252, 1112, 1892);
		makeRectangle(438, 244, 1113, 1893);
	} else if (i==2) {
		//makeRectangle(543, 146, 1241, 2067);
		makeRectangle(358, 112, 1255, 1985);
	} else if (i==3) {
		//makeRectangle(327, 175, 1238, 2598);
		makeRectangle(376, 153, 1080, 2565);
		// makeLine(104, 2052, 992, 1748);
	} else if (i==4) {
		//makeRectangle(760, 24, 1255, 3953);
		makeRectangle(750, 25, 1295, 3949);
	} else if (i==6) {
		//makeRectangle(429, 19, 1285, 3076);
		makeRectangle(236, 17, 1326, 3020);
	} else if (i==7) {
		//makeRectangle(657, 98, 1072, 2496);
		makeRectangle(616, 85, 1022, 2495);
	}
	*/
	if (i==0) {
		makeRectangle(408,263,1141,1812);
	} else if (i==1) {
		makeRectangle(438, 244, 1113, 1893);
	} else if (i==2) {
		makeRectangle(358, 112, 1255, 1985);
	} else if (i==3) {
		makeRectangle(376, 153, 1080, 2565);
	} else if (i==4) {
		makeRectangle(750, 25, 1295, 3949);
	} else if (i==5) {
		makeRectangle(251,61,1487,3367);
	} else if (i==6) {
		makeRectangle(236, 17, 1326, 3020);
	} else if (i==7) {
		makeRectangle(616, 85, 1022, 2495);
	}
	
	run("Crop");
	if (i==4 || i==5 || i==6) {
		run("Scale...", "x=0.67 y=0.67 interpolation=Bilinear average create");
	}
	rename(img_name[i]); close("MAX_source");
	
	//setMinAndMax(5,50);
	
	if (i==0) {
		rename("max_proj");
	} else {
		run("Concatenate...", "  title=max_proj open image1=max_proj image2="+img_name[i]+" image3=[-- None --]");
	}

	//saveAs("Tiff", working_folder+"img/MAX_"+img_name[i]+"_"+img_type+".tif");
	
	//close("*"); close("Results"); close("ROI Manager");
	close("source");
	
	/*
	ws = newArray(1,2,3,4,5,6,7,8,9,10);
	for (j = 0; j < ws.length; j++) {
		selectWindow("MAX_source");
		run("OrientationJ Analysis", "tensor="+ws[j]+" gradient=0 color-survey=on hsb=on hue=Orientation sat=Coherency bri=Original-Image radian=on ");
		rename("ws");
		
		if (j==0) {
			rename("ws_test");			
		} else {
			run("Concatenate...", "  title=ws_test open image1=ws_test image2=ws image3=[-- None --]");
		}

	}
	*/
	
}
if (img_type=="subset_fiber_image") {
	//run("mpl-inferno");
	run("Magenta Hot"); setMinAndMax(5,50);
}

n = nSlices;
for (i = 0; i < n; i++) {
	setSlice(i+1);
	run("Set Label...", "label="+img_name[i]);
}

run("RGB Color");
run("Image Sequence... ", "dir="+working_folder+"fig/ format=TIFF name=subset_v2_ start=1 digits=1");

//run("Canvas Size...", "width=1255 height=2646 position=Center zero");
//makeRectangle(204, 406, 1816, 1144);