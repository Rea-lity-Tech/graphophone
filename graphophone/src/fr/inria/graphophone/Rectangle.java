/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package fr.inria.graphophone;

import processing.core.PImage;

/**
 *
 * @author jiii
 */
public class Rectangle {

    public float minX, minY, maxX, maxY;

    static public Rectangle getCopyOf(Rectangle r) {
        Rectangle out = new Rectangle();
        out.minX = r.minX;
        out.minY = r.minY;
        out.maxX = r.maxX;
        out.maxY = r.maxY;
        return out;
    }

    static public Rectangle createFrom(PImage image) {
        Rectangle out = new Rectangle();
        out.minX = 0;
        out.minY = 0;
        out.maxX = image.width;
        out.maxY = image.height;
        return out;
    }
}
