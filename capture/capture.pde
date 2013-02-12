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

String fileName = "../M_C__Escher_Style_pen_drawing_by_jlevilgenious.jpg";

//GLSLShader sobelShader;
GLTexture myTexture, dest;
GLTextureFilter sobelFilter;


boolean useThread = false;
boolean weirdMode = false;

void setup(){
  
  /* start oscP5, listening for incoming messages at port 12000 */
  // Not used for receiving. 
  oscP5 = new OscP5(this,12001);

  myRemoteLocation = new NetAddress("193.50.110.180", 8327);  
  
  // myTexture = new GLTexture(this, "../dessin.png");
  // dest = new GLTexture(this, 800, 600);
  currentDrawing = loadImage(fileName);


  size(currentDrawing.width, currentDrawing.height,  GLConstants.GLGRAPHICS);

  //  currentSobel = loadImage("../dessin.png");

  currentDrawing.loadPixels();
  // TODO: 
	// currentDrawing.loadPixel();
	// analysis = new ImageAnalysis(currentDrawing);

  //  StartSynth();

  myCursors = new ArrayList<Cursor>();

  // sobelFilter = new GLTextureFilter(this, "sobel.xml");

  // float[] pixelSize = new float[2];
  // pixelSize[0] = 1f / width;
  // pixelSize[1] = 1f / height;
  // sobelFilter.setParameterValue("wh", pixelSize);
  // sobelFilter.apply(myTexture, dest);
  // dest.getImage(currentSobel);

  frameRate(50);

  background(0);
}



void draw(){

  // black background 
    //  background(255);


  //  myTexture.render();
  // dest.render();

  //  if(test)
    //  tint(120);

    if(!weirdMode)
	image(currentDrawing, 0, 0, width, height);

  //  noTint();


  // else
  //  image(currentSobel, 800, 0, 800, 600);

  ArrayList<Cursor> toDelete = new ArrayList<Cursor>();
  
  for(Cursor cursor : myCursors){
 
      cursor.drawSelf(this.g);
      
      if(useThread){


      if(!cursor.isActive())
      	  toDelete.add(cursor);

      }else{
	  if(!cursor.update())
	      toDelete.add(cursor);
      }


  }

  for(Cursor c : toDelete){
    myCursors.remove(c);
  }

  if(test)
      rect(0, 0, 10, 10);

}



void mouseReleased(){

    float cursorSize = 5 + random(15);

    Cursor c = new Cursor(oscP5, myRemoteLocation, 
			  new PVector(mouseX, mouseY),
			  new PVector(pmouseX - mouseX, pmouseY - mouseY), cursorSize);
    if(useThread)
    	c.start();

    myCursors.add(c);
}



boolean test = true;

void keyPressed(){

    if(key == 't')
	test = !test;
  
    if(key == 'w'){
	weirdMode = !weirdMode;
	if(weirdMode)
	    background(0);
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

