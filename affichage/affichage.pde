import oscP5.*;
import netP5.*;

OscP5 oscP5;
PImage background = null;

PVector cursor = null;

void setup() {
  size(800, 600, P2D);

  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 12000);
  cursor = new PVector(-100, -100);

  frameRate(80);
  background(0);
}


void draw() {
//  background(0);
  fill(100);
  stroke(0, 100, 100);
  if (background != null) {
    image(background, 0, 0, 800, 600);
  }

  ellipse(cursor.x, cursor.y, 10, 10);
}



/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */

  if (theOscMessage.checkAddrPattern("/image")==true) {
    println("loading image."); 
    background = loadImage("../../dessin.png");
  }

  if (theOscMessage.checkAddrPattern("/gpp/cre8")==true) {
    int id = theOscMessage.get(0).intValue();
    println("New Cursor, with ID " + id);
  }

  if (theOscMessage.checkAddrPattern("/gpp/del8")==true) {
    int id = theOscMessage.get(0).intValue();
    println("Cursor dead, with ID " + id);
  }

  if (theOscMessage.checkAddrPattern("/gpp/upd8")==true) {
    int id = theOscMessage.get(0).intValue();
    fill(id * 10);
    cursor.x = theOscMessage.get(1).floatValue(); // get the second osc argument
    cursor.y = theOscMessage.get(2).floatValue(); // get the third osc argument
  }
}

