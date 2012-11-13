/***************************************************************************
 *            Voice.cpp
 *
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

#include "Voice.hpp"

#include "EnvelopeManager.hpp"

using namespace std;

Voice::Voice(const unsigned int& id):m_id(id), 
								m_minGrainSize(512), m_maxGrainSize(8000), 
								m_minScattering(500), m_maxScattering(15000),
								m_stop(false), m_done(false), 
								m_grainSize(1024), 
								m_volume(1), m_density(1), 
								m_densityCounter(0),
								m_scattering(2000), m_width(1), 
								m_widthSign(1), m_pitch(1) {

}

Voice::~Voice()
{
}


void Voice::process(const unsigned int& nbFrames, 
                    jack_default_audio_sample_t* buffers[2]) {

/*

    for(unsigned int f=0; f<nbFrames; ++f, m_grains[0].position++, 
											m_grains[1].position++) {
        
        //if reach the end of the current grain and previous grain is done
        //swap with the prev grain and reconfigure the current grain
        if(m_grains[0].size-m_grains[0].position < m_grainSize/2
               && m_grains[1].position>=m_grains[1].size && !m_stop) {

            
            m_grains[1].position=m_grains[0].position;
            m_grains[1].size=m_grains[0].size;
            m_grains[1].volumes[0]=m_grains[0].volumes[0];
            m_grains[1].volumes[1]=m_grains[0].volumes[1];
			m_grains[1].analysedGrains.assign(
									m_grains[0].analysedGrains.begin(),
									m_grains[0].analysedGrains.end());
			m_grains[1].offset=m_grains[0].offset;
			m_grains[1].envelope=m_grains[0].envelope;


            m_grains[0].position=0;
            m_grains[0].size=m_grainSize;
            m_widthSign = -m_widthSign;
            m_grains[0].volumes[0]=m_volume * (1.0+m_width*m_widthSign)/2.0;
            m_grains[0].volumes[1]=m_volume * (1.0-m_width*m_widthSign)/2.0;

			m_grains[0].analysedGrains.assign(m_analysedGrains.begin(), 
											m_analysedGrains.end());
			m_grains[0].offset = rand()%(m_scattering*2)-m_scattering;
			m_grains[0].envelope = 
				EnvelopeManager::getInstance()->getEnvelope(m_grainSize);
//			cout<<"new grain with volumeL="<<m_grains[0].volumes[0]<<
//								" volumeR="<<m_grains[0].volumes[1]<<
//								" offset="<<m_grains[0].offset<<
//								" grainSize="<<m_grains[0].size<<
//		" sample1="<<(*(m_grains[0].analysedGrains.begin())).sample->getName()<<
//								" width="<<m_width<<endl;

			cout<<"prev grain "<<m_grains[1].analysedGrains.size()<<endl;

        }

        //process grains
		list<AnalysedGrain>::iterator itAn;
        for(unsigned int g=0; g<2; ++g) {
            if(m_grains[g].analysedGrains.size()>0 &&
					m_grains[g].position<m_grains[g].size) {
				float res=0;
				for(itAn=m_grains[g].analysedGrains.begin(); 
						itAn!=m_grains[g].analysedGrains.end(); ++itAn) {
					res+= (*itAn).sample->getFrame(
											((*itAn).offset
												+m_grains[g].offset
												+m_grains[g].position) 
											%(*itAn).sample->getFramesCount());
				}
                res*=m_grains[g].envelope[m_grains[g].position];
				buffers[0][f]+=res*m_grains[g].volumes[0];
				buffers[1][f]+=res*m_grains[g].volumes[1];
            }
        }

    }
	if(m_grains[0].position>=m_grains[0].size 
			&& m_grains[1].position>=m_grains[1].size) {
		m_done=true;
	}


*/


	if(m_densityCounter>(1.1-m_density)*float(m_grainSize) && !m_stop) {

		//create new grain
		m_grains.push_back(Grain());
		Grain& newGrain = m_grains.back();
		newGrain.position=0;
		newGrain.size=m_grainSize;
		newGrain.pitch=m_pitch;
		m_widthSign = -m_widthSign;
		newGrain.volumes[0]=m_volume * (1.0+m_width*m_widthSign)/2.0;
		newGrain.volumes[1]=m_volume * (1.0-m_width*m_widthSign)/2.0;

		newGrain.analysedGrains.assign(m_analysedGrains.begin(), 
										m_analysedGrains.end());
		newGrain.offset = rand()%(m_scattering*2)-m_scattering;
		newGrain.envelope = 
			EnvelopeManager::getInstance()->getEnvelope(m_grainSize);
	//		cout<<"new grain with volumeL="<<newGrain.volumes[0]<<
	//							" volumeR="<<newGrain.volumes[1]<<
	//							" offset="<<newGrain.offset<<
	//							" grainSize="<<newGrain.size<<
	//	" sample1="<<(*(newGrain.analysedGrains.begin())).sample->getName()<<
	//							" width="<<m_width<<endl;


		m_densityCounter=0;
	}
	else {
		m_densityCounter+=nbFrames;
	}

	//process grains
	list<Grain>::iterator itGrain = m_grains.begin();
	list<AnalysedGrain>::iterator itAn;
	for(;itGrain!=m_grains.end();++itGrain) {
		for(unsigned int f=0; f<nbFrames 
					&& (*itGrain).position<(*itGrain).size; 
				++f, (*itGrain).position++) {

			float res=0;
			for(itAn=(*itGrain).analysedGrains.begin(); 
					itAn!=(*itGrain).analysedGrains.end(); ++itAn) {
				res+= (*itAn).sample->getFrame(
										((*itAn).offset
											+ (*itGrain).offset
                                            +int((*itGrain).position
                                                    *(*itGrain).pitch)) 
										%(*itAn).sample->getFramesCount());
			}
			res/=float((*itGrain).analysedGrains.size());
			res*=(*itGrain).envelope[int((*itGrain).position)];
			buffers[0][f]+=res*(*itGrain).volumes[0];
			buffers[1][f]+=res*(*itGrain).volumes[1];
		}
		if((*itGrain).position>=(*itGrain).size) {
			itGrain=m_grains.erase(itGrain);
		}
	}

	if(m_grains.size()==0 && m_stop) {
		m_done=true;
	}
}

