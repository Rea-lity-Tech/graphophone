
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

	float viscosity =  0.99f;
	float angularInertia = 0.6f;
	float magnitudeInertia = 0.9f;
	float sizeInertia = 1f;

	pos.x -= this.speed.x;
	pos.y -= this.speed.y;
	
	PVector newSpeed1 = new PVector(-imgAtt.gradient.y, imgAtt.gradient.x);
	PVector newSpeed2 = new PVector(imgAtt.gradient.y, -imgAtt.gradient.x);

	PVector newSpeed;
	if(newSpeed1.dot(speed) > newSpeed2.dot(speed))
	    newSpeed = newSpeed1;
	else
	    newSpeed = newSpeed2;

	float newMagnitude = newSpeed.mag();
	float prevMagnitude = speed.mag();


	newSpeed.normalize();
	this.speed.normalize();
	this.speed = slerp(speed, newSpeed, (1f - angularInertia));
	this.speed.mult(viscosity * lerp(prevMagnitude, 
					 newMagnitude,
					 (1f-magnitudeInertia)));



	float lum = brightness(imgAtt.colour) / 255f;
	float minSize = 5;
	float maxSize = 100;

	float newSize = lerp(minSize, maxSize, max(0, (lum - 0.5) * 2));
	
	this.size = lerp(this.size, newSize, (1f - sizeInertia));
	
    }


    PVector slerp(PVector v1, PVector v2, float t){

	//PVector out = new PVector(v1.x, v1.y);

	//float angle = PVector.angleBetween(v1, v2);
	//out.rotate(t * angle);

	//return out;
	
	 PVector v = new PVector(lerp(v1.x, v2.x, t),
	 			lerp(v1.y, v2.y, t));
	 v.normalize();
	 return v;
    }



}
