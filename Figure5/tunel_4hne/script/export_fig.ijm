close("*"); close("Results"); close("ROI Manager");
close("filename.csv");

//working_folder = "G:/whole_mount_tunel";
working_folder = "Z:/Chia-Chou/20231229_whole_mount_tunel";

run("Table... ", "open="+working_folder+"/script/filename.csv");
/**/
open(working_folder+"/img/sobel3_median2_xy3.tif");
Stack.setXUnit("um");
Stack.setYUnit("um");
run("Properties...", "channels=1 slices=1 frames=1 pixel_width=0.339 pixel_height=0.339");

//makeRectangle(1606, 6591, 4730, 2709);
//makeRectangle(1504, 5456, 5232, 3844);
//run("Scale...", "x=0.1227327 y=0.1227327 interpolation=Bilinear average create");
// 0.1227327 = 0.339/2.7621
run("Scale...", "x=0.36819231151459 y=0.36819231151459 interpolation=Bilinear average create");
//run("Rotate... ", "angle=-10 grid=1 interpolation=Bilinear enlarge");
// 0.36819811 = 0.339/0.9207145
close("sobel3_median2_xy3.tif");
run("Yellow Hot"); setMinAndMax(84,154);
//run("Green"); setMinAndMax(84,114);
//makeRectangle(340, 169, 2706, 4058);
makeRectangle(228, 78, 2916, 3660);
run("Crop");
run("RGB Color");
saveAs("Tiff", working_folder+"/fig/4HNE.tif");
//makeRectangle(205, 1862, 1938, 1393);
//makeRectangle(205, 1862, 1938, 1126);
makeRectangle(317, 1940, 1938, 1126);
run("Crop");
saveAs("Tiff", working_folder+"/fig/4HNE_zoomIn.tif");

working_folder = "Z:/Chia-Chou/20231229_whole_mount_tunel";
open(working_folder+"/img/MAX_day_7_5_s4.tif");
run("Rotate... ", "angle=14 grid=1 interpolation=Bilinear enlarge");
run("Cyan Hot");
setMinAndMax(1,60);
setMinAndMax(3,25);
//makeRectangle(1092, 453, 2320, 3660);
makeRectangle(1092, 453, 2320, 3585);
run("Crop");
//run("Canvas Size...", "width=2916 height=4058 position=Center zero");
run("Canvas Size...", "width=2916 height=3660 position=Bottom-Center zero");
run("RGB Color");
saveAs("Tiff", working_folder+"/fig/TUNEL.tif");
run("Scale Bar...", "width=500 height=200 thickness=50 font=200 bold");
saveAs("Tiff", working_folder+"/fig/TUNEL_scaleBar.tif");
//makeRectangle(205, 1862, 1938, 1393);
//makeRectangle(205, 1862, 1938, 1126);
makeRectangle(317, 1940, 1938, 1126);
run("Crop");
saveAs("Tiff", working_folder+"/fig/TUNEL_zoomIn.tif");
run("Scale Bar...", "width=200 height=200 thickness=25 font=100 bold");
saveAs("Tiff", working_folder+"/fig/TUNEL_zoomIn_scaleBar.tif");

run("Images to Stack", "use");
run("Make Montage...", "columns=3 rows=1 scale=1 border=0");

/*
open(working_folder+"/img/MAX_day_7_5_s1.tif");
run("Cyan Hot");
setMinAndMax(1,60);
run("Flip Horizontally");

makeRectangle(91, 55, 875, 1353);
run("Crop");
//makeRectangle(69, 621, 647, 462);
//run("Crop");
run("RGB Color");

open(working_folder+"/img/MAX_day_7_5_s2.tif");
run("Cyan Hot");
setMinAndMax(1,60);
run("Rotate... ", "angle=17 grid=1 interpolation=Bilinear enlarge");
makeRectangle(444, 170, 852, 1353);
run("Crop");
//makeRectangle(69, 621, 647, 462);
//run("Crop");
run("RGB Color");

run("Images to Stack", "use");
run("Make Montage...", "columns=3 rows=1 scale=1 border=0");
*/
open(working_folder+"/img/MAX_day_7_5_s5.tif");
run("Cyan Hot");
setMinAndMax(1,60);
makeRectangle(44, 64, 832, 1353);
run("Crop");
//makeRectangle(69, 621, 647, 462);
//run("Crop");
run("RGB Color");

