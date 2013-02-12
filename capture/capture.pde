import oscP5.*;
import netP5.*;

// GLGraphics and OpenGL 
import javax.media.opengl.GL;
import processing.opengl.*;
import codeanticode.glgraphics.*;


NetAddress myRemoteLocation;
OscP5 oscP5;

PVector cursor = null;
PVector cursorSpeed;

ArrayList<Cursor> myCursors;

PImage currentDrawing,masque,currentSobel;

// TODO: 
// ImageAnalysis analysis;


//GLSLShader sobelShader;
GLTexture myTexture, dest;
GLTextureFilter sobelFilter;

void setup(){
  
  size(800, 600,  GLConstants.GLGRAPHICS);
    
  /* start oscP5, listening for incoming messages at port 12000 */
  // Not used for receiving. 
  oscP5 = new OscP5(this,12001);

  myRemoteLocation = new NetAddress("localhost", 8000);  
  
  myTexture = new GLTexture(this, "../dessin.png");
  dest = new GLTexture(this, 800, 600);
  currentDrawing = loadImage("../dessin.png");
  currentSobel = loadImage("../dessin.png");
  currentDrawing.loadPixels();
  // TODO: 
	// currentDrawing.loadPixel();
	// analysis = new ImageAnalysis(currentDrawing);

  StartSynth();

  myCursors = new ArrayList<Cursor>();

  sobelFilter = new GLTextureFilter(this, "sobel.xml");

  float[] pixelSize = new float[2];
  pixelSize[0] = 1f / width;
  pixelSize[1] = 1f / height;
  sobelFilter.setParameterValue("wh", pixelSize);
  sobelFilter.apply(myTexture, dest);
  dest.getImage(currentSobel);

  //  sobelShader  = new GLSLShader(this, "sobel.vert", "sobel.frag");
  frameRate(80);
}



void draw(){

  // black background 
  background(0);


  //  myTexture.render();
  // dest.render();
  
  image(currentSobel, 0, 0, 800, 600);
  
  //    image(currentDrawing, 0, 0, 800, 600);

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

