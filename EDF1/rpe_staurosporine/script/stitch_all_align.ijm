close("*"); close("Results"); close("ROI Manager");

// After creating a TileConfiguration file by MATLAB
folder = "ftw_paper_figures_v2/figS1_vector_field/RPE_6_Staurosporine";
wells   = newArray("6","6");
signals = newArray("dic","cy5");
ch      = newArray(1,2);

slices  = 42;

for (i = 0; i < signals.length; i++) {
	run("Grid/Collection stitching", "type=[Positions from file] order=[Defined by TileConfiguration]"+
	" directory=D:/"+folder+"/img/s"+wells[i]+" layout_file=TileConfiguration.registered."+signals[i]+".txt"+
	" fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50"+
	" absolute_displacement_threshold=3.50 computation_parameters=[Save memory (but be slower)]"+
	" image_output=[Fuse and display]");
	rename(signals[i]);
}

// align images and save the transformation matrix as TransformationMatrices_cy5_[well].txt if the file doesn;t exist
if (!File.exists("D:/"+folder+"/data/TransformationMatrices_cy5_s"+wells[1]+".txt")) {
	selectWindow("cy5");
	setSlice(slices);
	run("MultiStackReg", "stack_1=cy5 action_1=Align file_1=[] stack_2=None action_2=Ignore file_2=[] transformation=Translation save");
}

// align image stack by TransformationMatrices_cy5_[well].txt
for (i = 0; i < signals.length; i++) {
	selectWindow(signals[i]);
	run("MultiStackReg", "stack_1="+signals[i]+" action_1=[Load Transformation File] file_1=[] stack_2=None action_2=Ignore file_2=[] transformation=[Rigid Body]");
	saveAs("Tiff", "D:/"+folder+"/img/s"+wells[i]+"/"+signals[i]+"_ff1_10_stitched_aligned.tif");
}
