/***************************************************************************
 *  GppSound.cpp
 *  2012 Florent Berthaut
 *	hitmuri.net
 ****************************************************************************/
/*
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 */


#include "GppSound.hpp"

#include "EnvelopeManager.hpp"

using namespace std;
using namespace osc;


GppSound::GppSound() {

}

GppSound::~GppSound() {

}

GppSound* GppSound::getInstance() {
    static GppSound instance;
    return &instance;
}

int jackCallback(jack_nframes_t nbFrames, void *arg) {
	GppSound *perc = (GppSound*)arg;
	perc->processAudio(nbFrames);
	return 0;
}

void GppSound::start(const std::string& fileName) {
	//load samples
	DIR *instruDir;
	struct dirent *instruDirStruct;
	std::string instruDirStr = fileName;
	if((instruDir  = opendir(instruDirStr.c_str())) != NULL) {
		while ((instruDirStruct = readdir(instruDir)) != NULL) {
			std::string sampleName = instruDirStruct->d_name;
			if(sampleName[0]!='.' && sampleName.find(".wav")!=string::npos) {

				Sample* newSample = 
					new Sample(instruDirStr+"/"+sampleName);
				if(newSample->load()) {
					//add it to the list and analyse the features
					m_samples.push_back(newSample);
					cout<<"Added sample "<<newSample->getName()<<endl;
				}
				else {
					cout<<"Error loading sample "<<sampleName<<endl;
					delete newSample;
				}
			}
		}
	}


    //generate envelopes
    Voice voice(0);
    EnvelopeManager::getInstance()->init(voice.getMinGrainSize(), 
                                           voice.getMaxGrainSize());

	//analyse all samples
    m_fftSize=1024;
	m_nbFeatures=2;
    m_featuresMin.resize(m_nbFeatures, 2000000);
    m_featuresMax.resize(m_nbFeatures, 0);
	try{
		xtract_init_fft(m_fftSize, XTRACT_SPECTRUM);
	}
	catch(std::exception& e) {
		throw std::logic_error("Error initializing analysis "
									+std::string(e.what()));
	}
	analyse();
	cout<<"Grains loaded and analysed"<<endl;

	//start jack
    m_jackClient=NULL;
	m_jackClient = jack_client_open("Graphophone", JackNoStartServer, NULL);	

    if(!m_jackClient) {
        throw logic_error("Unable to start jack client ! Is Jackd started ?");
    }

	m_sampleRate = jack_get_sample_rate(m_jackClient);	
	m_bufferSize = jack_get_buffer_size(m_jackClient);	
	m_audioPortLeft=jack_port_register (m_jackClient, "GPP-L", 
								JACK_DEFAULT_AUDIO_TYPE, JackPortIsOutput,0);
	m_audioPortRight=jack_port_register (m_jackClient, "GPP-R", 
								JACK_DEFAULT_AUDIO_TYPE, JackPortIsOutput,0);
	//ring buffer
	m_ringBufferToJack = new RingBuffer();
	m_ringBufferFromJack = new RingBuffer();
	//process callback
	jack_set_process_callback (m_jackClient, jackCallback, this);
	//activate the client
	jack_activate(m_jackClient);


	//start the opensoundcontrol receiver
	m_inputPort=8000;
	m_socket = new UdpListeningReceiveSocket(
                        IpEndpointName( IpEndpointName::ANY_ADDRESS, 
                                        m_inputPort ), 
                        this);
    if(!m_socket->IsBound()) {
        throw logic_error("Unable to open OSC client! Is UDP Port 8000 used ?");
    }
    
	m_socket->Run();


	//loop !
	while(1) {
		update();
		usleep(1000);
	}
}

