import oscP5.*;
import netP5.*;
  

NetAddress myRemoteLocation;
OscP5 oscP5;

PVector cursor = null;
PVector cursorSpeed;

ArrayList<Cursor> myCursors;

PImage currentDrawing,masque;
// TODO: 
// ImageAnalysis analysis;

void setup(){
  
  size(800, 600, P2D);
    
  /* start oscP5, listening for incoming messages at port 12000 */
  // Not used for receiving. 
  oscP5 = new OscP5(this,12001);

  myRemoteLocation = new NetAddress("193.50.111.113", 8000);  
  
  currentDrawing = loadImage("../dessin.png");
  currentDrawing.loadPixels();
  // TODO: 
	// currentDrawing.loadPixel();
	// analysis = new ImageAnalysis(currentDrawing);

  StartSynth();

  myCursors = new ArrayList<Cursor>();

  frameRate(80);
}



void draw(){

  // black background 
  background(0);

  image(currentDrawing, 0, 0, 800, 600);


  ArrayList<Cursor> toDelete = new ArrayList<Cursor>();
  
  for(Cursor cursor : myCursors){
    cursor.drawSelf(this.g);
    if(!cursor.update())
      toDelete.add(cursor);
  }

  for(Cursor c : toDelete){
    myCursors.remove(c);
  }



}



void mouseReleased(){

  myCursors.add(new Cursor(oscP5, myRemoteLocation, 
			   new PVector(mouseX, mouseY),
			   new PVector(pmouseX - mouseX, pmouseY - mouseY), 40.0));
}




void keyPressed(){





  if(key == 's'){
    println("Saving image"); 
    save("../../dessin.png"); 
    //    sendImageMsg();
  }
}






// float lastCreate = 0;
// float startDrag = 0;

// void mouseDragged() {

  // if(startDrag == 0)
  //   startDrag = millis();


  // if(millis() - startDrag > 40){
  //   startDrag = 0;


  //   if(millis() - lastCreate > 80 ){
      
  //     myCursors.add(new Cursor(oscP5, myRemoteLocation, 
  // 			       new PVector(mouseX, mouseY),
  // 			       new PVector(pmouseX - mouseX, pmouseY - mouseY), 10.0));
  //     lastCreate = millis();  
  //   }
    
  // }
// }

