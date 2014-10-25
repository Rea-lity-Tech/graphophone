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
import fr.inria.graphophone.attributes.image.MeanColor;
import fr.inria.graphophone.attributes.image.RedMajority;
import fr.inria.graphophone.attributes.position.PositionStandard;
import fr.inria.graphophone.attributes.sound.NotePlayer;
import java.util.List;
import netP5.NetAddress;
import oscP5.OscMessage;
import oscP5.OscP5;
import processing.core.PGraphics;
import processing.core.PVector;

/**
 *
 * @author jiii
 */
public class SimpleOSCCursor extends Cursor {

    int id;

    // TODO: make it in a thread 
    static public NetAddress remoteLocation;
    static public OscP5 oscP5;

    private GaussianDerivative gaussianDerivative;
    private MeanColor meanColor;
    private RedMajority redMajority;
    private PositionStandard position;

    public static void SetOSCParameters(NetAddress myRemoteLocation, OscP5 osc) {
        remoteLocation = myRemoteLocation;
        oscP5 = osc;
    }

    public SimpleOSCCursor(PVector pos, PVector speed, float size) {
        this.isActive = true;
        initPositionAttributes(pos, speed, size);
        initImageAttributes();
        initSoundAttributes();
        sendInit();
    }

    protected void initPositionAttributes(PVector pos, PVector speed, float size) {
        position = new PositionStandard(pos, speed, size);
        positionAttributes.add(position);
    }

    protected void initImageAttributes() {
        gaussianDerivative = new GaussianDerivative();
        meanColor = new MeanColor();
        redMajority = new RedMajority();

        imageAttributes.add(gaussianDerivative);
        imageAttributes.add(redMajority);
        imageAttributes.add(meanColor);
    }

    protected void initSoundAttributes() {
        soundAttributes.add(new NotePlayer());
    }

    protected void updatePositionFromImage() {
        for (PositionAttribute positionAttribute : positionAttributes) {
            for (ImageAttribute imageAttribute : imageAttributes) {
                positionAttribute.mapFrom(imageAttribute);
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
                sendDelete();
                this.isActive = false;
            }
        }

    }

    @Override
    public void update(int time) {
        checkIfReady();

        updatePositionFromImage();

        // 2- Modify cursor attribs based on interface
        checkForCollisions();

        // 3 - Update image and sound attribs w/ new cursor
        updateImageAttributes();
        updateSoundAttributes(time);

        // All is updated. 
        sendUpdate();

        // Decide to continue or terminate 
        checkValidity();
    }

    protected void sendMessage(String type) {
        OscMessage message = new OscMessage(type);
        message.add(id);

        for (PositionAttribute positionAttribute : positionAttributes) {
            message.add(positionAttribute.getValues());
        }
        for (ImageAttribute imageAttribute : imageAttributes) {
            message.add(imageAttribute.getValues());
        }

        for (SoundAttribute soundAttribute : soundAttributes) {
            message.add(soundAttribute.getValues());
        }

        oscP5.send(message, remoteLocation);
    }

    protected void sendInit() {
        sendMessage("/gpp/cre8");
    }

    protected void sendUpdate() {
        sendMessage("/gpp/upd8");
    }

    protected void sendDelete() {
        sendMessage("/gpp/del8");
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

    @Override
    public void drawSelf(PGraphics g) {

        if (!this.isActive) {
            return;
        }
        g.pushStyle();

        boolean isRed = redMajority.isRedMajority();

        PVector pos = position.getPos();
        PVector speed = position.getSpeed();
        float size = position.getSize();

        // First part, main body
        if (isRed) {
            g.fill(255, 0, 0);
            g.stroke(0);
            g.ellipse(pos.x, pos.y, 15, 15);
        } else {
            g.fill(255);
            g.stroke(0);
            g.ellipse(pos.x, pos.y, 8, 8);
        }

        //	rect(pos.x, pos.y, size, size);
        g.noFill();
        g.stroke(0, 128);

            
        g.ellipse(pos.x, pos.y, size, size);
        g.line(pos.x,
                pos.y,
                pos.x + speed.x * 5,
                pos.y + speed.y * 5);

        g.popStyle();
    }

}
