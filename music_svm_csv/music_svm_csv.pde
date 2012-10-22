//create csv from songs

//pull data from fast, medium, slow folders:
//put data on a server, call by url - too much to keep in data file 
//start with just one song
//
//run through beatdetect and fft 

//output to csv
//for beatdetect > 300, output to .csv: filepath, beat#, loudness, fast
//for beatdetect 300 > x > 150, output: ''', medium
//for beatdetect 150 > x > 0, output: ''', slow
import ddf.minim.*;

Minim minim;

PrintWriter output;
String songName = "Song";
int beats = 0;
double amp = 0.00;
String musicSpeed = "Tempo";

void setup(){
  
  minim = new Minim(this);
  
    // Create a new file in the sketch directory
    output = createWriter("music_svm.csv"); 
    
  String[] folderNames = {"fast", "medium", "slow"};
  for (String f : folderNames){
  // get the names of all of the files in the folders
  java.io.File folder = new java.io.File(dataPath(f));
  String[] songs = folder.list();
   for(String s : songs){
    if(s.toCharArray()[0] != '.'){ //ignore hidden file
    
    processFile(s, f);
    }
   }  
  }
   //turn off PrintWriter so it doesn't loop endlessly - this makes an unreadable csv
  output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file
  exit(); // Stops the program

}  
  void processFile(String fileName, String classification){
//   AudioPlayer track;
//   track = minim.loadFile(classification + "/" + fileName, 2048);
//   //track.loop();
////    track.getBeats();
//    track.close();
//    
//    println(classification + ": " + fileName);
//  
//    
 

  //temporary classification cheat to test
    
  //open song (songName)
  //get bpm using BeatListener (beats)
  
  //get loudness (sound amplitude) using FFT (amp)
  
  //append folder name (musicSpeed) to csv entry
   int[] bpm = {120, 125, 130, 145, 150, 155, 160, 165, 170};
   float[] a = {0.1, 0.2, 0.3};
    if(classification == "fast"){
//      beats = bpm[8];
      beats = bpm[int(random(8))];
      amp = a[int(random(2))];
    }
    
  //take results, write to csv
//  output.println(songName +"," + beats + "," + amp + "," + musicSpeed);
    output.println(fileName +"," + beats + "," + amp + "," + classification);
     println(fileName +"," + beats + "," + amp + "," + classification);

  
  
  
  }

void draw(){
 

}
