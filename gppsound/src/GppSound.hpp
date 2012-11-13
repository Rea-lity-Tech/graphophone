/***************************************************************************
 *  GppSound.hpp
 *  2012 Florent Berthaut
 *  hitmuri.net
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


#define XTRACT_FFT 1

#ifndef GppSound_h
#define GppSound_h

#include <fstream>
#include <sstream>
#include <iostream>
#include <vector>
#include <map>
#include <pthread.h>
#include <string>
#include <dirent.h>
#include <cstdlib>
#include <stdexcept>

#include <jack/types.h>
#include <jack/ringbuffer.h>
#include <jack/jack.h>

#include "oscPack/osc/OscOutboundPacketStream.h"
#include "oscPack/ip/UdpSocket.h"
#include "oscPack/ip/IpEndpointName.h"
#include "oscPack/osc/OscReceivedElements.h"
#include "oscPack/ip/UdpSocket.h"
#include "oscPack/osc/OscPacketListener.h"
#include "Sample.hpp"
#include "RingBuffer.hpp"
#include "Voice.hpp"
#include "xtract/libxtract.h"

#include "commands/CreateVoiceCommand.hpp"
#include "commands/UpdateVoiceCommand.hpp"
#include "commands/DeleteVoiceCommand.hpp"


class GppSound : public osc::OscPacketListener{	
	public:
		static GppSound* getInstance();
		~GppSound();

		void start(const std::string& fileName);
		void ProcessMessage(const osc::ReceivedMessage&, const IpEndpointName&);
		void processAudio(const unsigned int&);

		void addVoice(const unsigned int&, Voice*);
		Voice* getVoice(const unsigned int&);

		void getAnalysedGrainsFromFeatures(const std::list<float>& args, 
											std::list<AnalysedGrain>& grains, 
											const unsigned int& nbGrains);

		inline const unsigned int& getNbFeatures(){return m_nbFeatures;}

	protected:
		GppSound();
		void update();
		void analyse();

		UdpListeningReceiveSocket *m_socket;
		osc::OutboundPacketStream *m_packetStream;
		int m_inputPort;

		std::list<Sample*> m_samples;
		std::list<AnalysedGrain> m_analysedGrains;

        unsigned int m_fftSize;
        unsigned int m_nbFeatures;
		std::vector<float> m_featuresMin;
        std::vector<float> m_featuresMax;
		
/*
        static const unsigned int FEATURES_NB=5;;
        static const unsigned int FEATURES_GRAINS_NB=10;
        static const unsigned int FEATURES_VALUES_NB=50;
		std::vector<AnalysedGrain> m_grainsMap[FEATURES_VALUES_NB]
                                                [FEATURES_VALUES_NB]
                                                [FEATURES_VALUES_NB]
                                                [FEATURES_VALUES_NB];
		std::vector<AnalysedGrain> m_tempMap[FEATURES_VALUES_NB]
                                                [FEATURES_VALUES_NB]
                                                [FEATURES_VALUES_NB]
                                                [FEATURES_VALUES_NB];
*/
		friend int jackCallback(jack_nframes_t , void *);

		jack_client_t *m_jackClient;
		unsigned int m_sampleRate;	
		unsigned int m_bufferSize;	
		jack_port_t* m_audioPortLeft;
		jack_port_t* m_audioPortRight;
		RingBuffer* m_ringBufferToJack;
		RingBuffer* m_ringBufferFromJack;

        std::list<Voice*> m_voices;
        std::map<unsigned int, Voice*> m_voicesMap;
};

#endif

