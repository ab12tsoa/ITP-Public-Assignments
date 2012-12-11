/*
TO DO: add frame shift that changes where one or both sequences start checking
*/
import dynamicprogramming.*;

String text1 = "GCCCTAGCAGCGTATATTGGGC ";
String text2 = "GCGCAATGAAAT ";
int s1; //start position to check sequence1
int s2; //start position to check sequence2

LongestCommonSubsequence lcs;
String LCS;

void setup() {
 
  size(500, 500);
 
  s1 = 0;
  s2 = 0;
  highlights(text1, text2, LCS,s1,s2);
  
  println("Press 1 to reframe sample 1, or Press 2 to reframe sample 2");
 
}

void draw() {
  keyPress();
}

void keyPress(){
  if(keyPressed){
    fill(155);
    rect(0,0,width,height); //fresh screen without calling background in draw
//    println(s1);
    if(key == '1' && s1 < text1.length()-1){
      s1 += 1;
      println("start text1: " +s1);
    }
    else if(key == '2'&& s2 < text2.length()-1){
      s2 += 1;
      println("start text2: " +s2);
  }
  highlights(text1, text2, LCS,s1,s2);
  println("pressed " + s1 + " " + s2);
  }
 
}

void highlights(String text1, String text2, String LCS, int s1, int s2){
  //start at 0 to compare entire strings
  //add to start1 or start2 to change where sequence comparison starts
  int start1 = s1;
  int start2 = s2;
  int off1 = 1; //1 is default
  int off2 = 1; //1 is default
  int end1 = text1.length()-off1;
  int end2 = text2.length()-off2;
  
  
  
  String sample1 = text1.substring(start1, end1);
  String sample2 = text2.substring(start2, end2);
  
  lcs = new LongestCommonSubsequence(sample1, sample2);
  LCS = new String(lcs.getLongestCommonSubsequence() + ' ');
  fill(0);
  println("Longest common substring is " + LCS);
  text("Longest common substring:", 10, 75);
  text(LCS, 10, 100);
  
  float twidth = textWidth(text1.charAt(0));
  int pos = 0;
  for(int i = 0; i < sample1.length(); i++){  
      if(sample1.charAt(i) == LCS.charAt(pos)){    
        if(pos < LCS.length()-1){
          fill(0);
          pos += 1;
        }  
      }
      else{ 
        fill(255);
      }
    
    text(text1.substring(0,start1), 10, 200+text1.length()*2);
    text(sample1.charAt(i), twidth+start1*10, 200+text1.length()*2);
    text(text1.substring(end1, text1.length()-1), twidth, 200+text1.length()*2);
    twidth += textWidth(sample1.charAt(i));  //cheating
  }
  //reset pos
  if(pos == LCS.length()-1){
    pos = 0;
  //reset twidth
  twidth = textWidth(text2.charAt(0));
  }
  
  for(int i = 0; i < sample2.length(); i++){  
      if(sample2.charAt(i) == LCS.charAt(pos)){    
        if(pos < LCS.length()-1){
          fill(0);
          pos += 1;
        }  
      }
      else{ 
        fill(255);
      }
    text(text2.substring(0,start2), 10, 200+text2.length()*2);
    text(sample2.charAt(i), twidth+start2*10, 200+text2.length()*2);
    text(text2.substring(end2, text2.length()-1), 10, 200+text2.length()*2);
    twidth += textWidth(sample2.charAt(i));  //cheating
  }
}
