/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package fr.inria.graphophone.attributes.sound;

/**
 *
 * @author jiii
 */
import javax.sound.midi.*;
import javax.swing.*;

class MidiTest {

    public static void main(String[] args) throws MidiUnavailableException {
        Synthesizer synthesizer = MidiSystem.getSynthesizer();
        synthesizer.open(); 
        Instrument[] orchestra = synthesizer.getAvailableInstruments();

        final StringBuilder sb = new StringBuilder();
        String eol = System.getProperty("line.separator");
        sb.append("The orchestra has ");
        sb.append(orchestra.length);
        sb.append(" instruments.");
        sb.append(eol);
        for (Instrument instrument : orchestra) {
            sb.append(instrument.toString());
            sb.append(eol);
        }
        synthesizer.close();

        Runnable r = new Runnable() {

            @Override
            public void run() {
                JOptionPane.showMessageDialog(null,
                        new JScrollPane(new JTextArea(sb.toString(), 20, 30)));
            }
        };
        SwingUtilities.invokeLater(r);
    }
}