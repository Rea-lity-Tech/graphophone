/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package fr.inria.graphophone.attributes.image;

import fr.inria.graphophone.ImageAttribute;
import fr.inria.graphophone.PositionAttribute;
import processing.core.PApplet;
import processing.core.PImage;
import processing.core.PVector;

/**
 *
 * @author jiii
 */
public class GaussianDerivative extends ImageAttribute {

    private PVector gradient = new PVector();

    @Override
    public void computeAt(PositionAttribute pa) {
        PVector pos = pa.getPos();
        float size = pa.getSize();

        currentImage.loadPixels();
        this.gradient = gaussianDerivative(pos, size);
    }

    private PVector gaussianDerivative(PVector pos, float size) {
        int kernelSize = (int) size;
        float sigma = size / 3.0f;
        float dem = 2.0f * sigma * sigma;
        float sumX = 0.0f;
        float sumY = 0.0f;
        for (int yi = 0; yi < 2 * kernelSize + 1; yi++) {
            float wy1 = PApplet.exp(-(float) (yi - kernelSize) * (float) (yi - kernelSize) / dem
            );
            float wy2 = -(float) (yi - kernelSize) * wy1 * 2.0f / dem;

            for (int xi = 0; xi < 2 * kernelSize + 1; xi++) {
                float wx1 = PApplet.exp(-(float) (xi - kernelSize) * (float) (xi - kernelSize) / dem
                );
                float wx2 = -(float) (xi - kernelSize) * wx1 * 2.0f / dem;

                int offset = ((int) pos.y + yi - kernelSize) * currentImage.width + ((int) pos.x + xi - kernelSize);

                int c = 0;

                if (offset >= 0 && offset < currentImage.width * currentImage.height) {
                    c = currentImage.pixels[offset];
                } else {
                    c = 0;
                }

                int red = c >> 16 & 0xFF;
                int green = c >> 8 & 0xFF;
                int blue = c & 0xFF;

                float val = (red + green + blue) / (3.0f * 255.0f);
                sumX += val * wy1 * wx2;
                sumY += val * wy2 * wx1;
            }
        }
        return new PVector(sumX, sumY);
    }

    public PVector getGradient() {
        return gradient;
    }
    
    float[] values = new float[2];
    private void fillValues(){
        values[0] = gradient.x;
        values[1] = gradient.y;
    }
    
    @Override
    public float[] getValues() {
        fillValues();
        return values;
    }
}
