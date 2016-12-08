class Envelope {
  
 ArrayList<Float> m_values = new ArrayList<Float>();
  
 Envelope(int envSize) {
   for(int i=0; i<envSize; i++) {
     
     m_values.add(0.5*(1.0 - cos((2.0*PI*(float)i)/(float)(envSize-1))));
   }
 } 
 
 float getValue(int ind) {
    return m_values.get(ind); 
 }
  
}