void GppSound::analyse() {

	//GET FEATURES MEAN
	float argf[4];
	argf[0] = (float)m_sampleRate/(float)m_fftSize;
	argf[1] = XTRACT_MAGNITUDE_SPECTRUM;
	argf[2] = 0.f;
	argf[3] = 0.f;

	std::vector<float> tempBuffer(m_fftSize, 0);
	std::vector<float> spectrumBuffer(m_fftSize*2, 0);
    std::vector<float> tempFeatures(m_nbFeatures, 0);
	list<Sample*>::iterator itSamp;
	for(itSamp=m_samples.begin(); itSamp!=m_samples.end(); ++itSamp) {
		unsigned int offset=0;
		while(int(offset+m_fftSize)<(*itSamp)->getFramesCount()) {
			for(unsigned int i=0;i<m_fftSize;++i) {
				tempBuffer[i] = (*itSamp)->getFrame(offset+i);
            }

			//create a AnalysedGrain
			m_analysedGrains.push_back(AnalysedGrain());
			AnalysedGrain& newGrain = m_analysedGrains.back();
			newGrain.features.assign(m_nbFeatures, 0);
			newGrain.sample=(*itSamp);
			newGrain.offset=offset;

			list<float>::iterator itFeat = newGrain.features.begin();

			//fft
			xtract_spectrum(&(tempBuffer[0]), m_fftSize, &argf[0], 
													&(spectrumBuffer[0]));
			//get the features: brightness, noisiness
			//xtract_failsafe_f0(&(tempBuffer[0]), tempBuffer.size(), 
			//					&m_sampleRate, &(*itFeat));
			//itFeat++;
			xtract_spectral_centroid(&(spectrumBuffer[0]), 
										   spectrumBuffer.size()/2,
											NULL, &(*itFeat));
			itFeat++;
			xtract_irregularity_k(&(spectrumBuffer[0]), 
										   spectrumBuffer.size()/2.0,
											NULL, &(*itFeat));

			itFeat=newGrain.features.begin();
			for(unsigned int f=0;f<m_nbFeatures 
									&& itFeat!=newGrain.features.end(); 
								++f,++itFeat) {
				if(*itFeat<m_featuresMin[f]) {
					m_featuresMin[f]=*itFeat;
				}
				if(*itFeat>m_featuresMax[f]) {
					m_featuresMax[f]=*itFeat;
				}
			}
			offset+=m_fftSize;
		}
	}

	for(unsigned int f=0;f<m_nbFeatures; ++f) {
		cout<<"Feature "<<f<<" min="<<m_featuresMin[f]
							<<" max="<<m_featuresMax[f]<<endl;
	}
	

	//stretch the samples feature values from 0 to 1
	//and put the samples at the correct position in the map
    list<AnalysedGrain>::iterator itGrain=m_analysedGrains.begin();
    for(;itGrain!=m_analysedGrains.end();++itGrain) {
		list<float>::iterator itFeat = (*itGrain).features.begin();
        for(unsigned int f=0;f<m_nbFeatures 
						&& itFeat!=(*itGrain).features.end();++f, ++itFeat) {
            (*itFeat)=((*itFeat)-m_featuresMin[f])
						/(m_featuresMax[f]-m_featuresMin[f]);
		}

        /*
        m_grainsMap[int((*itGrain).features[0])][int((*itGrain).features[1])]
                    [int((*itGrain).features[2])][int((*itGrain).features[3])]
            .push_back(*itGrain);
        */
	}

/*

	//grow the samples positions in the map
	bool done=false;
	while(!done) {
		done=true;
        for(unsigned int v1=0; v1<FEATURES_VALUES_NB; ++v1) {
            for(unsigned int v2=0; v2<FEATURES_VALUES_NB; ++v2) {
                for(unsigned int v3=0; v3<FEATURES_VALUES_NB; ++v3) {
                    for(unsigned int v4=0; v4<FEATURES_VALUES_NB; ++v4) {
                       m_grainsMap[v1][v2][v3][v4].assign(
                            m_tempMap[v1][v2][v3][v4].begin(), 
                            m_tempMap[v1][v2][v3][v4].end());
                    }
                }
            }
        }

        cout<<"growing"<<endl;
        for(unsigned int v1=0; v1<FEATURES_VALUES_NB; ++v1) {
            for(unsigned int v2=0; v2<FEATURES_VALUES_NB; ++v2) {
                for(unsigned int v3=0; v3<FEATURES_VALUES_NB; ++v3) {
                    for(unsigned int v4=0; v4<FEATURES_VALUES_NB; ++v4) {
                        for(unsigned int s=0; 
                                s<m_grainsMap[v1][v2][v3][v4].size();++s) {
                            //grow the sample to previous and next if i
                            //not already filled
                            if(v1-1>0) {
                                if(m_grainsMap[v1-1][v2][v3][v4].size()
                                        <FEATURES_VALUES_NB) {
                                    m_tempMap[v1-1][v2][v3][v4].push_back(
                                           m_grainsMap[v1][v2][v3][v4][s]);
                                }
                            }
                            if(v1+1<FEATURES_VALUES_NB-1) {
                                if(m_grainsMap[v1+1][v2][v3][v4].size()
                                        <FEATURES_VALUES_NB) {
                                    m_tempMap[v1+1][v2][v3][v4].push_back(
                                           m_grainsMap[v1][v2][v3][v4][s]);
                                }
                            }
                            if(v2-1>0) {
                                if(m_grainsMap[v1][v2-1][v3][v4].size()
                                        <FEATURES_VALUES_NB) {
                                    m_tempMap[v1][v2-1][v3][v4].push_back(
                                           m_grainsMap[v1][v2][v3][v4][s]);
                                }
                            }
                            if(v2+1<FEATURES_VALUES_NB-1) {
                                if(m_grainsMap[v1][v2+1][v3][v4].size()
                                        <FEATURES_VALUES_NB) {
                                    m_tempMap[v1][v2+1][v3][v4].push_back(
                                           m_grainsMap[v1][v2][v3][v4][s]);
                                }
                            }
                            if(v3-1>0) {
                                if(m_grainsMap[v1][v2][v3-1][v4].size()
                                        <FEATURES_VALUES_NB) {
                                    m_tempMap[v1][v2][v3-1][v4].push_back(
                                           m_grainsMap[v1][v2][v3][v4][s]);
                                }
                            }
                            if(v3+1<FEATURES_VALUES_NB-1) {
                                if(m_grainsMap[v1][v2][v3+1][v4].size()
                                        <FEATURES_VALUES_NB) {
                                    m_tempMap[v1][v2][v3+1][v4].push_back(
                                           m_grainsMap[v1][v2][v3][v4][s]);
                                }
                            }
                            if(v4-1>0) {
                                if(m_grainsMap[v1][v2][v3][v4-1].size()
                                        <FEATURES_VALUES_NB) {
                                    m_tempMap[v1][v2][v3][v4-1].push_back(
                                           m_grainsMap[v1][v2][v3][v4][s]);
                                }
                            }
                            if(v4+1<FEATURES_VALUES_NB-1) {
                                if(m_grainsMap[v1][v2][v3][v4+1].size()
                                        <FEATURES_VALUES_NB) {
                                    m_tempMap[v1][v2][v3][v4+1].push_back(
                                           m_grainsMap[v1][v2][v3][v4][s]);
                                }
                            }
                        }
                        if(m_grainsMap[v1][v2][v3][v4].size()
                                <FEATURES_GRAINS_NB) {
                            done=false;
                        }
                    }
                }
            }
        }
	}
	*/
}

