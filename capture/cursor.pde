////////////
// Cursor //
////////////

int cursorID = 0;

class Cursor {

    NetAddress remoteLocation;
    OscP5 oscP5;
    int id;
    boolean isActive;

    ImageAttributes imgAtt;
    PositionAttributes posAtt;
    SoundAttributes sndAtt;

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

	if(posAtt.pos.x >=  width){
	    posAtt.pos.x = width -1;
	    posAtt.speed.x = -posAtt.speed.x;
	} 

	if(posAtt.pos.y < 0){
	    posAtt.pos.y = 0;
	    posAtt.speed.y = -posAtt.speed.y;
	} 
		
	if(posAtt.pos.y >=  height){
	    posAtt.pos.y = height -1;
	    posAtt.speed.y = -posAtt.speed.y;
	}
    }

    public boolean update(){
  
	// 1- Update cursor attribs from image attribs
	posAtt.mapFrom(imgAtt);

	// 2- Modify cursor attribs based on interface
	checkForCollisions();
 
	// 3 - Update image and sound attribs w/ new cursor
	imgAtt.computeAt(posAtt);

	sndAtt.mapFrom(imgAtt, posAtt);	
		
	// 4- Decide to continue or terminate 
	if(posAtt.speed.mag() < 0.05){
	    sendDelete();
	    this.isActive = false;
	    return false;
	}

	sendUpdate();
	return true;
    }


    public void drawSelf(PGraphics g){

	pushStyle();
	fill(255);
	stroke(0);
	g.ellipse(posAtt.pos.x, posAtt.pos.y, 8, 8);

	fill(255, 0);
	rectMode(CENTER);
	rect(posAtt.pos.x, posAtt.pos.y, posAtt.size, posAtt.size);
	//	g.ellipse(posAtt.pos.x, posAtt.pos.y, posAtt.size, posAtt.size);

	popStyle();
    }

}
