import Jama.Matrix;
import pca_transform.*;
import hypermedia.video.*;

PCA pca;

PVector axis1;
PVector axis2;
PVector mean;
//PVector velocity;
//PVector prev;

OpenCV opencv;

PImage img;

int imgWidth = 180/2;
int imgHeight = 180/2;

void setup() {
  size(640, 480);
  opencv = new OpenCV(this);
//  opencv.loadImage("data/pen_orientation-0.png", imgWidth, imgHeight);
    opencv.loadImage("data/cymbella-60.png", imgWidth, imgHeight);
  noLoop();
//  prev = new PVector(0,0);
}

Matrix toMatrix(PImage img) {
  ArrayList<PVector> points = new ArrayList<PVector>();
  for (int x = 0; x < img.width; x++) {    //for all x points
    for (int y = 0; y < img.height; y++) { //for all y points
      int i = y*img.width + x;  //for whole arraylist of PVectors
      if (brightness(img.pixels[i]) == 0) {  //if it is a black pixel, add point to the Array
        points.add(new PVector(x, y));
      }
    }
  }

  println("nBlackPixels: " + points.size() + "/" + img.width*img.height);
  Matrix result = new Matrix(points.size(), 2);

  for (int i = 0; i < points.size(); i++) {
    result.set(i, 0, points.get(i).x); //column 1 [0] of the matrix
    result.set(i, 1, points.get(i).y); //column 2 [1] of the matrix
  }

  return result;
}

int currX = 0;
int currY = 0;
void imageInGrid(PImage img, String message) {
  image(img, currX, currY);
  fill(255, 0, 0);
  text(message, currX + 5, currY + imgHeight - 5);

  currX += img.width;
  if (currX > width - img.width) {
    currX = 0;
    currY += img.height;
  }
}

void draw() {
  //background(255);
 
  opencv.convert(GRAY);
  imageInGrid(opencv.image(), "GRAY");

  opencv.brightness(30);
  imageInGrid(opencv.image(), "BRIGHTNESS: 30");

  opencv.contrast(40);
  imageInGrid(opencv.image(), "CONTRAST: 120");

  opencv.threshold(200,250,opencv.THRESH_OTSU); //use the Otsu method of thresholding
  imageInGrid(opencv.image(), "THRESHOLD: " + opencv.THRESH_OTSU); 

  Matrix m = toMatrix(opencv.image());
  pca = new PCA(m);
  Matrix eigenVectors = pca.getEigenvectorsMatrix(); //find the most important set values, eg the most covarient

  eigenVectors.print(10, 2); 
  
  float eigenValueX = (float)pca.getEigenvalue(0);
  float eigenValueY = (float)pca.getEigenvalue(1);
  println(eigenValueX);

  axis1 = new PVector();                   //eigenvectors are a measure of covariance - me by my mean, you by yours 
  axis2 = new PVector();                   //eigenvectors are every member of a set normalized against the MEAN of a set of values
  axis1.x = (float)eigenVectors.get(0, 0); //eigenvectors are always between -1 and 1 because we pull out sign and proportion of each entry 
  axis1.y = (float)eigenVectors.get(1, 0); //so we normalize the vectors, then multiply by the eigenvalue to find the reconstructed value
                                           //axis1 is "more important" eg is the principal componant of my group of points
  axis2.x = (float)eigenVectors.get(0, 1); //axis2 is the spread over axis1, e.g. the deviation
  axis2.y = (float)eigenVectors.get(1, 1); //axis2 can be dropped without changing the identity of axis1 info
                                           //axis2 is always orthogonal to axis1
  axis1.mult((float)pca.getEigenvalue(0)); //result should always be eigenvalue * eigenvector
  axis2.mult((float)pca.getEigenvalue(1));

  image(opencv.image(), 0, opencv.image().height, opencv.image().width*3, opencv.image().height*3);

  Blob[] blobs = opencv.blobs(10, imgWidth*imgHeight/2, 100, true, OpenCV.MAX_VERTICES*4 ); 
  noFill();
    stroke(200);
    pushMatrix();
  translate(0, imgHeight);
  scale(3, 3);
  for ( int i=0; i<blobs.length; i++ ) {
    beginShape();
    for ( int j=0; j<blobs[i].points.length; j++ ) {
      vertex( blobs[i].points[j].x, blobs[i].points[j].y );
    }
    endShape(CLOSE);
  }
  textSize(6); //image is small so text can look much too big at default

  PVector centroid = new PVector(blobs[0].centroid.x, blobs[0].centroid.y); 
//  to find velocity in a moving image:
//  float diffX = (blobs[0].centroid.x - prev.x);
//  float diffY = (blobs[0].centroid.y - prev.y);
//  velocity = new PVector(diffX,diffY);
//  println("velocity: " + velocity);
//  prev = centroid;
//   println(prev);
  translate(centroid.x, centroid.y);
  
//we redefined our "0,0" as the blob centroid, but to find how something just moved in relation to a set value
//it is easy to just define some point and then see how far the center is from it
//  PVector top = new PVector(width/2, imgHeight);
//  float angle = PVector.angleBetween(top,centroid);
//  println(angle);

  stroke(0, 255, 0);
  line(0, 0, axis1.x/8, axis1.y/8); //reduce to fraction of 1 which blob covers - "front half" of diatom
  println(axis1.x);
  text("raphe", axis1.x/16, axis1.y/16); //halfway down the line, label the raphe - a physical feature of the diatom
  stroke(0,255,255);
  line(-axis1.x/8, -axis1.y/8, 0,0); //back half of the diatom
   stroke(0, 255, 0);
    text("raphe", -axis1.x/16, -axis1.y/16); //label the 2nd raphe
 //   text("central nodule", 0,0); //most diatoms are symmetric across at least the transapical axis, and usually also the apical axis
 //   thus: the central nodule is almost always at the centroid of the blob
 //   stroke(255, 0, 0); 
  stroke(255,255,0);
  line(0, 0, axis2.x/4, axis2.y/4);
  textSize(4);
  text("transapical axis", axis2.x*0.8, axis2.y/4);
  text("apical axis", axis1.x/8, axis1.y/8);
  popMatrix();
  fill(255,0,0);
  text("PCA Object Axes:\nFirst two principle components centered at blob centroid", 10, height - 20);
}


void draw(Matrix m) {
  double[][] a = m.getArray();
  for (int i = 0; i < m.getRowDimension(); i++) {
    ellipse((float)a[i][0], (float)a[i][1], 3, 3);
  }
  
}
