// Get the name of the active image
title = getTitle();
selectWindow(title);
run("Duplicate...", "title=WorkingCopy duplicate");
setMinAndMax(350, 700);
// Optional: Apply Gaussian blur 3D to reduce noise
run("Gaussian Blur 3D...", "x=1 y=1 z=1");

// Create max projection and draw ROI
run("Z Project...", "projection=[Max Intensity]");

// Enhance contrast for easier ROI selection — only for user visibility
run("Enhance Contrast", "saturated=0.35");
waitForUser("Draw a rectangular ROI around the neuron of interest, then click OK.");
getSelectionBounds(x, y, width, height);
close();  // Close the projection window

// Go back to original stack
selectWindow("WorkingCopy");
// Apply ROI and crop across stack
makeRectangle(x, y, width, height);
run("Crop");

// Convert to 8-bit (keeps raw intensities for Otsu thresholding)
run("8-bit");

// DO NOT modify contrast or enhance LUT — this ensures consistency
// Proceed directly to thresholding on raw image
setAutoThreshold("Otsu");  // or try "Triangle" for noisy background
setOption("BlackBackground", false);
run("Convert to Mask");

run("Invert");
// Optional cleaning
run("Fill Holes");
// run("Remove Outliers...", "radius=2 threshold=50 which=Bright");

// Invert if needed (object should be white)


// Run 3D Objects Counter
run("3D Objects Counter", "threshold=128 slice=20 min.=200 max.=1000000 statistics");

if (isOpen("3D Objects Counter Results")) {
    selectWindow("3D Objects Counter Results");
    v = getResult("Volume", 0);
    print("Volume of first object: " + v);
}

