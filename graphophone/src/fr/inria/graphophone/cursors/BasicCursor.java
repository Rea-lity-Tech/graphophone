/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package fr.inria.graphophone.cursors;

import fr.inria.graphophone.Cursor;
import fr.inria.graphophone.ImageAttribute;
import fr.inria.graphophone.PositionAttribute;
import fr.inria.graphophone.SoundAttribute;
import fr.inria.graphophone.attributes.image.GaussianDerivative;
import fr.inria.graphophone.attributes.position.PositionStandard;
import fr.inria.graphophone.attributes.sound.NotePlayer;
import processing.core.PGraphics;
import processing.core.PVector;

/**
 *
 * @author Jeremy Laviole - jeremy.laviole@inria.fr - 
 */
public class BasicCursor extends Cursor {

    private GaussianDerivative gaussianDerivative;
    private PositionStandard position;

    public BasicCursor(PVector pos, PVector speed, float size) {
        this.isActive = true;
        initPositionAttributes(pos, speed, size);
        initImageAttributes();
        initSoundAttributes();
    }

    protected void initPositionAttributes(PVector pos, PVector speed, float size) {
        position = new PositionStandard(pos, speed, size);
        positionAttributes.add(position);
    }

    protected void initImageAttributes() {
        gaussianDerivative = new GaussianDerivative();
        imageAttributes.add(gaussianDerivative);
    }

    protected void initSoundAttributes() {
        soundAttributes.add(new NotePlayer());
    }

    @Override
    public void update(int time) {
        checkIfReady();
        updatePositionFromImage();
        checkForCollisions();
        updateImageAttributes();
        updateSoundAttributes(time);
        checkValidity();
    }

    protected void updatePositionFromImage() {
        for (PositionAttribute positionAttribute : positionAttributes) {
            for (ImageAttribute imageAttribute : imageAttributes) {
                positionAttribute.mapFrom(imageAttribute);
            }
        }
    }

    protected void checkForCollisions() {
        for (PositionAttribute positionAttribute : positionAttributes) {

            PVector pos = positionAttribute.getPos();
            PVector speed = positionAttribute.getSpeed();

            if (pos.x < bounds.minX) {
                pos.x = bounds.minX;
                speed.x = -speed.x;
            }

            if (pos.x >= bounds.maxX) {
                pos.x = bounds.maxX - 1;
                speed.x = -speed.x;
            }

            if (pos.y < bounds.minY) {
                pos.y = bounds.minY;
                speed.y = -speed.y;
            }

            if (pos.y >= bounds.maxY) {
                pos.y = bounds.maxY - 1;
                speed.y = -speed.y;
            }
        }

    }

    protected void updateImageAttributes() {
        for (PositionAttribute positionAttribute : positionAttributes) {
            for (ImageAttribute imageAttribute : imageAttributes) {
                imageAttribute.computeAt(positionAttribute);
            }
        }
    }

    protected void updateSoundAttributes(int time) {
        for (SoundAttribute soundAttribute : soundAttributes) {
            for (PositionAttribute positionAttribute : positionAttributes) {
                for (ImageAttribute imageAttribute : imageAttributes) {
                    soundAttribute.mapFrom(imageAttribute, positionAttribute, time);
                }
            }
        }
    }

    static final float MINUMUM_SPEED = 0.10f;

    // TODO: warning deleted when one PositionAttribute is dead !
    protected void checkValidity() {
        for (PositionAttribute positionAttribute : positionAttributes) {
            if (positionAttribute.getSpeed().mag() < MINUMUM_SPEED) {
                this.isActive = false;
            }
        }
    }

    @Override
    public void drawSelf(PGraphics g) {

        if (!this.isActive) {
            return;
        }
        g.pushStyle();

        PVector pos = position.getPos();
        PVector speed = position.getSpeed();
        float size = position.getSize();

        g.fill(255, 100);
        g.stroke(0, 128);
        
        g.ellipse(pos.x, pos.y, size, size);
        g.line(pos.x,
                pos.y,
                pos.x + speed.x * 5,
                pos.y + speed.y * 5);

        g.popStyle();
    }

}
