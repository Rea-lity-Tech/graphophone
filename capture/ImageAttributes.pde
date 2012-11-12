//////////////////////
// Image Attributes //
//////////////////////

class ImageAttributes{
    PVector col;
    PVector gradient;
    int meanColor;
    
    ImageAttributes(){
	this.col = new PVector(0.0, 0.0, 0.0);
	this.gradient = new PVector(1.0, 0.0);
    }

    public void computeAt(PositionAttributes pa){

	PVector pos = pa.pos;
	float size = pa.size;

	// TODO	
	int r = 0, g = 0, b = 0;
	
	int startX = (int) constrain(pos.x - size, 0, currentDrawing.width); 
	int endX   = (int) constrain(pos.x + size, 0, currentDrawing.width); 
	int startY = (int) constrain(pos.y - size, 0, currentDrawing.height); 
	int endY   = (int) constrain(pos.y + size, 0, currentDrawing.height); 

	for(int y = startY; y < endY; y++){
	    for(int x = startX; x < endX; x++){
		int offset = y * width + x;
		int argb = currentDrawing.pixels[offset];
		
		r += (argb >> 16) & 0xFF; 
		g += (argb >> 8) & 0xFF;  
		b += argb & 0xFF;
	    }
	}

	int nb = (endY - startY) * (endX - startX);

	if(nb != 0){	
	    r /= nb;
	    g /= nb;
	    b /= nb;
	    
	    meanColor = color(r,g,b);

	    pushStyle();
	    noStroke();
	    fill(r, g, b);
	    rect(0, 0, 10, 10);
	    popStyle();
	}

    }


}

