import javax.sound.midi.*;

Synthesizer synthesizer = null;

MidiChannel[] channels;

boolean StartSynth(){

    MidiDevice.Info[] devices = MidiSystem.getMidiDeviceInfo();
    if (devices.length == 0) {
	System.out.println("No MIDI devices found");
    } else {
	for (MidiDevice.Info dev : devices) {
	    System.out.println("MIDI device : " + dev);
	}
    }

    try 
	{
	    synthesizer = MidiSystem.getSynthesizer();
	    println(synthesizer.getDeviceInfo());
	    synthesizer.open();

	    Instrument[] instruments = synthesizer.getAvailableInstruments();
	    // for(int i =0; i < instruments.length; i++)
	    // 	println(i + ": " + instruments[i]);

	    //	    synthesizer.loadInstrument(instruments[38]);
	    channels = synthesizer.getChannels();

	    synthesizer.loadInstrument(instruments[33]);

	    for(int i =0; i < channels.length; i++)
	    	channels[i].programChange(0, (int) (random(200f)));

	    MidiChannel channel = channels[0];
	    channel.programChange(0, 38);



	} 
    catch (MidiUnavailableException e) 
	{ 
	    println("Cannot play! " + e); 
	    return false;
	}
    return true;
}

void StopSynth(){
    if (synthesizer != null)
	{
	    synthesizer.close();
	    synthesizer = null;
	}
}

void Wait(int duration)
{
    try { Thread.sleep(duration); } catch (InterruptedException e) {}
}

void PlayNote(int noteNumber, int velocity, int duration)
{
    (new Note(noteNumber, velocity, duration)).start();

   // MidiChannel[] channels = synthesizer.getChannels();
   //  channels[0].noteOn(noteNumber, velocity);
   //  Wait(duration);
   //  channels[0].noteOff(noteNumber);
}

void PlayNote(int noteNumber, int velocity, int durationOn, int durationOff){
    (new Note(noteNumber, velocity, durationOn, durationOff)).start();
    // MidiChannel[] channels = synthesizer.getChannels();
    // channels[0].noteOn(noteNumber, velocity);
    // Wait(durationOn);
    // channels[0].noteOff(noteNumber, durationOff);
}

void PlayNote(int noteNumber, int velocity, int durationOn, int durationOff, int channel){
    (new Note(noteNumber, velocity, durationOn, durationOff, channel )).start();
}


class Note extends Thread{

    private int noteNumber;
    private int velocity;
    private int duration;
    private int durationOff;
    private int channel;
    private final int NO_DURATION_OFF = -1;

    public Note(int noteNumber, int velocity, int duration){
	this(noteNumber, velocity, duration, -1);
    }
    
    public Note(int noteNumber, int velocity, int duration, int durationOff){
	this(noteNumber, velocity, duration, durationOff, 0);
    }

    public Note(int noteNumber, int velocity, int duration, int durationOff, int channel){
	this.noteNumber = noteNumber;
	this.velocity = velocity;
	this.duration = duration;
	this.durationOff = durationOff;
	this.channel = channel;
    }

    public void run(){

	channels[channel].noteOn(noteNumber, velocity);
	Wait(duration);

	if(durationOff != NO_DURATION_OFF)
	    channels[channel].noteOff(noteNumber, durationOff);
	else
	    channels[channel].noteOff(noteNumber);
    }    

}

