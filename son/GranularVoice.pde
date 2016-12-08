class GranularVoice {
  
  float m_volume;
  float m_density;
  float m_densityCounter;
  float m_width;
  float m_pan;
  List<AudioSample> m_samples;
  
  boolean m_stopped;
  
  List<Grain> m_grains = new LinkedList<Grain>(); 
  float m_grainLeftVolume;
  float m_grainRightVolume;
  float m_grainStep;
  float m_grainSize;
  AudioSample m_grainSample;
  float m_grainOffset;  
  
  
  void init(List<AudioSample> samples) {
    m_samples=samples;
    m_grainSample=(AudioSample)m_samples.get(0);
    m_stopped=false;
    println("starting voice");
  }
  
  void stop() {
    m_stopped=true;
    println("stopping voice");
  }
  
  boolean isOver() {
    return (m_stopped && m_grains.size()==0);
  }
  
  void setVolume(float v) {
    m_volume=v;
    m_grainLeftVolume=m_volume;
    m_grainRightVolume=m_volume;
  }
  
  void setPan(float v) {
    //TODO
  }
  
  void setWidth(float w) {
    //TODO
  }
  
  void setPitch(float p) {
    m_grainStep=pow(2.0, ((p-0.5)*127.0-57.0)/12.0);
  }
  
  void setPitchScale(float ps) {
    //TODO 
  }
  
  void setResonance(float r) {
    //TODO
  }
  
  void setGranularity(float g) {
    //TODO set density and grainsize  
    //m_grainSize
  }
  
  void setBrightness(float b) {
    //TODO select among samples
  }
  
  void setNoisiness(float n) {
    //TODO select among samples
  }
  
  
  
  void generate(float[] leftBuf, float [] rightBuf) {
    //test if should create a new grain
    if(m_densityCounter>=m_density && !m_stopped) {
       //TODO add grain to list
      
    }
    
    //call generate for each grain
    //remove from the list if done
    for(Iterator itGrain=m_grains.iterator();itGrain.hasNext();) {
      Grain grain= (Grain)(itGrain.next());
      grain.generate(leftBuf, rightBuf);
      if(grain.isOver()) {
         println("Grain is over");
         itGrain.remove(); 
      }
    }
  }
  
  
  
}
