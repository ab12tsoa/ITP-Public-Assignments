import psvm.*;

SVM model;
float[][] trainingPoints;
int[] labels;

Table data;

PGraphics modelDisplay;
boolean showModel = false;

void setup(){
  size(500,500);
  modelDisplay = createGraphics(500,500);
  //using same data set for model and test, maybe only use first 20 rows for model?
  data = new Table(this, "glass.csv");
  trainingPoints = new float[data.getRowCount()][2]; //2D array: rows by 0 or 1
  labels = new int[data.getRowCount()];
  
  println("number of rows:" + data.getRowCount());
  
  int i = 0;
  for (TableRow row : data) { //divide by (range of data values interested in) to put data between 0 + 1
    trainingPoints[i][0] = row.getFloat(5)*15;
    trainingPoints[i][1] = row.getFloat(3)*15;
    labels[i] = parseType(row.getString(9));    //look in row 10 for data label - will this take a string?
    i++;
    
    //to do: make function that switches between columns to compare: (getFloat(column#))
//columns and alternative code:
//    entry.add(row.getFloat(0)); // Refractive Index    
//    entry.add(row.getFloat(1)); // Na
//    entry.add(row.getFloat(2)); // Mg 
//    entry.add(row.getFloat(3)); // Al
//    entry.add(row.getFloat(4)); // Si
//    entry.add(row.getFloat(5)); // K
//    entry.add(row.getFloat(6)); // Ca
//    entry.add(row.getFloat(7)); // Ba
//    entry.add(row.getFloat(8)); // Fe
//    entry.add(parseType(row.getString(9))); //type

//    if (row.getInt(9) == 1) {
//      window.add(entry);
//    } 
//    else if(row.getInt(9) == 2){
//      table.add(entry);
//    }
//    else if(row.getInt(9) == 3){ //cannot add a () case to else, only to else if()
//      headlamp.add(entry);
//    }
// 
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
      testPoint[0] = (double)x/width;
      testPoint[1] = (double)y/height;
      
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
    
    ellipse(trainingPoints[i][0] * 15, trainingPoints[i][1]* 15, 5, 5);
  }
}
//take label String from end of each row, set to int for model use
int parseType(String s) {
  if (s.equals("build wind float")) {
    return 1;
  } 
  else if (s.equals("headlamps")) {
    return 2;
  } 
  else if(s.equals("tableware")){
    return 3;
  }
  else{return 0;}
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
//  println((int)model.test(p));
}
