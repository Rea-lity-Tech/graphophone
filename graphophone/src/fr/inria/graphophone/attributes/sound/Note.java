/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package fr.inria.graphophone.attributes.sound;

import javax.sound.midi.*;
import processing.core.PApplet;

/**
 *
 * @author jiii
 */
public class Note extends Thread {

    private int noteNumber;
    private int velocity;
    private int duration;
    private int durationOff;
    private int channel;
    private final int NO_DURATION_OFF = -1;

    static public Synthesizer synthesizer = null;
    static public MidiChannel[] channels;
    static protected boolean hasSynthStarted = false;

    static public void startSynth() throws MidiUnavailableException {
        if (hasSynthStarted()) {
            return;
        }

        MidiDevice.Info[] devices = MidiSystem.getMidiDeviceInfo();
        if (devices.length == 0) {
            System.out.println("No MIDI devices found");
        } else {
            for (MidiDevice.Info dev : devices) {
                System.out.println("MIDI device : " + dev);
            }
        }

        synthesizer = MidiSystem.getSynthesizer();
        synthesizer.open();

        Instrument[] instruments = synthesizer.getAvailableInstruments();
        // for(int i =0; i < instruments.length; i++)
        // 	println(i + ": " + instruments[i]);
        //	    synthesizer.loadInstrument(instruments[38]);
        channels = synthesizer.getChannels();
        synthesizer.loadInstrument(instruments[33]);

        for (int i = 0; i < channels.length; i++) {
            channels[i].programChange(0, (int) (Math.random() * 200));
        }

        MidiChannel channel = channels[0];
        channel.programChange(0, 38);
        hasSynthStarted = true;
    }

    public static boolean hasSynthStarted() {
        return hasSynthStarted;
    }

    public void StopSynth() {
        if (synthesizer != null) {
            synthesizer.close();
            synthesizer = null;
        }
    }

    public static void Play(int noteNumber, int velocity, int duration) {
        (new Note(noteNumber, velocity, duration)).start();
    }

    public static void Play(int noteNumber, int velocity, int durationOn, int durationOff) {
        (new Note(noteNumber, velocity, durationOn, durationOff)).start();
    }

    public static void Play(int noteNumber, int velocity, int durationOn, int durationOff, int channel) {
        (new Note(noteNumber, velocity, durationOn, durationOff, channel)).start();
    }

    public Note(int noteNumber, int velocity, int duration) {
        this(noteNumber, velocity, duration, -1);
    }

    public Note(int noteNumber, int velocity, int duration, int durationOff) {
        this(noteNumber, velocity, duration, durationOff, 0);
    }

    public Note(int noteNumber, int velocity, int duration, int durationOff, int channel) {
        this.noteNumber = noteNumber;
        this.velocity = velocity;
        this.duration = duration;
        this.durationOff = durationOff;
        this.channel = channel;
    }

    @Override
    public void run() {

        channels[channel].noteOn(noteNumber, velocity);
        Wait(duration);

        if (durationOff != NO_DURATION_OFF) {
            channels[channel].noteOff(noteNumber, durationOff);
        } else {
            channels[channel].noteOff(noteNumber);
        }
    }

    void Wait(int duration) {
        try {
            Thread.sleep(duration);
        } catch (InterruptedException e) {
        }
    }

}
