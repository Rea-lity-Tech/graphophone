/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package fr.inria.graphophone.attributes.position;

import fr.inria.graphophone.ImageAttribute;
import fr.inria.graphophone.PositionAttribute;
import fr.inria.graphophone.attributes.image.GaussianDerivative;
import fr.inria.graphophone.attributes.image.MeanColor;
import processing.core.PApplet;
import processing.core.PVector;

/**
 *
 * @author jiii
 */
public class PositionStandard extends PositionAttribute {

    private float viscosity = 0.99f;
    private float angularInertia = 0.6f;
    private float magnitudeInertia = 0.9f;
    private float sizeInertia = 1f;

    private float minSize = 5;
    private float maxSize = 100;

    public PositionStandard(PVector pos, PVector speed, float size) {
        super(pos, speed, size);
    }

    @Override
    public void updatePosition() {
        this.pos.sub(this.speed);
    }

    /**
     * Works with : GaussianDerivative 
     */
    @Override
    protected void updateSpeed() {

        PVector newSpeed = new PVector();
        
        if (currentAttributes instanceof GaussianDerivative) {
            PVector gradient = ((GaussianDerivative) currentAttributes).getGradient();

            PVector newSpeed1 = new PVector(-gradient.y, gradient.x);
            PVector newSpeed2 = new PVector(gradient.y, -gradient.x);

            if (newSpeed1.dot(speed) > newSpeed2.dot(speed)) {
                newSpeed = newSpeed1;
            } else {
                newSpeed = newSpeed2;
            }
        }

        float newMagnitude = newSpeed.mag();
        float prevMagnitude = speed.mag();

        newSpeed.normalize();
        this.speed.normalize();
        this.speed = slerp(speed, newSpeed, (1f - angularInertia));
        this.speed.mult(viscosity * PApplet.lerp(prevMagnitude,
                newMagnitude,
                (1f - magnitudeInertia)));
    }

    /**
     * Works with MeanColor
     * @see MeanColor
     */
    @Override
    protected void updateSize() {

        if (currentAttributes instanceof MeanColor) {
            float lum = brightness((int) ((MeanColor) currentAttributes).getMeanColor()) / 255f;
            float newSize = PApplet.lerp(minSize, maxSize, PApplet.max(0, (lum - 0.5f) * 2));
            this.size = PApplet.lerp(this.size, newSize, (1f - sizeInertia));
        }
    }

    private float brightness(int c) {
        int red = c >> 16 & 0xFF;
        int green = c >> 8 & 0xFF;
        int blue = c & 0xFF;
        return (red + green + blue) / 3f;
    }

    private PVector slerp(PVector v1, PVector v2, float t) {
        PVector v = new PVector(PApplet.lerp(v1.x, v2.x, t),
                PApplet.lerp(v1.y, v2.y, t));
        v.normalize();
        return v;
    }

}
