class NoteAttribute <  Graphophone::SoundAttribute 
  
  def initialize
    tryStartNotePlayer
    @channel = (Random.rand * 10).to_i
    
    @last_note_played = 0
    @note_interval = 200
    @note_speed = 80
  end
  
  
  def tryStartNotePlayer
    begin
      Graphophone::Note.startSynth();
    rescue Exception => e  
      puts e.message
      puts "Impossible to start the midi synthesizer. "
    end
  end
  
  
  # Gaussian Derivative 
  # see GaussianDerivative.java
  
  def mapFrom(imgAtt, posAtt, time) 
    
    amplitude = 10
    if imgAtt.is_a? Graphophone::GaussianDerivative
      amplitude = imgAtt.getGradient.mag
    end
    
     @note_interval = (1.0 / posAtt.getSpeed.mag) * 10.0
    
    if (time - @last_note_played > @note_interval)
      Graphophone::Note.Play(40, @note_speed, 80, 30, @channel);
      @last_note_played = time;
      
    end
  end
  
  def getValues ;   [0];    end
end
