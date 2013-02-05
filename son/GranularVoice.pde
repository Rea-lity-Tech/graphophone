class GranularVoice {
  
  List<Grain> m_grains = new LinkedList<Grain>(); 
  
  float m_volume;
  float m_pitch;
  float m_width;
  
  float m_grainSize;  
  float m_grainDensity;
  
  boolean m_stopped;
  
  void init() {
    println("starting voice");
    m_stopped=false;
  }
  
  void stop() {
    println("stopping voice");
    m_stopped=true;
  }
  
  boolean isOver() {
    return (m_stopped && m_grains.size()==0);
  }
  
  void setVolume(float v) {
    
  }
  
  void setPitch(float p) {
    
  }
  
  void setPitchScale(float ps) {
    
  }
  
  void setResonance(float r) {
    
  }
  
  void setBrightness(float b) {
    
  }
  
  void setNoisiness(float n) {
    
  }
  
  void setGranularity(float g) {
    
  }
  
  void setWidth(float w) {
    
  }
  
  void generate(float[] left, float [] right) {
    //test if should create a new grain
   
    //call generate for each grain
    //remove from the list if done
  }
  
  
  
}
