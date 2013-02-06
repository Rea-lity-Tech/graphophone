class GranularSynth implements AudioSignal {

  Map<Integer,GranularVoice> m_voices = new Hashtable<Integer,GranularVoice>();
  ArrayList<AudioSample> m_samples = new ArrayList<AudioSample>(50);

  void init(Minim minim, String dir) {
   if(minim!=null) {
     m_samples.add(minim.loadSample("mel_0.wav", 2048)); 
   }
  }


  void createVoice(int id, List args) {
    m_voices.put(id, new GranularVoice());
    ((GranularVoice)m_voices.get(id)).init(m_samples); 
    updateVoice(id, args);
  }

  void deleteVoice(int id, List args) {
    updateVoice(id, args);
    ((GranularVoice)m_voices.get(id)).stop();
  }

  void updateVoice(int id, List args) {
    GranularVoice voice = (GranularVoice)(m_voices.get(id));
    voice.setVolume((Float)(args.get(0))); 
    voice.setPitch((Float)(args.get(1))); 
    voice.setPitchScale((Float)(args.get(2)));
    voice.setResonance((Float)(args.get(3)));
    voice.setWidth((Float)(args.get(4)));
    voice.setGranularity((Float)(args.get(5)));
    //voice.setNoisiness((Float)(args.get(5)));
    //voice.setWidth((Float)(args.get(7)));
  }

  void generate(float[] leftBuf, float[] rightBuf) {
    for(Iterator itVoice=m_voices.values().iterator();itVoice.hasNext();) {
      GranularVoice voice = (GranularVoice)(itVoice.next());
      voice.generate(leftBuf, rightBuf);
      if(voice.isOver()) {
         println("voice is over");
         itVoice.remove(); 
      }
    }
  }
  
  void generate(float[] leftBuf) {
    generate(leftBuf, leftBuf);
  }
  
}
