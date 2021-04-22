working_dir= getDirectory("Choose working directory")

open(working_dir+"IRM-raw.tif");
run("Duplicate...", "duplicate range=911-911");
saveAs("tiff", getDirectory("current")+"raw_img.tif");
close("*")
open(working_dir+"Bg_sub_img_stack.tif");
run("Duplicate...", "duplicate range=911-911");
saveAs("tiff", getDirectory("current")+"Bg_sub_img.tif");
close("*")
open(working_dir+"WalkingAvg_img_stack.tif");
run("Duplicate...", "duplicate range=911-911");
saveAs("tiff", getDirectory("current")+"walking_average.tif");
close("*")
open(working_dir+"Median_img_stack.tif");
run("Duplicate...", "duplicate range=911-911");
saveAs("tiff", getDirectory("current")+"median.tif");
close("*")
open(working_dir+"FFT_img_stack.tif");
run("Duplicate...", "duplicate range=911-911");
saveAs("tiff", getDirectory("current")+"FFT.tif");
close("*")

////////////////////////////////////////////////////////
//Calculate SBR,CSC at the final image
////////////////////////////////////////////////////////
target_file = "FFT" // name of the final processed image frame without extension type
//This final processed image is used to create reference segmentation mask to be used on previous step processed images
open(working_dir+target_file+".tif");
run("Duplicate...", " ");
makeRectangle(40, 172, 114, 60); // PROCESS ONLY A SMALL REGION OF INTEREST

//COMPUTE THE SEGMENTATION MASK 
run("Duplicate...", " ");
saveAs("tiff", getDirectory("current")+"sub_image_"+target_file+".tif");
run("Duplicate...", " ");

run("Auto Local Threshold", "method=Sauvola radius=5 parameter_1=0 parameter_2=0 white");
saveAs("tiff", getDirectory("current")+"reference_segmentation_mask.tif");

//COMPUTE THE SEGMENTATION MASK FOR THE FINAL PROCESSED IMAGE
//Get background measurement
selectWindow("reference_segmentation_mask.tif");
run("Create Selection");

selectWindow("sub_image_"+target_file+".tif");
run("Restore Selection");
run("Set Measurements...", "area mean standard min redirect=None decimal=3");
run("Measure");
bg_mean = getResult("Mean");
bg_StdDev = getResult("StdDev");

// Get object measurment
selectWindow("reference_segmentation_mask.tif");
run("Create Selection");
run("Make Inverse");

selectWindow("sub_image_"+target_file+".tif");
run("Restore Selection");
run("Measure");
obj_signal = bg_mean - getResult("Min") ;
obj_std = getResult("StdDev");

// Calculate Signal to Background Ratio
SBR = obj_signal / bg_StdDev
print("SBR in target file " + target_file+ " = " + SBR)
CSC = obj_signal / obj_std
print("CSC in target file " + target_file+ " = " + CSC)
close("*")

////////////////////////////////////////////
// Calculate SBR,CSC after median filtering step
////////////////////////////////////////////
median_filtered_img = "median"
open(working_dir+median_filtered_img+".tif");
run("Duplicate...", " ");
makeRectangle(40, 172, 114, 60);// PROCESS ONLY A SMALL REGION OF INTEREST
run("Duplicate...", " ");
saveAs("tiff", getDirectory("current")+"sub_image_"+median_filtered_img+".tif");
run("Duplicate...", " ");

open(working_dir+"reference_segmentation_mask.tif"); //Open reference segmentation mask created before
run("Create Selection");
run("Make Inverse");

selectWindow("sub_image_"+median_filtered_img+".tif");
run("Restore Selection");
run("Measure");
bg_mean_2 = getResult("Mean");
bg_StdDev_2 = getResult("StdDev");

// Get object measurment
selectWindow("reference_segmentation_mask.tif");
run("Create Selection");


selectWindow("sub_image_"+median_filtered_img+".tif");
run("Restore Selection");
run("Measure");
obj_signal_2 = bg_mean_2 - getResult("Min") ;
obj_std_2 = getResult("StdDev");
// Calculate Signal to Background Ratio
SBR_2 = obj_signal_2 / bg_StdDev_2
print("SBR in target file " + median_filtered_img+ " = " + SBR_2)
CSC_2 = obj_signal_2 / obj_std_2
print("CSC in target file " + median_filtered_img+ " = " + CSC_2)
close("*")

