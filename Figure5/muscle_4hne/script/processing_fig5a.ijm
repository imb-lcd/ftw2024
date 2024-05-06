close("*"); close("Results"); close("ROI Manager");

folder = "E:/20230801_hannah_limb_IF/raw/muscle_4hne_transverse/tif/";
/*
// save as a multipage tif file
File.openSequence("E:/20230801_hannah_limb_IF/raw/muscle_4hne_transverse/tif/", " filter=(c1)");
rename("4HNE");
run("Yellow");
setMinAndMax(0,16);
File.openSequence("E:/20230801_hannah_limb_IF/raw/muscle_4hne_transverse/tif/", " filter=(c2)");
rename("Muscle");
run("Cyan Hot");
setMinAndMax(0,182);
run("Merge Channels...", "c1=4HNE c2=Muscle create");
saveAs("Tiff", "E:/20230801_hannah_limb_IF/raw/muscle_4hne_transverse/muscle_4hne_transverse.tif");
*/


/*
// determine size of median filter
for (r = 0; r < 11; r++) {
	open(folder+"../muscle_4hne_transverse.tif");
	run("Median...", "radius="+r);
	run("Z Project...", "projection=[Max Intensity]");
	setSlice(1);
	setMinAndMax(3,18);
	setSlice(2);
	setMinAndMax(0,100);	
	run("RGB Color");
	label = "r="+r;
	setForegroundColor(255, 255, 255);
	run("Label...", "format=Text starting=0 interval=1 x=0 y=0 font=200 text=&label range=1-2");
	rename("maxproj_median_r"+r);
	close("muscle*");
}
run("Concatenate...", "open image1=maxproj_median_r0 image2=maxproj_median_r1 image3=maxproj_median_r2 image4=maxproj_median_r3 image5=maxproj_median_r4 image6=maxproj_median_r5 image7=maxproj_median_r6 image8=maxproj_median_r7 image9=maxproj_median_r8 image10=maxproj_median_r9 image11=maxproj_median_r10");
saveAs("Tiff", folder+"../muscle_4hne_transverse_median.tif");
close("*");
*/

// rotate the image
// angle_rot = 41.0628 by PCA of the pixels whose intensity >10
open(folder+"../muscle_4hne_transverse.tif");
run("Median...", "radius=1");
run("Z Project...", "projection=[Max Intensity]");
setSlice(1);
run("Green");
// setMinAndMax(3,18); // yellow
setMinAndMax(3,20); // green
setSlice(2);
run("Magenta");
// setMinAndMax(0,100); // cyan hot
setMinAndMax(0,80); // magenta
// run("RGB Color");
run("Rotate... ", "angle=-41.06 grid=1 interpolation=Bilinear");
