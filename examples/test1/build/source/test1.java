import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import fr.inria.graphophone.*; 
import fr.inria.graphophone.cursors.*; 
import java.util.ArrayList; 
import java.util.List; 
import java.util.Iterator; 
import processing.core.PGraphics; 
import processing.core.PImage; 
import netP5.NetAddress; 
import oscP5.OscMessage; 
import oscP5.OscP5; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class test1 extends PApplet {














String fileName = "image.jpg";
PImage currentImage;

ArrayList<Cursor> cursors = new ArrayList<Cursor>();

public void settings(){
    currentImage = loadImage(fileName);
    size(currentImage.width, currentImage.height,  P3D);
}

public void setup(){
    OscP5 oscP5 = new OscP5(this,12001);
    NetAddress myRemoteLocation = new NetAddress("127.0.0.1", 8327);  

    SimpleOSCCursor.SetOSCParameters(myRemoteLocation, oscP5);

}

public void draw(){

    image(currentImage, 0, 0);

    for (Iterator<Cursor> it = cursors.iterator(); it.hasNext();) {
	Cursor cursor = it.next();

	cursor.update(millis());
	cursor.drawSelf(this.g);
	
	if(!cursor.isActive()){
	    it.remove();
	}

    }
}



public void mouseReleased(){
    createCursor();
}


public void createCursor(){
    float cursorSize = 5 + random(15);
    Cursor c = new SimpleOSCCursor(new PVector(mouseX, mouseY), 
			       new PVector(pmouseX - mouseX, pmouseY - mouseY),
			       cursorSize);
    c.setImage(currentImage);
    cursors.add(c);
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "test1" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
