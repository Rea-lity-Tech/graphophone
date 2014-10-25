/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package fr.inria.graphophone.attributes.sound;

import fr.inria.graphophone.ImageAttribute;
import fr.inria.graphophone.PositionAttribute;
import fr.inria.graphophone.SoundAttribute;
import fr.inria.graphophone.attributes.image.GaussianDerivative;
import fr.inria.graphophone.attributes.image.MeanColor;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.management.monitor.GaugeMonitor;
import javax.sound.midi.MidiUnavailableException;

/**
 *
 * @author jiii
 */
public class NotePlayer extends SoundAttribute {

    float lastNotePlayed = 0;
    float noteInterval = 200;
    float noteSpeed = 80;

    int channel;

    public NotePlayer() {
        tryStartNotePlayer();
        channel = (int) (Math.random() * 10);
    }

    private void tryStartNotePlayer() {
        try {
            Note.startSynth();
        } catch (MidiUnavailableException ex) {
            ex.printStackTrace();
            System.out.println("Impossible to start the midi synthesizer. " + ex);
        }
    }

    /**
     * Requires Gaussian Derivative 
     * @see GaussianDerivative
     */
    public void mapFrom(ImageAttribute imgAtt, PositionAttribute posAtt,
            int time) {

        float amplitude = 10;
        if (imgAtt instanceof GaussianDerivative) {
            amplitude = ((GaussianDerivative) imgAtt).getGradient().mag();
        }

        noteInterval = (1f / posAtt.getSpeed().mag()) * 10;

        if (time - lastNotePlayed > noteInterval) {
            Note.Play(40, (int) noteSpeed, 80, 30, channel);
            lastNotePlayed = time;
        }

    }

    /**
     * 
     * @return always 0 for now. 
     */
    @Override
    public float[] getValues() {
        return new float[1];
    }
}
