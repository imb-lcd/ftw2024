run("Close All");
open("Y:/1_1 LCD People/Hannah/2023/1024/processed_images/muscle_4hne_longitudinal_s2_Final.tif");
Stack.setXUnit("um");
Stack.setYUnit("um");
Stack.setZUnit("um");
run("Properties...", "channels=2 slices=1 frames=1 pixel_width=0.921 pixel_height=0.921 voxel_depth=15");
makeRectangle(796, 285, 6975, 2232);
run("Crop");
run("Yellow");
run("RGB Color");
saveAs("Tiff", "Y:/1_1 LCD People/Hannah/2023/1024/processed_images/muscle_4hne_longitudinal_s2_Final.tif (RGB).tif");

run("Close All");
open("Y:/1_1 LCD People/Hannah/2023/1024/processed_images/muscle_4hne_longitudinal_s1_Final.tif");
Stack.setXUnit("um");
Stack.setYUnit("um");
Stack.setZUnit("um");
run("Properties...", "channels=2 slices=1 frames=1 pixel_width=0.921 pixel_height=0.921 voxel_depth=15");
run("Rotate... ", "angle=7.40 grid=1 interpolation=Bilinear enlarge");
makeRectangle(44, 1417, 6538, 1671);
run("Crop");
run("Canvas Size...", "width=6975 height=2232 position=Center zero");
run("Yellow");
run("RGB Color");
saveAs("Tiff", "Y:/1_1 LCD People/Hannah/2023/1024/processed_images/muscle_4hne_longitudinal_s1_Final.tif (RGB).tif");

run("Close All");
open("Y:/1_1 LCD People/Hannah/2023/1024/processed_images/transverse/s3_Final.tif");
run("Yellow");
// 2712*1452
run("RGB Color");
run("Canvas Size...", "width=2712 height=1784 position=Center zero");
saveAs("Tiff", "Y:/1_1 LCD People/Hannah/2023/1024/processed_images/transverse/s3_Final.tif (RGB).tif");

run("Close All");
open("Y:/1_1 LCD People/Hannah/2023/1024/processed_images/transverse/s4_Final.tif");
run("Yellow");
// 2028*1784
getPixelSize(unit, pixelWidth, pixelHeight);
run("RGB Color");
run("Canvas Size...", "width=2712 height=1784 position=Center zero");
saveAs("Tiff", "Y:/1_1 LCD People/Hannah/2023/1024/processed_images/transverse/s4_Final.tif (RGB).tif");

run("Close All");
open("Y:/1_1 LCD People/Hannah/2023/1024/processed_images/muscle_4hne_transverse_Final.tif");
Stack.setXUnit(unit);
Stack.setYUnit(unit);
Stack.setZUnit(unit);
run("Properties...", "channels=2 slices=1 frames=1 pixel_width="+pixelWidth+" pixel_height="+pixelHeight+" voxel_depth=10");
run("Yellow");
makeRectangle(29, 177, 1920, 1682);
run("RGB Color");
run("Canvas Size...", "width=2712 height=1784 position=Center zero");
saveAs("Tiff", "Y:/1_1 LCD People/Hannah/2023/1024/processed_images/muscle_4hne_transverse_Final.tif (RGB).tif");