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
  // get the names of all of the image files in the "squirrel" folder
  minim = new Minim(this);
  
  String[] folderNames = {"fast", "medium", "slow"};
  for (String f : folderNames){
  // get the names of all of the image files in the "medium" folder
  java.io.File folder = new java.io.File(dataPath(f));
  String[] songName = folder.list();
   for(String s : songName){
    if(s.toCharArray()[0] != '.'){ //ignore hidden files
    processFile(s, f);
    }
   }  
  }
}  
  void processFile(String fileName, String classification){
   AudioPlayer track;
   track = minim.loadFile(classification + "/" + fileName, 2048);
   //track.loop();
    track.getBeats();
    track.close();
    
    println(classification + ": " + fileName);
  
    
  // Create a new file in the sketch directory
  //  output = createWriter("music_svm.csv"); 

  //open song (songName)
  //get bpm using BeatListener (beats)
  
  //get loudness (sound amplitude) using FFT (amp)
  
  //append folder name (musicSpeed) to csv entry
  
  //take results, write to csv
//  output.println(songName +"," + beats + "," + amp + "," + musicSpeed);

  
  
  //turn off PrintWriter so it doesn't loop endlessly 
//  output.flush(); // Writes the remaining data to the file
//  output.close(); // Finishes the file
//  exit(); // Stops the program
  }

void draw(){
  


}
