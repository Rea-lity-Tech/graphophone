import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;

class Grain {  
  AudioSample m_sample;
  float m_offset;
  float m_counter;
  float m_step;
  float m_size;
  float m_leftVolume;
  float m_rightVolume;
  
  boolean isOver() {
    return (m_counter>=m_size); 
  }
  
  void generate(float[] leftBuf, float[] rightBuf) {
  
    //for ( int f = 0; f < leftBuf.length; f ++ )
     //player.left.get(i)
    
  }
}
