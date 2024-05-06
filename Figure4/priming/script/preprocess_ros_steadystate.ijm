close("*"); close("Results"); close("ROI Manager");

// set the folder containing the images to be exported
folder = "ftw_paper_figures_v2/fig4_erastin_priming";

// load images
for (i = 0; i < 40; i++) {
	
	// ros
	open("D:/"+folder+"/raw/ros/s"+(i+1)+"c2_ORG.tif");
	
	// align, ../data/ros/TransformationMatrices/TransformationMatrices_xy[1-40].txt
	run("MultiStackReg", "stack_1=s"+(i+1)+"c2_ORG.tif action_1=[Load Transformation File]"+
	" file_1=[D:/"+folder+"/data/ros/TransformationMatrices/TransformationMatrices_xy"+(i+1)+".txt]"+
	" stack_2=None action_2=Ignore file_2=[] transformation=[Rigid Body]");
	
	saveAs("Tiff", "D:/"+folder+"/img/ros/s"+(i+1)+"_ros_aligned.tif");
	close("s*");
	
	// cy5
	open("D:/"+folder+"/raw/ros/s"+(i+1)+"c1_ORG.tif");
	
	// align, ../data/ros/TransformationMatrices/TransformationMatrices_xy[1-40].txt
	run("MultiStackReg", "stack_1=s"+(i+1)+"c1_ORG.tif action_1=[Load Transformation File]"+
	" file_1=[D:/"+folder+"/data/ros/TransformationMatrices/TransformationMatrices_xy"+(i+1)+".txt]"+
	" stack_2=None action_2=Ignore file_2=[] transformation=[Rigid Body]");
	
	saveAs("Tiff", "D:/"+folder+"/img/ros/s"+(i+1)+"_cy5_aligned.tif");
	close("s*");
	
	// photoinduction area
	if (i<9) {
		open("D:/"+folder+"/raw/ros/photoinduction_area/2021-07-15-erastin titration photoinduction-before photo-01_s0"+(i+1)+"c1_ORG.tif");
		rename("c1");
		open("D:/"+folder+"/raw/ros/photoinduction_area/2021-07-15-erastin titration photoinduction-before photo-01_s0"+(i+1)+"c2_ORG.tif");
		rename("c2");
	}
	if (i>=9) {
		open("D:/"+folder+"/raw/ros/photoinduction_area/2021-07-15-erastin titration photoinduction-before photo-01_s"+(i+1)+"c1_ORG.tif");
		rename("c1");
		open("D:/"+folder+"/raw/ros/photoinduction_area/2021-07-15-erastin titration photoinduction-before photo-01_s"+(i+1)+"c2_ORG.tif");
		rename("c2");
	}
	
	selectWindow("c1");
	run("MultiStackReg", "stack_1=c1 action_1=[Load Transformation File]"+
	" file_1=[D:/"+folder+"/data/ros/TransformationMatrices/TransformationMatrices_xy"+(i+1)+"mask.txt]"+
	" stack_2=None action_2=Ignore file_2=[] transformation=[Rigid Body]");
	saveAs("Tiff", "D:/"+folder+"/img/ros/s"+(i+1)+"_cy5_mask_aligned.tif");
	
	selectWindow("c2");
	run("MultiStackReg", "stack_1=c2 action_1=[Load Transformation File]"+
	" file_1=[D:/"+folder+"/data/ros/TransformationMatrices/TransformationMatrices_xy"+(i+1)+"mask.txt]"
	+" stack_2=None action_2=Ignore file_2=[] transformation=[Rigid Body]");
	saveAs("Tiff", "D:/"+folder+"/img/ros/s"+(i+1)+"_ros_mask_aligned.tif");
	

}