////////////////////////////////////////////////////////
// Calculate SBR,CSC after walking average filtering step
////////////////////////////////////////////////////////
wak_filtered_img = "walking_average"
open(working_dir+wak_filtered_img+".tif");
run("Duplicate...", " ");
makeRectangle(40, 172, 114, 60); // PROCESS ONLY A SMALL REGION OF INTEREST
run("Duplicate...", " ");
saveAs("tiff", getDirectory("current")+"sub_image_"+wak_filtered_img+".tif");
run("Duplicate...", " ");

open(working_dir+"reference_segmentation_mask.tif"); //Open reference segmentation mask created before
run("Create Selection");
run("Make Inverse");

selectWindow("sub_image_"+wak_filtered_img+".tif");
run("Restore Selection");
run("Measure");
bg_mean_3 = getResult("Mean");
bg_StdDev_3 = getResult("StdDev");

// Get object measurment
selectWindow("reference_segmentation_mask.tif");
run("Create Selection");


selectWindow("sub_image_"+wak_filtered_img+".tif");
run("Restore Selection");
run("Measure");
obj_signal_3 = bg_mean_3 - getResult("Min");
obj_std_3 = getResult("StdDev");
// Calculate Signal to Background Ratio
SBR_3 = obj_signal_3 / bg_StdDev_3
print("SBR in target file " + wak_filtered_img+ " = " + SBR_3)
CSC_3 = obj_signal_3 / obj_std_3
print("CSC in target file " + wak_filtered_img+ " = " + CSC_3)
close("*")
////////////////////////////////////////////////////////
// Calculate SBR,CSC after background correction step
////////////////////////////////////////////////////////
Bg_sub_img = "Bg_sub_img"
open(working_dir+Bg_sub_img+".tif");
run("Duplicate...", " ");
makeRectangle(40, 172, 114, 60); // PROCESS ONLY A SMALL REGION OF INTEREST
run("Duplicate...", " ");
saveAs("tiff", getDirectory("current")+"sub_image_"+Bg_sub_img+".tif");
run("Duplicate...", " ");

open(working_dir+"reference_segmentation_mask.tif"); //Open reference segmentation mask created before
run("Create Selection");
run("Make Inverse");

selectWindow("sub_image_"+Bg_sub_img+".tif");
run("Restore Selection");
run("Measure");
bg_mean_4 = getResult("Mean");
bg_StdDev_4 = getResult("StdDev");

// Get object measurment
selectWindow("reference_segmentation_mask.tif");
run("Create Selection");


selectWindow("sub_image_"+Bg_sub_img+".tif");
run("Restore Selection");
run("Measure");
obj_signal_4 = bg_mean_4 - getResult("Min") ;
obj_std_4 = getResult("StdDev");
// Calculate Signal to Background Ratio
SBR_4 = obj_signal_4 / bg_StdDev_4
print("SBR in target file " + Bg_sub_img+ " = " + SBR_4)
CSC_4 = obj_signal_4 / obj_std_4
print("CSC in target file " + Bg_sub_img+ " = " + CSC_4)
close("*")

////////////////////////////////////////////////////////
// Calculate SBR,CSC of raw image
////////////////////////////////////////////////////////
raw_img = "raw_img"
open(working_dir+raw_img+".tif");
run("Duplicate...", " ");
makeRectangle(40, 172, 114, 60); // PROCESS ONLY A SMALL REGION OF INTEREST
run("Duplicate...", " ");
saveAs("tiff", getDirectory("current")+"sub_image_"+raw_img+".tif");
run("Duplicate...", " ");

open(working_dir+"reference_segmentation_mask.tif"); //Open reference segmentation mask created before
run("Create Selection");
run("Make Inverse");

selectWindow("sub_image_"+raw_img+".tif");
run("Restore Selection");
run("Measure");
bg_mean_5 = getResult("Mean");
bg_StdDev_5 = getResult("StdDev");

// Get object measurment
selectWindow("reference_segmentation_mask.tif");
run("Create Selection");


selectWindow("sub_image_"+raw_img+".tif");
run("Restore Selection");
run("Measure");
obj_signal_5 = bg_mean_5 - getResult("Min") ;
obj_std_5 = getResult("StdDev");
// Calculate Signal to Background Ratio
SBR_5 = obj_signal_5 / bg_StdDev_5
print("SBR in target file " + raw_img+ " = " + SBR_5)
CSC_5 = obj_signal_5 / obj_std_5
print("CSC in target file " + raw_img+ " = " + CSC_5)
close("*")

