import ddf.minim.*;
import ddf.minim.signals.*;
import oscP5.*;
import netP5.*;

OscP5 oscP5;
Minim minim;
AudioOutput out;
GranularSynth synth;

void setup() {
  size(512, 200, P2D);
  
  minim = new Minim(this);
  
  out = minim.getLineOut(Minim.STEREO, 2048);
  synth = new GranularSynth(minim);
  // adds the signal to the output
  out.addSignal(synth);
}

void draw() {
  background(0);
  stroke(255);
}

void stop() {
  out.close();
  minim.stop();  
  super.stop();
}


void oscEvent(OscMessage theOscMessage) {
 if(theOscMessage.checkAddrPattern("/gpp/cre8")==true){
    println("create cursor"); 
  }
 else if(theOscMessage.checkAddrPattern("/gpp/del8")==true){

   
 }
 else if(theOscMessage.checkAddrPattern("/gpp/upd8")==true){
   
 }
 
}


