
void contourArrays(){
// for(i = 0; i < getNumContours().length - 1; i++){
   for(i = 0; i < 1; i++){
     for(j = 0; j < getContourLength(i) - 1; j++){
        int x = getContourX(i,j);
        int y = getContourY(i,j);
       println("contour: " + i + " points: " + x + "," + y); 
     }
 }
}
