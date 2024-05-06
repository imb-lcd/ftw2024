close("*"); close("Results"); close("ROI Manager");

// set the folder containing the raw images to be processed
folder = "ftw_paper_figures_v2/fig5_erastin_titration";

/* snapshot */
close("*");
open("D:/"+folder+"/img/wavefront_10uM_s24_ros_diff.tif");
setMinAndMax(18, 18+255);
run("Yellow")
run("RGB Color");
saveAs("Tiff", "D:/"+folder+"/fig/wavefront_10uM.tif");

open("D:/"+folder+"/img/wavefront_5uM_s8_ros_diff.tif");
setMinAndMax(18, 18+255);
run("Yellow")
run("RGB Color");
saveAs("Tiff", "D:/"+folder+"/fig/wavefront_5uM.tif");

open("D:/"+folder+"/img/wavefront_2.5uM_s16_ros_diff.tif");
setMinAndMax(18, 18+255);
run("Yellow")
run("RGB Color");
saveAs("Tiff", "D:/"+folder+"/fig/wavefront_2.5uM.tif");

open("D:/"+folder+"/img/wavefront_1.25uM_s21_ros_diff.tif");
setMinAndMax(18, 18+255);
run("Yellow")
run("RGB Color");
saveAs("Tiff", "D:/"+folder+"/fig/wavefront_1.25uM.tif");



// 10uM
open("D:/"+folder+"/img/s24_cy5_ff1_10.tif");
setSlice(9); run("Duplicate...", " "); run("Median...", "radius=2"); 
run("Cyan Hot"); setMinAndMax(217-13, 472-13);
rename("cy5");

open("D:/"+folder+"/img/s24_ros_ff1_10.tif");
rename("ros");
selectWindow("ros");setSlice(9);run("Duplicate...", " ");
selectWindow("ros");setSlice(8);run("Duplicate...", " ");
imageCalculator("Subtract create", "ros-1","ros-2");
run("Median...", "radius=2");
setMinAndMax(45-26, 90-26);
run("Yellow");
rename("dros");
run("Merge Channels...", "c1=cy5 c2=dros create");
run("RGB Color");
saveAs("Tiff", "D:/"+folder+"/fig/10uM.tif");
close("*");

// 5uM
open("D:/"+folder+"/img/s8_cy5_ff1_10.tif");
setSlice(9); run("Duplicate...", " "); run("Median...", "radius=2"); 
run("Cyan Hot"); setMinAndMax(217-13, 472-13);
rename("cy5");

open("D:/"+folder+"/img/s8_ros_ff1_10.tif");
rename("ros");
selectWindow("ros");setSlice(9);run("Duplicate...", " ");
selectWindow("ros");setSlice(8);run("Duplicate...", " ");
imageCalculator("Subtract create", "ros-1","ros-2");
run("Median...", "radius=2");
setMinAndMax(45-26, 90-26);
run("Yellow");
rename("dros");
run("Merge Channels...", "c1=cy5 c2=dros create");
run("RGB Color");
saveAs("Tiff", "D:/"+folder+"/fig/5uM.tif");
close("*");

// 2.5uM
open("D:/"+folder+"/img/s16_cy5_ff1_10.tif");
setSlice(9); run("Duplicate...", " "); run("Median...", "radius=2"); 
run("Cyan Hot"); setMinAndMax(217-13, 472-13);
rename("cy5");

open("D:/"+folder+"/img/s16_ros_ff1_10.tif");
rename("ros");
selectWindow("ros");setSlice(9);run("Duplicate...", " ");
selectWindow("ros");setSlice(8);run("Duplicate...", " ");
imageCalculator("Subtract create", "ros-1","ros-2");
run("Median...", "radius=2");
setMinAndMax(45-26, 90-26);
run("Yellow");
rename("dros");
run("Merge Channels...", "c1=cy5 c2=dros create");
run("RGB Color");
saveAs("Tiff", "D:/"+folder+"/fig/2.5uM.tif");
close("*");

// 1.25uM
open("D:/"+folder+"/img/s21_cy5_ff1_10.tif");
setSlice(9); run("Duplicate...", " "); run("Median...", "radius=2"); 
run("Cyan Hot"); setMinAndMax(217-13, 472-13);
rename("cy5");

open("D:/"+folder+"/img/s21_ros_ff1_10.tif");
rename("ros");
selectWindow("ros");setSlice(9);run("Duplicate...", " ");
selectWindow("ros");setSlice(8);run("Duplicate...", " ");
imageCalculator("Subtract create", "ros-1","ros-2");
run("Median...", "radius=2");
setMinAndMax(45-26, 90-26);
run("Yellow");
rename("dros");
run("Merge Channels...", "c1=cy5 c2=dros create");
run("RGB Color");
saveAs("Tiff", "D:/"+folder+"/fig/1.25uM.tif");
run("Scale Bar...", "width=500 height=200 thickness=20 font=100 color=White background=None location=[Lower Right] horizontal bold");

close("*");

// 0.6uM
open("D:/"+folder+"/img/s38_cy5_ff1_10.tif");
setSlice(9); run("Duplicate...", " "); run("Median...", "radius=2"); 
run("Cyan Hot"); setMinAndMax(217-13, 472-13);
rename("cy5");

open("D:/"+folder+"/img/s38_ros_ff1_10.tif");
rename("ros");
selectWindow("ros");setSlice(9);run("Duplicate...", " ");
selectWindow("ros");setSlice(8);run("Duplicate...", " ");
imageCalculator("Subtract create", "ros-1","ros-2");
run("Median...", "radius=2");
setMinAndMax(45-26, 90-26);
run("Yellow");
rename("dros");
run("Merge Channels...", "c1=cy5 c2=dros create");
run("RGB Color");
saveAs("Tiff", "D:/"+folder+"/fig/0.6uM.tif");
close("*");

// 0.3uM
open("D:/"+folder+"/img/s37_cy5_ff1_10.tif");
setSlice(9); run("Duplicate...", " "); run("Median...", "radius=2"); 
run("Cyan Hot"); setMinAndMax(217-13, 472-13);
rename("cy5");

open("D:/"+folder+"/img/s37_ros_ff1_10.tif");
rename("ros");
selectWindow("ros");setSlice(9);run("Duplicate...", " ");
selectWindow("ros");setSlice(8);run("Duplicate...", " ");
imageCalculator("Subtract create", "ros-1","ros-2");
run("Median...", "radius=2");
setMinAndMax(45-26, 90-26);
run("Yellow");
rename("dros");
run("Merge Channels...", "c1=cy5 c2=dros create");
run("RGB Color");
saveAs("Tiff", "D:/"+folder+"/fig/0.3uM.tif");
close("*");
