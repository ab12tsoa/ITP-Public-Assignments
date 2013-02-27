import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.TreeMap;
import processing.core.PApplet;
import processing.core.PFont;


TreeMap wordObjects;
ArrayList reSortable = new ArrayList( ) ;
static int sortOn = 0;
int numberOfParts = 12;
int average = 0;
String[] myLines;
String[] lines;
String full;

public void setup() {
  size(1024, 600); // Stage size
  noStroke(); // No border on the next thing drawn
  PFont font = createFont("ArialMT-12.vlw", 10);
  textFont(font);
  background(0);
  fill(255, 255, 255);
  wordObjects = new TreeMap();
   

  PrintWriter output = createWriter("data/data.txt");


 for(int i = 0; i < 230; i++){ //pulling all emails can crash Processing despite the flush() in the loop
 lines = loadStrings("/Users/allisonberman/Documents/pyemails/myemail_" + i + ".eml");

 full = join(lines, " ");
  output.println(full);
  output.flush();  // Actually writes the bytes to the file
 }
 
  output.close();
  
   try {
  BufferedWriter writer = new BufferedWriter(new FileWriter("data.txt", true));
  writer.write(full);
  writer.flush();
  writer.close();
  } catch (IOException ioe) {
    println("error: " + ioe);
  }
  
  String[] myLines = loadStrings("data/data.txt");
  String allText = join(myLines, " ");
//  String allText = full;
//  allText = executeDeletes(allText, "");
  allText = allText.replaceAll("[^\\w\\s]", "");
  String[] words = allText.split(" ");
}

void draw(){
  exit();
}
