////////////
// Cursor //
////////////

int cursorID = 0;

class Cursor extends Thread{

    NetAddress remoteLocation;
    OscP5 oscP5;
    int id;
    boolean isActive;

    ImageAttributes imgAtt;
    PositionAttributes posAtt;
    SoundAttributes sndAtt;

    // TODO: make it in a thread 

    Cursor(OscP5 osc, NetAddress remoteLocation, 
	   PVector pos, PVector speed, float size){
	this.id = cursorID++;
	this.oscP5 = osc;
	this.isActive = true;
    
	this.posAtt = new PositionAttributes(pos, speed, size);
	this.imgAtt = new ImageAttributes();
	this.imgAtt.computeAt(posAtt);
	
	this.sndAtt = new SoundAttributes();
	this.sndAtt.mapFrom(imgAtt, posAtt);
	sendInit();
    }

    // public PositionAttributes getPositionAttributes(){
    // 	return posAtt;
    // }

    // public ImageAttributes getImageAttributes(){
    // 	return imgAtt;
    // }

    // public SoundAttributes getSoundAttributes(){
    // 	return imgAtt;
    // }

    private void sendMessage(String type){
	OscMessage myMessage = new OscMessage(type);
	myMessage.add(id);
	myMessage.add(sndAtt.amplitude);
	myMessage.add(sndAtt.amplitude);
	myMessage.add(sndAtt.amplitude);

	myMessage.add(sndAtt.amplitude);
	myMessage.add(sndAtt.amplitude);
	myMessage.add(sndAtt.amplitude);

	myMessage.add(sndAtt.amplitude);

	oscP5.send(myMessage, myRemoteLocation); 
    }

    private void sendInit(){
	sendMessage("/gpp/cre8");
    }

    private void sendUpdate(){
	sendMessage("/gpp/upd8");
    }

    private void sendDelete(){
	sendMessage("/gpp/del8");
    }

    private void checkForCollisions(){
	if(posAtt.pos.x < 0){
	    posAtt.pos.x = 0;
	    posAtt.speed.x = -posAtt.speed.x;
	} 

	if(posAtt.pos.x >=  currentDrawing.width){
	    posAtt.pos.x = currentDrawing.width -1;
	    posAtt.speed.x = -posAtt.speed.x;
	} 

	if(posAtt.pos.y < 0){
	    posAtt.pos.y = 0;
	    posAtt.speed.y = -posAtt.speed.y;
	} 
		
	if(posAtt.pos.y >=  currentDrawing.height){
	    posAtt.pos.y = currentDrawing.height -1;
	    posAtt.speed.y = -posAtt.speed.y;
	}
    }

    public boolean isActive(){
	return this.isActive;
    }

    public void run(){

	while(isActive){
	    update();

	    if(!weirdMode){
		try{
		    Thread.sleep(30);
		}catch(Exception e){}
	    }
	}

    }

    public boolean update(){
  
	// 1- Update cursor attribs from image attribs
	posAtt.mapFrom(imgAtt);

	// 2- Modify cursor attribs based on interface
	checkForCollisions();
 
	// 3 - Update image and sound attribs w/ new cursor
	imgAtt.computeAt(posAtt);

	// sndAtt.mapFrom(imgAtt, posAtt);	
		
	// 4- Decide to continue or terminate 
	if(posAtt.speed.mag() < 0.10){
	    sendDelete();
	    this.isActive = false;
	    return false;
	}

	sendUpdate();
	return true;
    }



    PVector xDir = new PVector(1,0);

    public void drawSelf(PGraphics g){

	if(!this.isActive)
	    return;


	if(weirdMode){
	    //	    g.fill(255, 80);
	    //	    g.stroke(120, 2);

	    PVector v2 = new PVector(60, 80); 

	    PVector dir = new PVector(posAtt.speed.x, posAtt.speed.y);
	    dir.normalize();
	    float angle = degrees(PVector.angleBetween(xDir, dir));

	    noFill();
	    colorMode(HSB, 360, 100, 100);
	    stroke(color(angle, 100, 100), 30);
	    
	    ellipse(posAtt.pos.x, posAtt.pos.y, 4, 4);

	    return;
	}

	g.pushStyle();

	g.fill(255);
	g.stroke(0);
	g.ellipse(posAtt.pos.x, posAtt.pos.y, 8, 8);

	//	rect(posAtt.pos.x, posAtt.pos.y, posAtt.size, posAtt.size);

	g.noFill();
	g.stroke(0, 128);

	g.ellipse(posAtt.pos.x, posAtt.pos.y, posAtt.size, posAtt.size);
	g.line(posAtt.pos.x, 
	       posAtt.pos.y, 
	       posAtt.pos.x + posAtt.speed.x * 5, 
	       posAtt.pos.y + posAtt.speed.y * 5);


	g.popStyle();
    }

}
