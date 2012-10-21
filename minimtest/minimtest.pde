import ddf.minim.*;
// import processing.opengl.*;
AudioPlayer track;
Minim minim;
float bpm = 50.2;
float mspb = 60000/bpm;
float x = 0;
float y = 0;
float x1 =0;
float x2 =0;
float y1 =0;
float y2 =0;
//
float horizontal_scaling = 180; // or 160
float line_height = 1;
int time = 0;
//
//
void setup()
{
  size(1448, 500);
  background(0);
  stroke(255);
  strokeWeight(1);
  frameRate(20);
  smooth();
  minim = new Minim(this);
  track = minim.loadFile("Big_Band_Swing.mp3", 2048);
  track.loop();
}
//
//
void draw()
{
  int lapse = millis() - time;
  //
  for (int i = 0; i < track.left.size()-1; i++)
  {
    float column_norm = line_height/1*(0+1.5*y);
    x1 = x     / horizontal_scaling;
    x2 = (x+1) / horizontal_scaling;
    y1 = track.left.get(i)  *line_height/2 + (column_norm);
    y2 = track.left.get(i+1)*line_height/2 + (column_norm);
    // line(x1, y1, x2, y2);
    println(track.left.get(i));
    fill(2, map( abs(track.left.get(i)), 0, .2, 0, 255), 2);
    // stroke(222, 2, 2);
    noStroke();
    rect(x, y, 5, 5);
    x+=6;
  } // for
  //
  if (lapse > mspb || x > width )
  {
    // start a new line on the left
    time = millis();
    y += 6; // or 1
    x = 0;
    //if (y2 > height-40 )
    if (y > height)    
    {
      // start a new page from top
      y = 0;
      background(0);
    } // if
  } // if
} // func
//
//
void stop()
{
  // always close Minim audio classes when you are done with them
  track.close();
  minim.stop();
  super.stop();
}
//

