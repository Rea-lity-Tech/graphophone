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
import processing.core.PVector; 
import netP5.NetAddress; 
import oscP5.OscMessage; 
import oscP5.OscP5; 
import toxi.geom.*; 
import org.bytedeco.javacpp.opencv_core.IplImage; 
import org.bytedeco.javacpp.freenect; 
import org.bytedeco.javacpp.opencv_core.*; 
import java.nio.IntBuffer; 
import fr.inria.papart.procam.*; 
import fr.inria.papart.procam.display.*; 
import fr.inria.papart.procam.camera.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class cameraInput extends PApplet {





















// PapARt library




Papart papart;
MarkerBoard markerBoard;
PVector boardSize = new PVector(297, 210);  //  21 * 29.7 cm
TrackedView boardView;

int cameraX = 640;
int cameraY = 480;

Camera cameraTracking;


PImage currentImage;
ArrayList<Cursor> cursors = new ArrayList<Cursor>();

public void setup() {

    size((int) (boardSize.x * 2) , (int) (boardSize.y * 2), OPENGL);

    papart = new Papart(this);
    papart.initCamera("0", Camera.Type.OPENCV);
    
    BaseDisplay display = papart.getDisplay();
    display.manualMode();

    MarkerBoard markerBoard = new MarkerBoard
	(sketchPath + "/data/A3-small1.cfg", (int) boardSize.x, (int) boardSize.y);

    cameraTracking = papart.getCameraTracking();
    cameraTracking.trackMarkerBoard(markerBoard);
    markerBoard.setDrawingMode(cameraTracking, true, 10);
    markerBoard.setFiltering(cameraTracking, 30, 4);

    boardView = new TrackedView(markerBoard, cameraX, cameraY);
    cameraTracking.addTrackedView(boardView);

    cameraTracking.trackSheets(true);
}


public void draw() {

    background(0);
    currentImage = cameraTracking.getPView(boardView);
    
    if(currentImage == null)
	return;

    image(currentImage, 0, 0, width, height);

    for (Iterator<Cursor> it = cursors.iterator (); it.hasNext(); ) {
	Cursor cursor = it.next();
	cursor.setImage(currentImage);
	cursor.update(millis());
	cursor.drawSelf(this.g);
	if (!cursor.isActive()) {
	    it.remove();
	}
    }
}

public void mouseReleased() {
  createCursor();
}

public void createCursor() {
    if(currentImage == null)
	return;

  float cursorSize = 5 + random(15);
  Cursor c = new BasicCursor(new PVector(mouseX, mouseY), 
  new PVector(pmouseX - mouseX, pmouseY - mouseY), 
  cursorSize);
  c.setImage(currentImage);
  cursors.add(c);
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "cameraInput" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
