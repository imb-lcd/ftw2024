close("*"); close("Results"); close("ROI Manager");

// After creating a TileConfiguration file by MATLAB
folder = "20220503_light_power_wavelength";
//cond = "Intensity10X";
cond = "Intensity20X";
cond = "Wavelength20X";
Table.open("D:/"+folder+"/data/alignment_"+cond+".csv");


for (i = 0; i < Table.size; i++) {
	if (i%3==1) {
		fname = Table.getString("fname", i);
		well = Table.get("well", i);
		open(fname);rename("ros");
		
		open("D:/"+folder+"/img/"+cond+"_s"+well+"_c1_induction_mask.tif");rename("mask");
		run("Invert");
		run("Create Selection");
		roiManager("Add");
		
		selectWindow("ros");
		roiManager("Show All");
		roiManager("Multi Measure");
		
		saveAs("Results", "D:/"+folder+"/data/"+cond+"_s"+well+".csv");
		close("*"); close("Results"); close("ROI Manager");
	}
}
/**/



/*
// check if alignment is necessary
for (i = 0; i < Table.size; i++) { //Table.size
	if (i%3==1) { 
		fname = Table.getString("fname", i);
		well = Table.get("well", i);
		open(Table.getString("fname", i+1));rename("induction");
		open(fname);rename("ros");
		
		/* for intensity
		selectWindow("ros");run("Duplicate...", "duplicate range=1-4"); rename("1");
		selectWindow("ros");run("Duplicate...", "duplicate range=5-10"); rename("2");
		*/
		selectWindow("ros");run("Duplicate...", " "); rename("1");
		selectWindow("ros");run("Duplicate...", "duplicate range=2-7"); rename("2");
		
		run("Concatenate...", "open image1=1 image2=induction image3=2 image4=[-- None --]");
		
		saveAs("Tiff", "D:/"+folder+"/img/"+cond+"_s"+well+"_ros_ff1_10_induction.tif");

		close("*");
	}
}
*/