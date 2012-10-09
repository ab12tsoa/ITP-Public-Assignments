import isolines.*;
import channels.*;

//String filename = "isoline.gif";
Isolines finder;
PImage img;
int threshold = 0;

void setup() {
  // load the image and scale
  // the sketch to the image size
  img = loadImage("5_sunset.jpeg");
  size(1064,768);
  image(img, 0,0);
  // initialize an isolines finder based on img dimensions
  finder = new Isolines(this, img.width, img.height);



 


  
  
  // draw the contours
  
  
//  text("threshold: " + threshold, width-150, 20);
}

void draw() {
  
  // update the threshold
  finder.setThreshold(threshold);
  // Use the Channels library to extract
  // the hue channel as an int array
  int[] pix = Channels.brightness(img.pixels); //Channels.hue does not give interesting results
  // find the isolines in the red pixels instead
  finder.find(pix);
  
  for (int k = 0; k < finder.getNumContours(); k++) {
    
    // get each contour as an array of PVectors
    // so we can work with the individual points
    PVector[] points = finder.getContourPoints(k);
    
    // draw a shape for each contour
    fill(0, 25);
    beginShape();
    for (int i = 0; i < points.length; i++) {
      PVector p = points[i];
      // add a vertex to the shape corresponding to
      // each PVector in the the contour
      vertex(p.x, p.y);
    }
    // close the shape
    endShape(CLOSE);
  }
  stroke(255);
  for (int k = 0; k < finder.getNumContours(); k++) {
    finder.drawContour(k);
  }
    if(threshold < 260){
  threshold++;
  println(threshold);
  } //260 = point at which entire scene is selected
 //longestContour(pix); //note - current int[] are local to setup, make global?
}

void keyPressed() {
  if (key == '-') {
    threshold-=5;
    if (threshold < 0) {
      threshold = 0;
    }
  }
  if (key == '=') {
    threshold+=5;
  }
  
  if (key == '0') {
    saveFrame(filename);
  }
  
}

//void longestContour(int[] matrix){
//  for(int i = 0; i < matrix.length -1; i++){
//    //go through points in contour set
//    //find longest hypoteneuse in a closed shape (causing the long straight line artifcats)
//    //give the option to delete one of those points - keypress?
//  }
//  
  
//int lineLength = sqrt((iso.xj - iso.xi)+(iso.yj - iso.yi));

//}

