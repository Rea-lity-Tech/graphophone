//////////////////////
// Image Attributes //
//////////////////////

class ImageAttributes{
    float gradient;
    int colour;
    
    ImageAttributes(){
	this.colour = 0;
	this.gradient = 0.0;
    }

    private float gaussianDerivative(PVector pos, PVector dir, float size){
        int kernelSize = (int)size;
	float sigma = size/3.0;
	float dem = 2.0*sigma*sigma;
	float sumX = 0.0;
	float sumY = 0.0;
	for(int yi=0; yi<2*kernelSize+1; yi++) {
	  float wy1 = exp(-float(yi-kernelSize)*float(yi-kernelSize)/dem);
	  float wy2 = -float(yi-kernelSize)*wy1*2.0/dem;

          for(int xi=0; xi<2*kernelSize+1; xi++) {
	    float wx1 = exp(-float(xi-kernelSize)*float(xi-kernelSize)/dem);
	    float wx2 = -float(xi-kernelSize)*wx1*2.0/dem;

            int offset = ((int)pos.y+yi-kernelSize) * width + ((int)pos.x+xi-kernelSize);
            color c = color(255,255,255);
            if (offset >= 0 && offset < currentDrawing.width*currentDrawing.height){
              c = currentDrawing.pixels[offset];
            }
            float val = (red(c) + green(c) + blue(c))/(3.0*255.0);
            sumX += val * wy1 * wx2;
            sumY += val * wy2 * wx1;
	  }
	}
        PVector grad = new PVector (sumX, sumY);
        return dir.dot(grad);
    }

    private int meanColor(PVector pos, float size){
	int r = 0, g = 0, b = 0;
	
        if (size == 0){
           return color(r,g,b);
        }

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
        r /= nb; g /= nb; b /= nb;
	    
        return color (r,g,b);

    }

    public void computeAt(PositionAttributes pa){

	PVector pos = pa.pos;
	PVector dir = pa.speed;
        dir.normalize();
	float size = pa.size;

        this.gradient = gaussianDerivative(pos, dir, size);
        this.colour = meanColor(pos, size);        
        println(this.gradient);
    }


}
