// **********  README  **********
//
// This macro was written in March 2024 to help Cherrelle Dacon convert her Airyscan-processed czi files into tifs.
// The macro will take all Airyscan-processed czi files in the input folder, enhance the contrast based on the
// middle slice, and save them as tiffs.

setBatchMode(true);

//allow user to select folder
Dialog.create("Choose A Folder");
Dialog.addDirectory("Images Folder", "");
Dialog.show();
path = Dialog.getString();

//function
function SaveAsTiff(imagepath) {
	//takes the given image, enhances the contrast based on the middle slice, and saves it as a tiff in the same folder
	run("Bio-Formats Importer", "open=["+imagepath+"] color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	name = replace(File.getName(imagepath), "_Airyscan Processing.czi", "");
	getDimensions(width, height, channels, slices, frames);
	Stack.setSlice(round(slices/2));
	for (ii = 1; ii <= channels; ii++) {
		Stack.setChannel(ii);
		run("Enhance Contrast", "saturated=0.35");
	}
	saveAs("Tiff", path+name+".tif");
	close("*");
}

//runs the function on all Airyscan Processed czi files in the folder
files = getFileList(path);
for (i = 0; i < files.length; i++) {
	if (endsWith(files[i], "_Airyscan Processing.czi")) {
		SaveAsTiff(path+files[i]);
	}
}

print("Finished!");