import oscP5.*;
import netP5.*;
  
OscP5 oscP5;
PImage background = null;

PVector cursor = null;

void setup(){
  size(800, 600, P2D);
  
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,12000);
  cursor = new PVector(-100, -100);

  frameRate(80);
}


void draw(){
  background(0);

  if(background != null){
    image(background, 0, 0, 800, 600);
  }

  ellipse(cursor.x, cursor.y, 10, 10);
}



/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */

  if(theOscMessage.checkAddrPattern("/image")==true){
    println("loading image."); 
    background = loadImage("../../dessin.png");
  }

  if(theOscMessage.checkAddrPattern("/pos")==true) {
    /* check if the typetag is the right one. */
    if(theOscMessage.checkTypetag("iff")) {
      /* parse theOscMessage and extract the values from the osc message arguments. */
      PVector c = null;

      if(theOscMessage.get(0).intValue() == 0)  // get the first osc argument
	c = cursor;

      cursor.x = theOscMessage.get(1).floatValue(); // get the second osc argument
      cursor.y = theOscMessage.get(2).floatValue(); // get the third osc argument
    }
  }

}
