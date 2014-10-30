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
public class SimpleOSCCursor extends BasicCursor {

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
        super(pos, speed, size);
        sendInit();
    }

    @Override
    protected void initPositionAttributes(PVector pos, PVector speed, float size) {
        position = new PositionStandard(pos, speed, size);
        positionAttributes.add(position);
    }

    @Override
    protected void initImageAttributes() {
        gaussianDerivative = new GaussianDerivative();
        meanColor = new MeanColor();
        redMajority = new RedMajority();

        imageAttributes.add(gaussianDerivative);
        imageAttributes.add(redMajority);
        imageAttributes.add(meanColor);
    }

    @Override
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
        sendUpdate();
        checkValidity();
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



}