open(working_folder+"/img/MAX_day_7_5_s6.tif");
run("Cyan Hot");
setMinAndMax(1,60);
run("Flip Horizontally");
run("Rotate... ", "angle=10 grid=1 interpolation=Bilinear enlarge");
makeRectangle(303, 113, 808, 1353);
run("Crop");
//makeRectangle(69, 621, 647, 462);
//run("Crop");
run("RGB Color");

run("Images to Stack", "use");
run("Make Montage...", "columns=3 rows=1 scale=1 border=0");

/* day 6.5, TUNEL 
open(working_folder+"/img/MAX_day_6_5_s1.tif");
run("Cyan Hot");
setMinAndMax(2,25);
makeRectangle(67, -19, 850, 1243);
run("Crop");
run("Canvas Size...", "width=850 height=1243 position=Bottom-Center zero");
run("RGB Color");
//makeRectangle(244, 476, 440, 628);
makeRectangle(220, 388, 440, 628);
//run("Crop");
//makeRectangle(0, 0, 480, 789);
//saveAs("Tiff", "G:/whole_mount_tunel/fig/day_6_5_tunel.tif");
*/
/*
open(working_folder+"/img/day-6_5_whole_limb.tif");
//makeRectangle(732, 1364, 1440, 2720);
run("Scale...", "x=0.3333333333 y=0.3333333333 interpolation=Bilinear average create");
//makeRectangle(0, 0, 850, 1243);
//run("Crop");
run("RGB Color");
makeRectangle(244, 476, 440, 628);
open(working_folder+"/img/day-6_5_whole_limb.tif");
makeRectangle(732, 1428, 1320, 1884);
//run("Crop");
*/

/* day 7.5, TUNEL 
open(working_folder+"/img/MAX_day_7_5_s3.tif");
//run("Rotate... ", "angle=4 grid=1 interpolation=Bilinear enlarge");
run("Cyan Hot");
setMinAndMax(2,25);
makeRectangle(61, 24, 849, 1632);
run("Crop");
run("RGB Color");
makeRectangle(228, 568, 440, 628);
//saveAs("Tiff", "G:/whole_mount_tunel/fig/day_7_5_tunel.tif");
*/
/**/
open(working_folder+"/img/day-7_8_whole_limb.tif");
run("Scale...", "x=0.333 y=0.333 interpolation=Bilinear average create");
run("RGB Color");
makeRectangle(280, 630, 440, 628);
open(working_folder+"/img/day-7_8_whole_limb.tif");
makeRectangle(840, 1890, 1320, 1884);


/* day 8, TUNEL */
open(working_folder+"/img/MAX_day_8_s1.tif");
run("Flip Horizontally");
run("Cyan Hot");
setMinAndMax(2,25);
//makeRectangle(51, 81, 891, 2261);
makeRectangle(51, 67, 891, 1753);
//makeRectangle(61, 24, 849, 1632);
//makeRectangle(67, -19, 850, 1243);
run("Crop");
//run("Canvas Size...", "width=850 height=1243 position=Bottom-Center zero");
run("RGB Color");
makeRectangle(172, 728, 440, 628);
//saveAs("Tiff", "G:/whole_mount_tunel/fig/day_8_tunel.tif");

/* */
open(working_folder+"/img/day-8_whole_limb.tif");
run("Scale...", "x=0.333 y=0.333 interpolation=Bilinear average create");
run("Canvas Size...", "width=891 height=1753 position=Center zero");
//makeRectangle(43, 14, 800, 1739);
//makeRectangle(-21, 0, 891, 1753);
//makeRectangle(13, 0, 832, 4632);
//makeRectangle(0, 0, 850, 1243);
//run("Crop");
run("RGB Color");
makeRectangle(172, 728, 440, 628);
open(working_folder+"/img/day-8_whole_limb.tif");
makeRectangle(455, 2184, 1320, 1884);