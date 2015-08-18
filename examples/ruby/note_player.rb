class NoteAttribute <  Graphophone::SoundAttribute 
  
  def initialize
    tryStartNotePlayer

    ## 3 channels. 
    @channel = (Random.rand * 3).to_i

    @last_note_played = 0
    @note_interval = 500
    @note_duration = 250

    @pitch_base = 10 + Random.rand * 80
  end
  
  
  def tryStartNotePlayer
    begin
      Graphophone::Note.startSynth();

      # Electric Piano 
      Graphophone::Note.channels[0].programChange(0, 4)

      #  Instrument: Tubular Bells bank #0 preset #14
      Graphophone::Note.channels[1].programChange(0, 14)

      # Instrument: Pizzicato Strings bank #0 preset #45
      Graphophone::Note.channels[2].programChange(0, 45)
      
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
    
    #    @note_duration = (1.0 / posAtt.getSpeed.mag) * 5.0
    @pitch = @pitch_base + (posAtt.getSpeed.mag) * 20.0
#    @note_duration = 
    
#    puts "Speed " + (1.0 / posAtt.getSpeed.mag * 5.0).to_s
#    puts "duration " + (posAtt.getSize() * 50).to_s
    @note_duration = posAtt.getSize * 50
    @note_interval = @note_duration / 2
    
    ## grow at slower speeds
    ## Speed 0 to 3 ~ in px 
    if posAtt.getSpeed.mag < 0.5 && posAtt.getSize < 60
      posAtt.size = posAtt.getSize * 1.1
    end

    if posAtt.getSpeed.mag > 1.0 && posAtt.getSize > 15
      posAtt.size = posAtt.getSize * 0.9
    end
    
    
    if (time - @last_note_played > @note_interval)
      Graphophone::Note.Play(@pitch, @note_duration, 0, 0, @channel)
      @last_note_played = time
      
    end
  end
  
  def getValues ;   [0];    end
end




