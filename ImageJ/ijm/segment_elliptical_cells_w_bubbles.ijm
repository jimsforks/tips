// segmenting elliptical cells with bubbles
// from: https://forum.image.sc/t/finding-ellipses-with-incomplete-boundaries/843/9
//
// Does not run right...
//
//lighting correction
run("Close All");
open("/Users/jrminter/Documents/git/tips/ImageJ/jpg/elliptical_cells_w_bubbles.jpg");

original = getTitle();
run("Select None");
run("Pseudo flat field correction", "blurring=300");
close(original + "_background");
selectWindow(original);

// Color Thresholder 2.0.0-rc-44/1.50e
// Autogenerated macro, single images only!
min=newArray(3);
max=newArray(3);
filter=newArray(3);
a=getTitle();
run("HSB Stack");
run("Convert Stack to Images");
selectWindow("Hue");
rename("0");
selectWindow("Saturation");
rename("1");
selectWindow("Brightness");
rename("2");
min[0]=10;
max[0]=60;
filter[0]="pass";
min[1]=0;
max[1]=255;
filter[1]="pass";
min[2]=155;
max[2]=255;
filter[2]="pass";
for (i=0;i<3;i++){
  selectWindow(""+i);
  setThreshold(min[i], max[i]);
  run("Convert to Mask");
  if (filter[i]=="stop")  run("Invert");
}
imageCalculator("AND create", "0","1");
imageCalculator("AND create", "Result of 0","2");
for (i=0;i<3;i++){
  selectWindow(""+i);
  close();
}
selectWindow("Result of 0");
close();
selectWindow("Result of Result of 0");
rename(a);
// Colour Thresholding-------------

//shape correction of egg (if egg sizes differ a lot, iterations might need adjustment)
run("EDM Binary Operations", "iterations=10 operation=close");
run("EDM Binary Operations", "iterations=45 operation=open");

//analysis and retrieval of ellipsoid ROI (min. size in Analyze Particles might need some adjustment)
roiManager("Reset");
run("Analyze Particles...", "size=20000-Infinity circularity=0.00-0.80 exclude add");
roiManager("Select", 0);
run("Fit Ellipse");
roiManager("Add");
roiManager("Select", 0);
roiManager("Delete");
run("Revert");
