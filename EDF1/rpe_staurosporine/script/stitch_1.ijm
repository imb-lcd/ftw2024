close("*"); close("Results"); close("ROI Manager");

// set the folder containing the raw images to be processed
folder = "ftw_paper_figures_v2/figS1_vector_field/RPE_6_Staurosporine";
wells   = newArray("6","6");
signals = newArray("dic","cy5");
ch      = newArray(1,2);

overlap = 2;
slices  = 42;
x = 2;
y = 2;
// pxSize  = 1.266;

// select a specific frame for stitching
for (i = 1; i < (x*y+1); i++) {
	open("D:/"+folder+"/img/s"+wells[1]+"/cy5_m"+i+"_ff1_10.tif"); 
	setSlice(slices); run("Duplicate...", " "); 
	saveAs("Tiff", "D:/"+folder+"/img/s"+wells[1]+"/for_stitch/tile"+i+".tif");	
	close("*");
}

// Generate a TileConfiguration file (TileConfiguration.registered.txt) for MATLAB
run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Right & Down                ]"+
" grid_size_x="+x+" grid_size_y="+y+" tile_overlap="+overlap+" first_file_index_i=1 "+
"directory=D:/"+folder+"/img/s"+wells[1]+"/for_stitch file_names=tile{i}.tif "+
"output_textfile_name=TileConfiguration.txt fusion_method=[Linear Blending] "+
"regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50"+
" compute_overlap computation_parameters=[Save memory (but be slower)] image_output=[Fuse and display]");
