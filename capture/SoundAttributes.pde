


//////////////////////
// Sound Attributes //
//////////////////////

class SoundAttributes{
    float amplitude;
  
    float lastNotePlayed = 0;
    float noteInterval = 400;
    float noteSpeed = 80;
    
    int channel;

    SoundAttributes(){
	amplitude = 0;
	channel = (int) random(10);
    }


    public void mapFrom(ImageAttributes imgAtt, PositionAttributes posAtt){
	
	// amplitude = imgAtt.gradient.mag();
	
	int r = imgAtt.meanColor >> 16 & 0xFF;

	noteInterval = 100 + (r / 255f) * 800;

	if(millis() - lastNotePlayed > noteInterval){
	    PlayNote(40, (int) noteSpeed, 80, 30, channel);
	    lastNotePlayed = millis();
	}

    }
  
}
