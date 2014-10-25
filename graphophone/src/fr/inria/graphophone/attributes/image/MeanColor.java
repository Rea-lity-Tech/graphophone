/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package fr.inria.graphophone.attributes.image;

import fr.inria.graphophone.ImageAttribute;
import fr.inria.graphophone.PositionAttribute;
import processing.core.PApplet;
import processing.core.PVector;

/**
 *
 * @author jiii
 */
public class MeanColor extends ImageAttribute {

    private float meanColor;
    float[] values = new float[1];
    
    @Override
    public void computeAt(PositionAttribute pa) {
        PVector pos = pa.getPos();
        float size = pa.getSize();

        currentImage.loadPixels();
        this.meanColor = meanColor(pos, size);
    }

    private int meanColor(PVector pos, float size) {
        int r = 0, g = 0, b = 0;

        if (size == 0) {
            return 0;
        }

        int startX = (int) PApplet.constrain(pos.x - size, 0, currentImage.width);
        int endX = (int) PApplet.constrain(pos.x + size, 0, currentImage.width);
        int startY = (int) PApplet.constrain(pos.y - size, 0, currentImage.height);
        int endY = (int) PApplet.constrain(pos.y + size, 0, currentImage.height);

        for (int y = startY; y < endY; y++) {
            for (int x = startX; x < endX; x++) {
                int offset = y * currentImage.width + x;
                int argb = currentImage.pixels[offset];

                r += (argb >> 16) & 0xFF;
                g += (argb >> 8) & 0xFF;
                b += argb & 0xFF;
            }
        }

        int nb = (endY - startY) * (endX - startX);
        r /= nb;
        g /= nb;
        b /= nb;

        return createColor(r, g, b);
    }

    private int createColor(int r, int g, int b) {
        r = r << 16;
        g = g << 8;
        return r | g | b;
    }

    public float getMeanColor() {
        return meanColor;
    }

    private void fillValues(){
        values[0] = meanColor;
    }
    
    @Override
    public float[] getValues() {
        fillValues();
        return values;
    }
    
}
