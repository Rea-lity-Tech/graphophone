
/////////////////////////
// Position Attributes //
/////////////////////////

class PositionAttributes{
    PVector pos;
    PVector speed;
    float size;
    
    PositionAttributes(PVector pos, PVector speed, float size){
	this.pos = pos;
	this.speed = speed;
	this.size = size;
    }
    
    public void mapFrom(ImageAttributes imgAtt){

	pos.x -= speed.x;
	pos.y -= speed.y;


	int r = imgAtt.meanColor >> 16 & 0xFF;
	if( r < 200){
	    speed.x *= 1.02f;
	    speed.y *= 1.02f;

	    if(speed.x > 5)
		speed.x = 5;

	    if(speed.y > 5)
		speed.y = 5;

	}else{

	speed.x *= 0.98f;
	speed.y *= 0.98f;
	}
				
    }
}