void GppSound::getAnalysedGrainsFromFeatures(
											const std::list<float>& features, 
											std::list<AnalysedGrain>& grains, 
											const unsigned int& nbGrains) {
	if(m_analysedGrains.size()>0) {
		grains.clear();
		list<AnalysedGrain>::iterator itAn=m_analysedGrains.begin();
		list<AnalysedGrain>::iterator itGrains;
		float dist=0;
		grains.push_back(*itAn);
		for(; itAn!=m_analysedGrains.end(); ++itAn) {
			(*itAn).getDistance(features, dist);
			itGrains=grains.begin();
			while(itGrains!=grains.end() && dist > (*itGrains).currentDist) {
				itGrains++;
			}
			if(itGrains!=grains.end()) {
				grains.insert(itGrains, *itAn);
				grains.pop_back();
			} else if(grains.size()<nbGrains) {
				grains.push_back(*itAn);
			}
		}
	}
}


void GppSound::update() {
	//clear and delete audio commands back from jack process
	while(m_ringBufferFromJack->commandsAvailable()) {
		AudioCommand* com = m_ringBufferFromJack->getCommand();
		com->clear();
		delete com;
	}
}

void GppSound::addVoice(const unsigned int& voiceID, Voice* newVoice) {
	if(m_voicesMap.find(voiceID)==m_voicesMap.end()) {
		m_voicesMap[voiceID] =  newVoice;
		m_voices.push_back(newVoice);
	}
	else {
		cout<<"Voice "<<voiceID<<" already exists"<<endl;
	}
}

