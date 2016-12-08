/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package fr.inria.graphophone;

/**
 *
 * @author jiii
 */
public abstract class SoundAttribute implements Attribute{

    public abstract void mapFrom(ImageAttribute imgAtt,
            PositionAttribute posAtt, int time);

}
