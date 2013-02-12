
class EnvelopeManager {
  
 Map<Integer, Envelope> m_envelopes = new Hashtable<Integer, Envelope>(); 
  
 EnvelopeManager(int minSize, int maxSize) {
    for(int i=minSize; i<maxSize; ++i) {
       m_envelopes.put(i, new Envelope(i));
    } 
 }
  
  Envelope getEnvelope(int envSize) {
    return m_envelopes.get(envSize);
  }
  
  
}

