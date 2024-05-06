close("*"); close("Results"); close("ROI Manager");

folder = "E:/20230801_hannah_limb_IF/raw/muscle_4hne_longitudinal/tif/"; // local
folder = "Z:/Chia-Chou/ftw_paper_figures/figureR17ab_longitudinal_transverse_section/longitudinal/script"; // 2422nas

/*
// save as a multipage tif file
for (i = 1; i < 6; i++) {
	File.openSequence(folder, " filter=(s"+i+"z[0-9]*c1)");
	run("Yellow");
	setMinAndMax(0,60);	
	run("Slice Keeper", "first=4 last=22 increment=1");
	rename("4HNE");
	close("tif");
	File.openSequence(folder, " filter=(s"+i+"z[0-9]*c2)");
	run("Cyan Hot");
	setMinAndMax(0,30);	
	run("Slice Keeper", "first=4 last=22 increment=1");
	rename("Muscle");
	close("tif");
	run("Merge Channels...", "c1=4HNE c2=Muscle create");
	saveAs("Tiff", folder+"../muscle_4hne_longitudinal_s"+i+".tif");
	close("*");
}
*/

/*
// determine size of median filter
for (i = 1; i < 6; i++) {
	for (r = 1; r < 11; r++) {
		open(folder+"../muscle_4hne_longitudinal_s"+i+".tif");
		run("Median...", "radius="+r);
		run("Z Project...", "projection=[Max Intensity]");
		setSlice(1);
		setMinAndMax(0,150);
		setSlice(2);
		setMinAndMax(10,60);
		run("RGB Color");		
		label = "r="+r;
		setForegroundColor(255, 255, 255);
		run("Label...", "format=Text starting=0 interval=1 x=0 y=0 font=250 text=&label range=1-2");
		rename("maxproj_median_r"+r);
		close("muscle*");
	}
	run("Concatenate...", "open image1=maxproj_median_r0 image2=maxproj_median_r1 image3=maxproj_median_r2 image4=maxproj_median_r3 image5=maxproj_median_r4 image6=maxproj_median_r5 image7=maxproj_median_r6 image8=maxproj_median_r7 image9=maxproj_median_r8 image10=maxproj_median_r9 image11=maxproj_median_r10");
	saveAs("Tiff", folder+"../muscle_4hne_longitudinal_s"+i+"_median.tif");
	close("*");
}
*/

// export images
for (i = 1; i < 3; i++) {
	open(folder+"../muscle_4hne_longitudinal_s"+i+".tif");
	run("Median...", "radius=1");
	run("Z Project...", "projection=[Max Intensity]");
	
	// yellow (4HNE) and cyan hot (muscle)
	/*
	setSlice(1);
	setMinAndMax(20,150);
	setSlice(2);
	setMinAndMax(10,60);
	*/
	
	// green (4HNE) and magenta (muscle)
	setSlice(1);
	run("Green");
	setMinAndMax(25,70);
	setSlice(2);
	run("Magenta");
	setMinAndMax(0,40);
	
	// run("RGB Color");		
	rename("maxproj_scene"+i);
	close("muscle*");
	close("MAX_*");
}

