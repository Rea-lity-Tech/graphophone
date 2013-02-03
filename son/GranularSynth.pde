class GranularSynth implements AudioSignal {

  GranularSynth(Minim minim) {
    Minim m_minim=minim; 
    
  }
  
  AudioPlayer m_player;
  
  float m_volume;
  float m_pitch;
  float m_granularity;
  float m_width;
  
  float m_grainSize;  
  float m_grainDensity;

  void loadSoundFiles(String dir) {
    
    m_player = minim.loadFile("test.wav", 2048); 
    
  }

  void generate(float[] leftBuf) {
   
  }

  void generate(float[] leftBuf, float[] rightBuf) {
    //for ( int f = 0; f < leftBuf.length; f ++ )
    
  }
}