Voice* GppSound::getVoice(const unsigned int& voiceID) {
	if(m_voicesMap.find(voiceID)==m_voicesMap.end()) {
		return NULL;
	}
	else {
		return m_voicesMap[voiceID];
	}
}

void GppSound::ProcessMessage(const ReceivedMessage& m, 
								const IpEndpointName& remoteEndpoint ) {



//	ReceivedMessageArgumentStream args = m.ArgumentStream();
	ReceivedMessage::const_iterator itArg = m.ArgumentsBegin();

	std::string mess(m.AddressPattern());

    if(mess.find("/gpp/")!=mess.npos && m.ArgumentCount()>0) {
        //getID
		unsigned int id = itArg->AsInt32Unchecked();
        //get attr
        itArg++;
        list<float> args;
        while(itArg!=m.ArgumentsEnd()) {
            args.push_back(itArg->AsFloatUnchecked());
            itArg++;
        }

        if(mess.compare("/gpp/cre8")==0) {
            cout<<"create cursor "<<id<<endl;
			CreateVoiceCommand* newCom = new CreateVoiceCommand(id, this);
			newCom->setArgs(args);
			m_ringBufferToJack->addCommand(newCom);
        }
        else if(mess.compare("/gpp/upd8")==0) {
            cout<<"update cursor "<<id<<endl;
			UpdateVoiceCommand* newCom = new UpdateVoiceCommand(id, this);
			newCom->setArgs(args);
			m_ringBufferToJack->addCommand(newCom);
        }
        else if(mess.compare("/gpp/del8")==0) {
            cout<<"delete cursor "<<id<<endl;
			DeleteVoiceCommand* newCom = new DeleteVoiceCommand(id, this);
			newCom->setArgs(args);
			m_ringBufferToJack->addCommand(newCom);
        }


    }
}

void GppSound::processAudio(const unsigned int& nbFrames) {
	//process commands from ringbuffer
	AudioCommand* newCommand;
	while(m_ringBufferToJack->commandsAvailable()) {
		newCommand = m_ringBufferToJack->getCommand();
		newCommand->run();
		m_ringBufferFromJack->addCommand(newCommand);
	}

	//get main audio output ports
	jack_default_audio_sample_t *out[2];
	out[0] = (jack_default_audio_sample_t *)
				jack_port_get_buffer(m_audioPortLeft, nbFrames);	
	out[1] = (jack_default_audio_sample_t *)
				jack_port_get_buffer(m_audioPortRight, nbFrames);	
	for(unsigned int i=0; i<nbFrames;++i) {
		out[0][i]=0;
		out[1][i]=0;
	}


    //process voices
    list<Voice*>::iterator itVoice;
    for(itVoice=m_voices.begin(); itVoice!=m_voices.end();) {
        (*itVoice)->process(nbFrames, out);
        if((*itVoice)->isDone()) {
            //TODO fill the ringbuffer with the voice that should be deleted
			//m_ringBufferFromJack->addCommand((*itVoice)->getDeleteCommand());
			m_voicesMap.erase((*itVoice)->getID());
			itVoice = m_voices.erase(itVoice);
        }
        else {
            ++itVoice;
        }
    }
}

int main(int argc, char* argv[]) {

	if(argc!=2) {
		cout<<"Usage: perceptgran wav_file_or_dir_name"<<endl;
		return EXIT_FAILURE;
	}

    srand ( time(NULL) );

	GppSound* perc = GppSound::getInstance();
    try {
        perc->start(std::string(argv[1]));
    }
    catch(Exception e) {
        cout<<e.what()<<endl;
    }

	return EXIT_SUCCESS;
}

