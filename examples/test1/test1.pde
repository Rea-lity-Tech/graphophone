import fr.inria.graphophone.*;
import fr.inria.graphophone.cursors.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Iterator;
import processing.core.PGraphics;
import processing.core.PImage;

import processing.core.PVector;
import netP5.NetAddress;
import oscP5.OscMessage;
import oscP5.OscP5;

String fileName = "image.jpg";
PImage currentImage;

ArrayList<Cursor> cursors = new ArrayList<Cursor>();

void setup(){
    OscP5 oscP5 = new OscP5(this,12001);
    NetAddress myRemoteLocation = new NetAddress("127.0.0.1", 8327);  

    currentImage = loadImage(fileName);
    SimpleOSCCursor.SetOSCParameters(myRemoteLocation, oscP5);

    size(currentImage.width, currentImage.height,  OPENGL);
}

void draw(){

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



void mouseReleased(){
    createCursor();
}


void createCursor(){
    float cursorSize = 5 + random(15);
    Cursor c = new SimpleOSCCursor(new PVector(mouseX, mouseY), 
			       new PVector(pmouseX - mouseX, pmouseY - mouseY),
			       cursorSize);
    c.setImage(currentImage);
    cursors.add(c);
}
