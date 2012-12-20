import psvm.*;

SVM model;
//Recipe for a Portal cake 
String trainingDocuments[] = {
"1 18.25 ounce package chocolate cake mix",
"1 can prepared coconut pecan frosting",
"3/4 cup vegetable oil",
"4 large eggs",
"1 cup semi-sweet chocolate chips",
"3/4 cups butter or margarine",
"1 2/3 cups granulated sugar",
"2 cups all purpose flour",
"Don't forget garnishes such as:",
"Fish shaped crackers",
"Fish shaped candies",
"Fish shaped solid waste",
"Fish shaped dirt",
"Fish shaped ethyl benzene",
"Pull and peel licorice",
"Fish shaped volatile organic compounds",
"sediment shaped sediment",
"Candy coated peanut butter pieces shaped like fish",
"1 cup lemon juice",
"Alpha resins",
"Unsaturated polyester resin",
"Fiberglass surface resins",
"And volatile malted milk impoundments",
"9 large egg yolks",
"12 medium geosynthetic membranes",
"1 cup granulated sugar",
"An entry called 'how to kill someone with your bare hands'",
"2 cups rhubarb, sliced",
"2/3 cups granulated rhubarb",
"1 tablespoon all-purpose rhubarb",
"1 teaspoon grated orange rhubarb",
"3 tablespoons rhubarb on fire",
"1 large rhubarb",
"1 cross borehole electro-magnetic imaging rhubarb",
"2 tablespoons rhubarb juice",
"Adjustable aluminum head positioner",
"Slaughter electric needle injector",
"Cordless electric needle injector",
"Injector needle driver",
"Injector needle gun",
"Cranial caps",
"And it contains proven preservatives, deep penetration agents, and gas and odor control chemicals that will deodorize and preserve putrid tissue",
"ricotta cheese",
"vanilla extract",
"cinnamon"
};

int labels[] = {
 0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,1,1,0,0,1,1,1,1,0,1,0,1,0,1,1,1,0,0,1,0,1,1,1,1,1,1,1,0,0,0
};

String testDocuments[] = {
 "1 18.25 ounce package yellow cake mix",
 "4 cups ricotta cheese",
 "4 large eggs",
 "4 teaspoons vanilla extract",
 "1 teaspoon ground cinnamon"
};
//test phrases from http://allrecipes.com/recipe/absolutely-delicious-scratch-cake/detail.aspx?event8=1&prop24=SR_Title&e11=cake&e8=Quick%20Search&event10=1&e7=Recipe
//4 large eggs should come up as 0, what is the problem?
//very confused

ArrayList<String> globalDictionary;

void buildGlobalDictionary() {
  globalDictionary = new ArrayList<String>();
  for (int i = 0; i < trainingDocuments.length; i++) {
    String doc = trainingDocuments[i];
    String words[] = split(doc, ' ');
    for (int w = 0; w < words.length; w++) {
      String word = words[w].toLowerCase();
      word = word.replaceAll("\\W", "");
      if (!globalDictionary.contains(word)) {
        globalDictionary.add(word);
      }
    }
  }

  for (int i = 0; i < testDocuments.length; i++) {
    String doc = testDocuments[i];
    String words[] = split(doc, ' ');
    for (int w = 0; w < words.length; w++) {
      String word = words[w].toLowerCase();
      word = word.replaceAll("\\W", "");
      if (!globalDictionary.contains(word)) {
        globalDictionary.add(word);
      }
    }
  }

  println(globalDictionary);
}

int[] buildVector(String input) {
  String[] words = split(input, ' ');
  ArrayList<String> normalizedWords = new ArrayList();
  for (int w = 0; w < words.length; w++) {
    words[w] = words[w].replaceAll("\\W", "");
    normalizedWords.add(words[w].toLowerCase());
  }

  int[] result = new int[globalDictionary.size()];
  for (int i = 0; i < globalDictionary.size(); i++) {
    String word = globalDictionary.get(i);
    if (normalizedWords.contains(word)) {
      result[i] = 1;
    } 
    else {
      result[i] = 0;
    }
  }
  return result;
}

void setup() {
  size(500,500);
  println(trainingDocuments.length);
  println(labels.length);
  buildGlobalDictionary();

  int[][] trainingVectors = new int[trainingDocuments.length][globalDictionary.size()];
  for(int i = 0; i < trainingDocuments.length; i++){
    trainingVectors[i] = buildVector(trainingDocuments[i]);
  }


  model = new SVM(this);
  SVMProblem problem = new SVMProblem();
  problem.setNumFeatures(2);
  problem.setSampleData(labels, trainingVectors);
  model.train(problem);
  
  int[][] testVectors = new int[testDocuments.length][globalDictionary.size()];
  for(int i = 0; i < testDocuments.length; i++){
    testVectors[i] = buildVector(testDocuments[i]);
  }
  
  for(int i = 0; i < testDocuments.length; i++){
   // println("testing: " + testDocuments[i] );
    double score = model.test(testVectors[i]); 
    //println("result: " + score);
  } 
}

void draw() {
background(0);
for (int i =0; i < testDocuments.length; i++) {
    double score = model.test(buildVector(testDocuments[i]));
    if(score == 0){
      fill(0,255,0);
    } else {
      fill(255,0,0);
    }
    text(testDocuments[i] + " [score: "+score+"]", 10, 20*i + 20);
  }
}

void saveGlobalDictionary(){
  String[] strings = new String[globalDictionary.size()];
  strings = globalDictionary.toArray(strings);
  saveStrings(dataPath("dictionary.txt"), strings);
}

void keyPressed(){
  saveGlobalDictionary();
  model.saveModel("model.txt");
}
