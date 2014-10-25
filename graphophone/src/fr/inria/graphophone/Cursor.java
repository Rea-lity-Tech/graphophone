/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package fr.inria.graphophone;

import java.awt.geom.Rectangle2D;
import java.util.ArrayList;
import java.util.List;
import netP5.NetAddress;
import oscP5.OscP5;
import processing.core.PGraphics;
import processing.core.PImage;
import processing.core.PVector;

/**
 *
 * @author jiii
 */
public abstract class Cursor {

    private static int lastCursorID = 0;
    protected int id;
    protected boolean isActive;

    protected List<ImageAttribute> imageAttributes = new ArrayList<>();
    protected List<PositionAttribute> positionAttributes = new ArrayList<>();
    protected List<SoundAttribute> soundAttributes = new ArrayList<>();

    private boolean isReady = false;
    protected PImage image = null;
    protected Rectangle bounds = null;

    public Cursor() {
        this.id = lastCursorID++;
    }

    public void setImage(PImage image) {
        this.image = image;
        for (ImageAttribute imageAttribute : imageAttributes) {
            imageAttribute.setImage(image);
        }
        if(this.bounds == null){
            this.bounds = Rectangle.createFrom(image);
        }
    }

    public void setBounds(Rectangle rectangle) {
        this.bounds = Rectangle.getCopyOf(rectangle);
    }
    
    public void checkIfReady(){
        if(this.image == null){
            throw new RuntimeException("Cursor: " + id + " image not set"); 
        }
        if(this.bounds == null){
            throw new RuntimeException("Cursor: " + id + " bounds not set"); 
        }
    }

    public abstract void update(int time);

    public abstract void drawSelf(PGraphics g);

    public boolean isActive() {
        return this.isActive;
    }
}
