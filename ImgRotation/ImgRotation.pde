/*
 */
PImage img;
float angle;


void setup() {
  size(240,240);
  img = loadImage("cymbella.png");
  noStroke();
  fill(255);
  imageMode(CENTER);
 
   for(int i = 0; i < 90; i++){ 
     
  pushMatrix();

  angle = 2*i; 

   translate(width/2, height/2);
  rotate(radians(angle));
   
   image(img, 0,0);

   popMatrix(); 
  saveFrame("cymbella-"+i+".png");
  }
}

void draw() {

  
}
