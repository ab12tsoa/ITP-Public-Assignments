import linearclassifier.*;
import processing.data.*;

Table data;
LinearClassifier classifier;

void setup() {
  size(500, 500);

  // load the data and automatically parse the csv
  data = new Table(this, "glass.csv");
  // table columns: Refractive Index (RI), Sodium (Na), Magnesium (Mg), Aluminum (Al), Silicon (Si), Potassium (K), Calcium (Ca), Barium (Ba), Iron (Fe), Usage type
  // Ignore column 1 (RI) 
  classifier = new LinearClassifier(this);

  ArrayList<ArrayList<Float>> window = new ArrayList<ArrayList<Float>>();
  ArrayList<ArrayList<Float>> table = new ArrayList<ArrayList<Float>>();
//  ArrayList<ArrayList<Float>> headlamp = new ArrayList<ArrayList<Float>>();

  // iterate through the data in the csv
  for (TableRow row : data) {
    ArrayList<Float> entry = new ArrayList<Float>();
//
//    entry.add(row.getFloat(1)); // Na
//    entry.add(row.getFloat(2)); // Mg 
//    entry.add(row.getFloat(3)); // Al
//    entry.add(row.getFloat(4)); // Si
//    entry.add(row.getFloat(5)); // K
//    entry.add(row.getFloat(6)); // Ca
//    entry.add(row.getFloat(7)); // Ba
//    entry.add(row.getFloat(8)); // Fe
    entry.add(parseType(row.getString(9))); //type
    //sort into 1,0,-1 for types window, table, headlamp

    if (row.getInt(9) == 1) {
      window.add(entry);
    } 
    else if(row.getInt(9) == 0){
      table.add(entry);
    }
//    else{ //cannot add ()case to else, only else if
//      headlamp.add(entry);
//    }
  
  // pass the data to the classifier
  if(classifier.set1.size() == 0){
    entry.add(100.0);
  }
  else{
  classifier.loadSet1(window);
  classifier.loadSet2(table);
  }
//  classifier.loadSet3(headlamp);
  }
  // scale all the data to be between 0 and 1
  // to give each component equal weight
  //  classifier.scaleData(0,1);
  displayNewResults();
}

// picks 5 entries randomly from both set 1 and set 2
// runs them through the classifier to see if it
// categorizes them correctly
// all examples from set 2 should be "tableware", i.e. red
// and all from set 1 should be "window", i.e. green
// the classifier won't always be right but should be most of the time
// this gets called in keyPressed() to display new data
void displayNewResults() {
  background(255);
  fill(0);
  text("Set 1: These should all be window", 10, 20);

  for (int i = 0; i < 5; i ++) {
    int j = (int)random(classifier.set1.size());
    ArrayList<Float> entry = classifier.set1.get(j);
    if (classifier.isInSet1(entry)) {
      fill(0, 255, 0);
    } 
    else {
      fill(255, 0, 0);
    }
    text("["+ toString(entry) + "]\nPredicted match? " + classifier.isInSet1(entry), 10, 40 + i*35);
  }

  fill(0);
  text("Set 2: None of these should be window", 10, 40 + 5*35 + 20);

  for (int i = 0; i < 5; i ++) {
    int j = (int)random(classifier.set2.size());
    ArrayList<Float> entry = classifier.set2.get(j);
    if (classifier.isInSet2(entry)) {
      fill(0, 255, 0);
    } 
    else {
      fill(255, 0, 0);
    }
    text("["+ toString(entry) + "]\nPredicted match? " + classifier.isInSet2(entry), 10, 40 + 5*35 + 40 + i*35);
  }
}

void draw() {
  fill(0);
  text("(PRESS ANY KEY FOR MORE DATA)", 10, height-20);
}

void keyPressed(){
  displayNewResults();
}

// helper function to turn a type string into 1, 0, -1 for numerical comparison

float parseType(String s) {
  if (s.equals("build wind float")) {
    return 1;
  } 
  else if (s.equals("headlamps")) {
    return -1;
  } 
  else if(s.equals("tableware")){
    return 0;
  }
  else{return 2;} //use null?  
}
// helper function to turn the list of interests
// into a Float based on how many are shared
//Float matchCount(String interests1, String interests2) {
//  String[] i1 = split(interests1, ":");
//  String[] i2 = split(interests2, ":");
//
//  Float result = 0;
//  for (int i = 0; i < i1.length; i++) {
//    if (i < i2.length && i1[i].equals(i2[i])) {
//      result = result + 1;
//    }
//  }
//
//  return result;
//}

// helper function to display an ArrayList as a string
String toString(ArrayList<Float> a) {
  String s = "";
  for (int i = 0; i < a.size(); i++) {
    float e = a.get(i);
    if (i == a.size() - 1) {
      s = s + e;
    } 
    else {
      s = s + e + ", ";
    }
  }
  return s;
}

