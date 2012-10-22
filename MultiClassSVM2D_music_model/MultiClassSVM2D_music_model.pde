import psvm.*;

SVM model;
float[][] testPoints;
String[] classifier;
int[] labels;

Table data;


void setup() {
  size(200, 200);  
   background(255);
  model = new SVM(this);
  // load the model from a model file
  // the second argument is how many features the problem has 
  model.loadModel("model.txt",2);
  data = new Table(this, "music_svm_test.csv");
  testPoints = new float[data.getRowCount()][2];
  labels = new int[data.getRowCount()];
  
  
  int i = 0;
  for (TableRow row : data) {
    float[] p = new float[2];
    p[0] = row.getFloat(1); 
    p[1] = int(row.getFloat(2)*100); //the leftovers from double were ugly, converted to int
    testPoints[i] = p;
//    labels[i] = stringtoNum(row.getString(3));
//     println(labels[i]);   

 
//   for(int i = 0; i < testPoints.length; i++){
//   // test the point,
  // convert the result to an int
  // and set the fill color based on the result
      int result = (int)model.test(p); 
      println(result); //currently model is showing all results as 3 which is incorrect
    if(result == 1 || p[0] < 140){ //added backup classifier for fill to show approx what model should do
      fill(255,0,0);
    } else if(result == 2 || p[0] < 160){
      fill(0,255,0);
    } else if(result == 3 || p[0] < 180){
      fill(0,0,255);
    }
//  stroke(0);
//  fill(0);
//  ellipse(50,50,20,20);
  ellipse(p[0], p[1], 10, 10); 
  println(p[0]+ "," + p[1]);
    i++;
  } 
 
//  }
//  
}

void draw(){
 
}

