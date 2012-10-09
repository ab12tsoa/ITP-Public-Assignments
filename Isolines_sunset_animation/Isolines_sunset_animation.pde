import isolines.*;
import channels.*;
//sunset fades slowly to blue

String filename = "5_sunset.jpeg";
//String filename = "ABicon.png"; //my face - also gets straight line artifaces
Isolines finder;
PImage img;
int threshold = 10;
PrintWriter output;

void setup() {
  // load the image and scale
  // the sketch to the image size
  img = loadImage("5_sunset.jpeg");
  size(1064,768);
  image(img, 0,0);
  // initialize an isolines finder based on img dimensions
  finder = new Isolines(this, img.width, img.height);
  //save some info to file
  output = createWriter("threshold.csv");


//  everythingbutThreshold(18); //debug using static value
}

void draw() {
everythingbutThreshold(threshold);
  if(threshold < 260){
      threshold++;
     // println(threshold);
      } //260 = point at which entire scene is selected
  fill(0);
  rect(width-90, 5, 35,25); //puts a box under threshold counter so it is readable
  fill(255);
  text("threshold: " + threshold, width-150, 20);
}

void keyPressed() {
  
  output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file
//  exit(); // Stops the program

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

//-------
void everythingbutThreshold(int t){
  
  // update the threshold
  finder.setThreshold(t);
  // Use the Channels library to extract
  // the hue channel as an int array
  int[] pix = Channels.red(img.pixels); //Channels.hue does not give interesting results
  // find the isolines in the red pixels or brightness instead
  finder.find(pix);
  int z = finder.getNumContours(); //unexpected object (float, int, double - not working)
   output.println(t+","+z);
  for (int k = 0; k < finder.getNumContours(); k++) {
    
    // get each contour as an array of PVectors
    // so we can work with the individual points
    PVector[] points = finder.getContourPoints(k);
    
    // draw a shape for each contour
    fill(0,0,255, 5);
    beginShape();
    for (int i = 0; i < points.length-1; i++) {
      PVector p = points[i];
      // add a vertex to the shape corresponding to each PVector in the the contour
       vertex(p.x, p.y);
      //figure out why long straight lines keep happening
      //test: connecting points from separate contour groups? if points are too far from each other, do not draw
//      PVector v = points[i-1];
//      if(p.dist(v) > 2){println("point to point exploration violation")}
//          turns out this does not happen - so the long straight lines are made of neighboring points after all
//        if(points.length > 1000){
//          stroke(255);
//          fill(255,60);
//          rect(p.x, p.y, 10,10);
//        //  text("big one", p.x, p.y);
//        } //gives an interesting effect - can see small (blue) shapes appearing inside boundaries of large (white) shapes
//        else{fill(0,0,255,25);stroke(0);} //return from white coloring
    }
    // close the shape
    endShape(CLOSE);
  }
//  stroke(255);
//  for (int k = 0; k < finder.getNumContours(); k++) {
//    finder.drawContour(k);
//  }

 //longestContour(pix); //again trying to work out distance between two points - not helping, nothing is >1
 contourArrays(finder); //using native Isolines code to look up the contour point arrays instead of PVector
}

//-------

void contourArrays(Isolines iso){ //to find the points along each contour using the native Isolines calls
//to be used to find RGB values at given point
//  println("begin call");
  // for(i = 0; i < getNumContours().length - 1; i++){ //checks all points
   for(int i = 0; i < 3; i++){ //first 3 points - check if code is working
     for(int j = 0; j < iso.getContourLength(i) - 1; j++){
        double x = iso.getContourX(i,j);
        double y = iso.getContourY(i,j);      
//        color c = get(i, j*width); //does not work
//        println(c); //giving all 0?
//         println("contour: " + i + " points: " + x + "," + y); //gives each point as a double - can't convert double to int
     } 
   //output.println(threshold); //trying to output info to csv - getting gibberish
       //how many points are in each contour at this threshold
//       println("contour #"+i+", total contour points: " + iso.getContourLength(i)+" , threshold: " + threshold);
   }  
//       println("end call");
}
//void longestContour(int[] matrix){ 
//  for(int i = 0; i < matrix.length -1; i++){
//    //go through points in contour set
//    //find longest hypoteneuse in a closed shape (causing the long straight line artifcats)
//    //give the option to delete one of those points?
//  } 
//int lineLength = sqrt((iso.xj - iso.xi)+(iso.yj - iso.yi)); //basic method
//}
