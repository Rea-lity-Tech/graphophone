/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package fr.inria.graphophone;

/////////////////////////
import processing.core.PApplet;
import processing.core.PVector;

public abstract class PositionAttribute implements Attribute {

    public PVector pos;
    public PVector speed;
    public float size;

    public float minSize = 5;
    public float maxSize = 100;

    static final float DEFAULT_SIZE = 10;

    public ImageAttribute currentAttribute;
    private float[] values;

    public PositionAttribute(PVector pos) {
        this(pos, new PVector(), DEFAULT_SIZE);
    }

    public PositionAttribute(PVector pos, PVector speed, float size) {
        this.pos = pos;
        this.speed = speed;
        this.size = size;
        this.values = new float[5];
    }

    public void mapFrom(ImageAttribute imgAtt) {
        currentAttribute = imgAtt;
        updatePosition();
        updateSpeed();
        updateSize();
    }

    abstract public void updatePosition();

    abstract public void updateSpeed();

    abstract public void updateSize();

    @Override
    public float[] getValues() {
        fillValues();
        return this.values;
    }

    private void fillValues() {
        this.values[0] = pos.x;
        this.values[1] = pos.y;
        this.values[2] = speed.x;
        this.values[3] = speed.y;
        this.values[4] = size;
    }

    public PVector getPos() {
        return pos;
    }

    public PVector getSpeed() {
        return speed;
    }

    public float getSize() {
        return size;
    }

}
