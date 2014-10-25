/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package fr.inria.graphophone;

import processing.core.PImage;
import processing.core.PVector;

public abstract class ImageAttribute implements Attribute {

    protected PImage currentImage;

    public void setImage(PImage image) {
        this.currentImage = image;
    }

    public abstract void computeAt(PositionAttribute pa);
    
    @Override
    public abstract float[] getValues();
}
