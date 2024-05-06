/* time 0, global */
close("*"); close("Results"); close("ROI Manager");
File.openSequence("X:/lab_member/Chia-Chou/photoinduction_16/time0_global/selective_z/oxidized/");
makeRectangle(80, 5, 3842, 5649); // remove the black region due to stitching
run("Crop");
run("Stack Focuser ", "enter=3");
run("Median...", "radius=2");
run("Yellow Hot");
setMinAndMax(700, 2400);

File.openSequence("X:/lab_member/Chia-Chou/photoinduction_16/time0_global/selective_z/reduced/");
makeRectangle(80, 5, 3842, 5649); // remove the black region due to stitching
run("Crop");
run("Stack Focuser ", "enter=3");
run("Median...", "radius=2");
run("biop-BrightPink");
setMinAndMax(0, 16000);

run("Merge Channels...", "c1=Focused_reduced c2=Focused_oxidized create");
saveAs("Tiff", "X:/lab_member/Chia-Chou/photoinduction_16/time0_global/selective_z_global.tif");
makeRectangle(1458, 3493, 2048, 2048);
run("Crop");
saveAs("Tiff", "X:/lab_member/Chia-Chou/photoinduction_16/time0_global/selective_z_local.tif");
close("*");

File.openSequence("E:/20230306_Hannah_photoinduction/result/before_global/oxidized/");
makeRectangle(80, 5, 3842, 5649); // remove the black region due to stitching
run("Crop");
run("Stack Focuser ", "enter=3");
run("Median...", "radius=2");
run("Yellow Hot");
setMinAndMax(700, 2400);

File.openSequence("E:/20230306_Hannah_photoinduction/result/before_global/reduced/");
makeRectangle(80, 5, 3842, 5649); // remove the black region due to stitching
run("Crop");
run("Stack Focuser ", "enter=3");
run("Median...", "radius=2");
run("biop-BrightPink");
setMinAndMax(0, 16000);

run("Merge Channels...", "c1=Focused_reduced c2=Focused_oxidized create");
saveAs("Tiff", "X:/lab_member/Chia-Chou/photoinduction_16/time0_global/whole_z_global.tif");
makeRectangle(1458, 3493, 2048, 2048);
run("Crop");
saveAs("Tiff", "X:/lab_member/Chia-Chou/photoinduction_16/time0_global/whole_z_local.tif");

/* time 0,1 */
close("*"); close("Results"); close("ROI Manager");
k = 0;
File.openSequence("X:/lab_member/Chia-Chou/photoinduction_16/time"+k+"/reduced/");
run("Stack Focuser ", "enter=3");
run("Median...", "radius=2");
run("biop-BrightPink");
setMinAndMax(0, 16000);
close("reduced");

File.openSequence("X:/lab_member/Chia-Chou/photoinduction_16/time"+k+"/oxidized/");
run("Stack Focuser ", "enter=3");
run("Median...", "radius=2");
run("Yellow Hot");
setMinAndMax(700, 2400);
close("oxidized");

open("X:/lab_member/Chia-Chou/photoinduction_16/time"+k+"/oxidized_3d_denoising_planaria.tif");
run("16-bit");
run("Stack Focuser ", "enter=3");
run("Median...", "radius=2");
run("Yellow Hot");
setMinAndMax(50000, 65535); // k = 0
if (k==1) {
	setMinAndMax(31000, 56000); // k = 1
}

run("Merge Channels...", "c1=Focused_reduced c2=Focused_oxidized create keep");
saveAs("Tiff", "X:/lab_member/Chia-Chou/photoinduction_16/time"+k+"/no-denoising.tif");
run("Merge Channels...", "c1=Focused_reduced c2=Focused_oxidized_3d_denoising_planaria create");
saveAs("Tiff", "X:/lab_member/Chia-Chou/photoinduction_16/time"+k+"/denoising.tif");

/* time 2,3 */
close("*"); close("Results"); close("ROI Manager");
k = 3;
zType = "selective_z";
File.openSequence("X:/lab_member/Chia-Chou/photoinduction_16/time"+k+"/"+zType+"/reduced/");
run("Stack Focuser ", "enter=3");
run("Median...", "radius=2");
run("biop-BrightPink");
setMinAndMax(0, 16000);
close("reduced");

File.openSequence("X:/lab_member/Chia-Chou/photoinduction_16/time"+k+"/"+zType+"/oxidized/");
run("Stack Focuser ", "enter=3");
run("Median...", "radius=2");
run("Yellow Hot");
setMinAndMax(700, 2400);
close("oxidized");

open("X:/lab_member/Chia-Chou/photoinduction_16/time"+k+"/"+zType+"_oxidized_3d_denoising_planaria.tif");
run("16-bit");
run("Stack Focuser ", "enter=3");
run("Median...", "radius=2");
run("Yellow Hot");
setMinAndMax(16000, 56000);
close(zType+"*");

run("Merge Channels...", "c1=Focused_reduced c2=Focused_oxidized create keep"); rename(zType); 
saveAs("Tiff", "X:/lab_member/Chia-Chou/photoinduction_16/time"+k+"/"+zType+".tif");
run("Merge Channels...", "c1=Focused_reduced c2=Focused_"+zType+"_oxidized_3d_denoising_planaria create"); rename(zType+"_denoising");
saveAs("Tiff", "X:/lab_member/Chia-Chou/photoinduction_16/time"+k+"/"+zType+"_denoising.tif");
close("Focused_oxidized");

zType = "whole_z";
File.openSequence("X:/lab_member/Chia-Chou/photoinduction_16/time"+k+"/"+zType+"/reduced/");
run("Stack Focuser ", "enter=3");
run("Median...", "radius=2");
run("biop-BrightPink");
setMinAndMax(0, 16000);
close("reduced");

File.openSequence("X:/lab_member/Chia-Chou/photoinduction_16/time"+k+"/"+zType+"/oxidized/");
run("Stack Focuser ", "enter=3");
run("Median...", "radius=2");
run("Yellow Hot");
setMinAndMax(700, 2400);
close("oxidized");

open("X:/lab_member/Chia-Chou/photoinduction_16/time"+k+"/"+zType+"_oxidized_3d_denoising_planaria.tif");
run("16-bit");
run("Stack Focuser ", "enter=3");
run("Median...", "radius=2");
run("Yellow Hot");
setMinAndMax(9000, 42000);
close(zType+"*");

run("Merge Channels...", "c1=Focused_reduced c2=Focused_oxidized create keep"); rename(zType);
saveAs("Tiff", "X:/lab_member/Chia-Chou/photoinduction_16/time"+k+"/"+zType+".tif");
run("Merge Channels...", "c1=Focused_reduced c2=Focused_"+zType+"_oxidized_3d_denoising_planaria create"); rename(zType+"_denoising");
saveAs("Tiff", "X:/lab_member/Chia-Chou/photoinduction_16/time"+k+"/"+zType+"_denoising.tif");
close("Focused_oxidized");