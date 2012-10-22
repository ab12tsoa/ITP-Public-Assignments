import psvm.*;

SVM model;
float[][] trainingPoints;
String[] classifier;
int[] labels;

Table data;

PGraphics modelDisplay;
boolean showModel = false;

void setup(){
  size(500,500);
  modelDisplay = createGraphics(200,200);
  
  data = new Table(this, "music_svm.csv");
  trainingPoints = new float[data.getRowCount()][2];
  labels = new int[data.getRowCount()];
  
  
  int i = 0;
  for (TableRow row : data) {
    float[] p = new float[2];
    p[0] = row.getFloat(1); 
    p[1] = row.getFloat(2)*100;
    trainingPoints[i] = p;
    labels[i] = stringtoNum(row.getString(3));
     println(labels[i]);   
    i++;
  }
  
  println("labels: " + labels.length);
  println(labels[0]);
  println(trainingPoints[0]);
  
  model = new SVM(this);
  SVMProblem problem = new SVMProblem();
  problem.setNumFeatures(2);
  problem.setSampleData(labels, trainingPoints);
  model.train(problem);
  
  drawModel();
}


void drawModel(){
  modelDisplay.beginDraw();
  for(int x = 0; x < width; x++){
    for(int y = 0; y < height; y++){
      double[] testPoint = new double[2];
      testPoint[0] = (double)x;
      testPoint[1] = (double)y*100;
      
      double d = model.test(testPoint);
      if((int)d == 1){
        modelDisplay.stroke(255,0,0);
      } else if ((int)d == 2){
        modelDisplay.stroke(0, 255 ,0);
      } else if ((int)d == 3){
        modelDisplay.stroke(0, 0, 255);
      }
      
      modelDisplay.point(x,y);
  
    }
  }
  modelDisplay.endDraw();
}

int stringtoNum(String s){
  if(s.equals("fast")){
    return 3;
  } else if(s.equals("medium")) {
    return 2;
  } else if(s.equals("slow")) {
    return 1;
  } else {
    return 0;
  }
}

void draw(){
  if(showModel){
    image(modelDisplay, 0, 0);
  } else {
    background(255);
  }
  
  stroke(255);
  
  for(int i = 0; i < trainingPoints.length; i++){
    if(labels[i] == 1){
      fill(255,0,0);
    } else if(labels[i] == 2){
      fill(0,255,0);
    } else if(labels[i] == 3){
      fill(0,0,255);
    }
    
    ellipse(trainingPoints[i][0], trainingPoints[i][1], 50, 50);
//    println(trainingPoints[i][0]+","+ trainingPoints[i][1]);
  }
}

void keyPressed(){
  if(key == ' '){
    showModel = !showModel;
  }
  
  if(key == 's'){
      model.saveModel("model.txt");
  }
}

void mousePressed(){
  double[] p = new double[2];
  p[0] = (double)mouseX/width;
  p[1] = (double)mouseY/height;
  println((int)model.test(p));
}
