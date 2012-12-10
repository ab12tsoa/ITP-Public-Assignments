/**
 * Rotate. 
 * 
 * Rotating a square around the Z axis. To get the results
 * you expect, send the rotate function angle parameters that are
 * values between 0 and PI*2 (TWO_PI which is roughly 6.28). If you prefer to 
 * think about angles as degrees (0-360), you can use the radians() 
 * method to convert your values. For example: scale(radians(90))
 * is identical to the statement scale(PI/2). 
 */
PImage img;
float angle;


void setup() {
  size(180,180);
  img = loadImage("cymbella_100.png");
  noStroke();
  fill(255);
  imageMode(CENTER);
}

void draw() {
//  background(img);
  
  
//  translate(width/2,height/2);
//    pushMatrix();
   
  angle = angle + 10;
  float c = cos(angle);
  translate(width/2, height/2);
  rotate(c);
//   popMatrix();  
//  rect(0, 0, 180, 180); 
//   translate(0,0);
   image(img, 0,0);
  saveFrame("cymbella_##.png");
//  millis(500);
   
  
}
