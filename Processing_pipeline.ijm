working_dir= getDirectory("Choose Working Directory")

stack_file = "IRM-raw"
bg_file = "translational_background"
open(working_dir+stack_file+".tif");
open(working_dir+bg_file+".tif");

selectWindow(stack_file+".tif");
run("Properties...", "channels=1 slices=926 frames=1 unit=um pixel_width=0.107 pixel_height=0.107 voxel_depth=0 frame=0.1s global");
run("Set Scale...", "distance=10 known=1.07 pixel=1 unit=µm");
run("Scale Bar...", "width=5 height=5 font=18 color=Yellow background=None location=[Lower Right] bold ");

selectWindow(bg_file+".tif");
selectWindow(stack_file+".tif");
imageCalculator("Divide create 32-bit stack", stack_file+".tif",bg_file+".tif");

run("Set Scale...", "distance=10 known=1.07 pixel=1 unit=µm");
run("Scale Bar...", "width=5 height=5 font=18 color=Yellow background=None location=[Lower Right] bold ");
run("Enhance Contrast...", "saturated=0.3 normalize process_all");
saveAs("tiff", getDirectory("current")+"Bg_sub_img_stack.tif");
close(bg_file+".tif");
close(stack_file+".tif");

/*
//Shortcut after generate background corrected stack
open(working_dir+"Bg_sub_img_stack.tif");
run("Properties...", "channels=1 slices=926 frames=1 unit=um pixel_width=0.107 pixel_height=0.107 voxel_depth=0 frame=0.1s global");
run("Enhance Contrast...", "saturated=0.3 normalize process_all");
*/

// Walking average filter
//We intend to use moving average filtering of 10 consecutive frames, then we need to duplicate 9 last frames 
// such that the processed stack maintain the same original number of frames
run("Duplicate...", "duplicate range=926-926");
run("Concatenate...", "keep  image1=Bg_sub_img_stack.tif image2=Bg_sub_img_stack-1.tif");
rename("padded_stack")
for(i=2; i<10;i++) {
	selectWindow("Bg_sub_img_stack.tif");   
	run("Duplicate...", "duplicate range=926-926");
	run("Concatenate...", "image1=padded_stack image2=Bg_sub_img_stack-1.tif");
	rename("padded_stack");
    close("Bg_sub_img_stack-1.tif");
}
run("WalkingAverage ");
run("Enhance Contrast...", "saturated=0.3 normalize process_all");
run("Set Scale...", "distance=10 known=1.07 pixel=1 unit=µm");
run("Scale Bar...", "width=5 height=5 font=18 color=Yellow background=None location=[Lower Right] bold ");
saveAs("tiff", getDirectory("current")+"WalkingAvg_img_stack.tif");

//Median filtering
run("Duplicate...", "duplicate"); 
run("Median...", "radius=3 stack");
run("Enhance Contrast...", "saturated=0.3 normalize process_all");
run("Set Scale...", "distance=10 known=1.07 pixel=1 unit=µm");
run("Scale Bar...", "width=5 height=5 font=18 color=Yellow background=None location=[Lower Right] bold ");
saveAs("tiff", getDirectory("current")+"Median_img_stack.tif");

//Fourier filtering
selectWindow("Median_img_stack.tif");
run("Duplicate...", "duplicate"); 
run("Bandpass Filter...", "filter_large=10 filter_small=2 suppress=None tolerance=5 autoscale saturate process");
run("Enhance Contrast...", "saturated=0.3 normalize process_all");
run("Set Scale...", "distance=10 known=1.07 pixel=1 unit=µm");
run("Scale Bar...", "width=5 height=5 font=18 color=Yellow background=None location=[Lower Right] bold ");
saveAs("tiff", getDirectory("current")+"FFT_img_stack.tif");

//Projection to get trajectory
selectWindow("FFT_img_stack.tif");
run("Duplicate...", "duplicate");
run("Z Project...", "projection=[Min Intensity]");
run("Enhance Contrast...", "saturated=0.3 normalize process_all");
run("Set Scale...", "distance=10 known=1.07 pixel=1 unit=µm");
run("Scale Bar...", "width=5 height=5 font=18 color=Yellow background=None location=[Lower Right] bold ");
saveAs("tiff", getDirectory("current")+"MIN_projection.tif");

makeLine(643,528,622,472,615,454);
roiManager("Add", "ffff00", 5);


//Kymograph
selectWindow("FFT_img_stack.tif");
roiManager("Select", 0);
run("MultipleKymograph ", "linewidth=3");
run("Set Scale...", "distance=10 known=1.07 pixel=1 unit=µm");
run("Scale Bar...", "width=5 height=5 font=18 color=Yellow background=None location=[Lower Right] bold ");
run("Rotate 90 Degrees Left");
run("Set Scale...", "distance=10 known=1 pixel=1 unit=s");
run("Scale Bar...", "width=5 height=5 font=18 color=Yellow background=None location=[Lower Left] bold");
saveAs("PNG", getDirectory("current")+"Kymograph_wa_0.png");


