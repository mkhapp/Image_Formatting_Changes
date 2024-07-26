setBatchMode(true);

//allow user to select folder
Dialog.create("Choose A Folder");
Dialog.addDirectory("Images Folder", "");
Dialog.show();
path = Dialog.getString();

//function
function SaveAsJPEG(path, imagepath) {
	//takes the given image, extracts the confocal images, makes a figure, and saves as a JPEG
	run("Bio-Formats Importer", "open=["+imagepath+"] color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	namenoext = File.getNameWithoutExtension(imagepath);
	rename("Image");
	run("Slice Keeper", "first=1 last=5 increment=1");
	selectImage("Image");
	close();
	setSlice(1);
	run("Delete Slice");
	setSlice(2);
	run("Delete Slice");
	run("Stack to Images");
	selectImage("Image-0001");
	run("Grays");
	run("Enhance Contrast", "saturated=0.05");
	run("RGB Color");
	selectImage("Image-0002");
	run("Red");
	if (bitDepth()==8) {
		setMinAndMax(0, 39);
	} else {
		setMinAndMax(0, 10000);
	}
	run("RGB Color");
	selectImage("Image-0003");
	run("Cyan");
	run("Enhance Contrast", "saturated=0.01");
	getMinAndMax(min, max);
	setMinAndMax(max/4, max);
	run("RGB Color");
	run("Merge Channels...", "c1=Image-0002 c5=Image-0003 keep");
	run("Combine...", "stack1=Image-0002 stack2=Image-0003");
	run("Combine...", "stack1=Image-0001 stack2=RGB");
	rename("Combined 2");
	run("Combine...", "stack1=[Combined Stacks] stack2=[Combined 2] combine");
	saveAs("jpeg", path+namenoext+"_high.jpg");
	close("*");
}

//runs the function on all Airyscan Processed czi files in the folder
files = getFileList(path);
for (i = 0; i < files.length; i++) {
	if (endsWith(files[i], ".czi")) {
		SaveAsJPEG(path, path+files[i]);
	}
}

print("Finished!");









