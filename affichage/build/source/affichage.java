import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import oscP5.*; 
import netP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class affichage extends PApplet {




OscP5 oscP5;
PImage background = null;

PVector cursor = null;

public void setup() {
  

  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 12000);
  cursor = new PVector(-100, -100);

  frameRate(80);
  background(0);
}


public void draw() {
//  background(0);
  fill(100);
  stroke(0, 100, 100);
  if (background != null) {
    image(background, 0, 0, 800, 600);
  }

  ellipse(cursor.x, cursor.y, 10, 10);
}



/* incoming osc message are forwarded to the oscEvent method. */
public void oscEvent(OscMessage theOscMessage) {
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

  public void settings() {  size(800, 600, P2D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "affichage" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
