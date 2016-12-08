import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;

import oscP5.*;
import netP5.*;

OscP5 oscP5;
Minim minim;
AudioOutput out;
GranularSynth synth;
List<Float> m_inputArgs;

void setup() {
  size(512, 200, P2D);
  
  //audio
  minim = new Minim(this);
  out = minim.getLineOut(Minim.STEREO, 2048);
  synth = new GranularSynth();
  synth.init(minim, ".");
  out.addSignal(synth);

  //osc
  m_inputArgs = new LinkedList<Float>();
  oscP5 = new OscP5(this,8327);

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
 if(theOscMessage.checkTypetag("ifffffff")) {
   m_inputArgs.clear();
   for(int i=1;i<8;i++) {
     m_inputArgs.add(theOscMessage.get(i).floatValue());
   }
   if(theOscMessage.checkAddrPattern("/gpp/cre8")==true){
      //println("create cursor");
     synth.createVoice(theOscMessage.get(0).intValue(), m_inputArgs);
   }
   else if(theOscMessage.checkAddrPattern("/gpp/del8")==true){
      //println("delete cursor");
     synth.deleteVoice(theOscMessage.get(0).intValue(), m_inputArgs);
   }
   else if(theOscMessage.checkAddrPattern("/gpp/upd8")==true){
      //println("update cursor"); 
     synth.updateVoice(theOscMessage.get(0).intValue(), m_inputArgs);
   }
 } 
}


