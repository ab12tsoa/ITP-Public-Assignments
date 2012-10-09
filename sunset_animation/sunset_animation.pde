import isolines.*;
import channels.*;

String filename = "isoline.gif";
Isolines finder;
PImage img;
int threshold = 0;

void setup() {
  // load the image and scale
  // the sketch to the image size
  img = loadImage("5_sunset.jpeg");
  size(img.width, img.height);
  // initialize an isolines finder based on img dimensions
  finder = new Isolines(this, img.width, img.height);
}

void draw() {
  image(img, 0,0);
  // update the threshold
  finder.setThreshold(threshold);
  // Use the Channels library to extract
  // the hue channel as an int array
  int[] pix = Channels.red(img.pixels); //Channels.hue does not give interesting results
  // find the isolines in the red pixels instead
  finder.find(pix);

  if(threshold < 260){
  threshold++;
  } //260 = point at which entire scene is selected
  
  
  // draw the contours
  stroke(255);
  for (int k = 0; k < finder.getNumContours(); k++) {
    finder.drawContour(k);
  }
  
  text("threshold: " + threshold, width-150, 20);
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