# The orchestra has 129 instruments.
# Instrument: Acoustic Grand Piano bank #0 preset #0
# Instrument: Bright Acoustic Pian bank #0 preset #1
# Instrument: Electric Grand Piano bank #0 preset #2
# Instrument: Honky-tonk Piano bank #0 preset #3
# Instrument: Electric Piano 1 bank #0 preset #4
# Instrument: Electric Piano 2 bank #0 preset #5
# Instrument: Harpsichord bank #0 preset #6
# Instrument: Clavi bank #0 preset #7
# Instrument: Celesta bank #0 preset #8
# Instrument: Glockenspiel bank #0 preset #9
# Instrument: Music Box bank #0 preset #10
# Instrument: Vibraphone bank #0 preset #11
# Instrument: Marimba bank #0 preset #12
# Instrument: Xylophone bank #0 preset #13
# Instrument: Tubular Bells bank #0 preset #14
# Instrument: Dulcimer bank #0 preset #15
# Instrument: Drawbar Organ bank #0 preset #16
# Instrument: Percussive Organ bank #0 preset #17
# Instrument: Rock Organ bank #0 preset #18
# Instrument: Church Organ bank #0 preset #19
# Instrument: Reed Organ bank #0 preset #20
# Instrument: Accordion bank #0 preset #21
# Instrument: Harmonica bank #0 preset #22
# Instrument: Tango Accordion bank #0 preset #23
# Instrument: Acoustic Guitar (nyl bank #0 preset #24
# Instrument: Acoustic Guitar (ste bank #0 preset #25
# Instrument: Electric Guitar (jaz bank #0 preset #26
# Instrument: Electric Guitar (cle bank #0 preset #27
# Instrument: Electric Guitar (mut bank #0 preset #28
# Instrument: Overdriven Guitar bank #0 preset #29
# Instrument: Distortion Guitar bank #0 preset #30
# Instrument: Guitar harmonics bank #0 preset #31
# Instrument: Acoustic Bass bank #0 preset #32
# Instrument: Electric Bass (finge bank #0 preset #33
# Instrument: Electric Bass (pick) bank #0 preset #34
# Instrument: Fretless Bass bank #0 preset #35
# Instrument: Slap Bass 1 bank #0 preset #36
# Instrument: Slap Bass 2 bank #0 preset #37
# Instrument: Synth Bass 1 bank #0 preset #38
# Instrument: Synth Bass 2 bank #0 preset #39
# Instrument: Violin bank #0 preset #40
# Instrument: Viola bank #0 preset #41
# Instrument: Cello bank #0 preset #42
# Instrument: Contrabass bank #0 preset #43
# Instrument: Tremolo Strings bank #0 preset #44
# Instrument: Pizzicato Strings bank #0 preset #45
# Instrument: Orchestral Harp bank #0 preset #46
# Instrument: Timpani bank #0 preset #47
# Instrument: String Ensemble 1 bank #0 preset #48
# Instrument: String Ensemble 2 bank #0 preset #49
# Instrument: SynthStrings 1 bank #0 preset #50
# Instrument: SynthStrings 2 bank #0 preset #51
# Instrument: Choir Aahs bank #0 preset #52
# Instrument: Voice Oohs bank #0 preset #53
# Instrument: Synth Voice bank #0 preset #54
# Instrument: Orchestra Hit bank #0 preset #55
# Instrument: Trumpet bank #0 preset #56
# Instrument: Trombone bank #0 preset #57
# Instrument: Tuba bank #0 preset #58
# Instrument: Muted Trumpet bank #0 preset #59
# Instrument: French Horn bank #0 preset #60
# Instrument: Brass Section bank #0 preset #61
# Instrument: SynthBrass 1 bank #0 preset #62
# Instrument: SynthBrass 2 bank #0 preset #63
# Instrument: Soprano Sax bank #0 preset #64
# Instrument: Alto Sax bank #0 preset #65
# Instrument: Tenor Sax bank #0 preset #66
# Instrument: Baritone Sax bank #0 preset #67
# Instrument: Oboe bank #0 preset #68
# Instrument: English Horn bank #0 preset #69
# Instrument: Bassoon bank #0 preset #70
# Instrument: Clarinet bank #0 preset #71
# Instrument: Piccolo bank #0 preset #72
# Instrument: Flute bank #0 preset #73
# Instrument: Recorder bank #0 preset #74
# Instrument: Pan Flute bank #0 preset #75
# Instrument: Blown Bottle bank #0 preset #76
# Instrument: Shakuhachi bank #0 preset #77
# Instrument: Whistle bank #0 preset #78
# Instrument: Ocarina bank #0 preset #79
# Instrument: Lead 1 (square) bank #0 preset #80
# Instrument: Lead 2 (sawtooth) bank #0 preset #81
# Instrument: Lead 3 (calliope) bank #0 preset #82
# Instrument: Lead 4 (chiff) bank #0 preset #83
# Instrument: Lead 5 (charang) bank #0 preset #84
# Instrument: Lead 6 (voice) bank #0 preset #85
# Instrument: Lead 7 (fifths) bank #0 preset #86
# Instrument: Lead 8 (bass + lead) bank #0 preset #87
# Instrument: Pad 1 (new age) bank #0 preset #88
# Instrument: Pad 2 (warm) bank #0 preset #89
# Instrument: Pad 3 (polysynth) bank #0 preset #90
# Instrument: Pad 4 (choir) bank #0 preset #91
# Instrument: Pad 5 (bowed) bank #0 preset #92
# Instrument: Pad 6 (metallic) bank #0 preset #93
# Instrument: Pad 7 (halo) bank #0 preset #94
# Instrument: Pad 8 (sweep) bank #0 preset #95
# Instrument: FX 1 (rain) bank #0 preset #96
# Instrument: FX 2 (soundtrack) bank #0 preset #97
# Instrument: FX 3 (crystal) bank #0 preset #98
# Instrument: FX 4 (atmosphere) bank #0 preset #99
# Instrument: FX 5 (brightness) bank #0 preset #100
# Instrument: FX 6 (goblins) bank #0 preset #101
# Instrument: FX 7 (echoes) bank #0 preset #102
# Instrument: FX 8 (sci-fi) bank #0 preset #103
# Instrument: Sitar bank #0 preset #104
# Instrument: Banjo bank #0 preset #105
# Instrument: Shamisen bank #0 preset #106
# Instrument: Koto bank #0 preset #107
# Instrument: Kalimba bank #0 preset #108
# Instrument: Bag pipe bank #0 preset #109
# Instrument: Fiddle bank #0 preset #110
# Instrument: Shanai bank #0 preset #111
# Instrument: Tinkle Bell bank #0 preset #112
# Instrument: Agogo bank #0 preset #113
# Instrument: Steel Drums bank #0 preset #114
# Instrument: Woodblock bank #0 preset #115
# Instrument: Taiko Drum bank #0 preset #116
# Instrument: Melodic Tom bank #0 preset #117
# Instrument: Synth Drum bank #0 preset #118
# Instrument: Reverse Cymbal bank #0 preset #119
# Instrument: Guitar Fret Noise bank #0 preset #120
# Instrument: Breath Noise bank #0 preset #121
# Instrument: Seashore bank #0 preset #122
# Instrument: Bird Tweet bank #0 preset #123
# Instrument: Telephone Ring bank #0 preset #124
# Instrument: Helicopter bank #0 preset #125
# Instrument: Applause bank #0 preset #126
# Instrument: Gunshot bank #0 preset #127
# Drumkit: Standard Kit preset #0
