/***************************************************************************
 *            Voice.hpp
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
 
#ifndef _Voice_H
#define _Voice_H

#include <iostream>
#include <stdio.h>
#include <string.h>
#include <list>
#include <cmath>
#include <jack/types.h>
#include <cstdlib>

#include "Sample.hpp"

struct AnalysedGrain {
	Sample* sample;
	unsigned int offset;
	std::list<float> features;
    float currentDist;
	void getDistance(const std::list<float>& inFeat, float& dist) {
		currentDist=0;
		std::list<float>::const_iterator itInFeat=inFeat.begin();
		std::list<float>::iterator itFeat=features.begin();
		for(;itInFeat!=inFeat.end() && itFeat!=features.end(); 
				++itInFeat, ++itFeat) {
			currentDist+=((*itFeat)-(*itInFeat))*((*itFeat)-(*itInFeat));
		}
		dist = currentDist = sqrt(currentDist);
	}
};

struct Grain {
    float position;
    float size;
    float volumes[2];
    unsigned int offset;
    float pitch;
    float* envelope;
	std::list<AnalysedGrain> analysedGrains;
};


class Voice {
	public:
		Voice(const unsigned int& id=0);	
		Voice();	
		~Voice();	

        void process(const unsigned int&, 
                    jack_default_audio_sample_t* buffer[2]);

		inline void stop(){m_stop=true;}
		inline bool isDone(){return m_done;}
		inline const unsigned int& getID(){return m_id;}
        
        inline const unsigned int& getMinGrainSize(){return m_minGrainSize;}
        inline const unsigned int& getMaxGrainSize(){return m_maxGrainSize;}

        inline void setGrainSize(const float& size){ 
            m_grainSize=(unsigned int)(size
                                        *float(m_maxGrainSize-m_minGrainSize)
                                        +float(m_minGrainSize));
        }
        inline void setAnalysedGrains(const std::list<AnalysedGrain>& grains){
            m_analysedGrains.assign(grains.begin(),grains.end());
        }
        inline void setVolume(const float& vol) {m_volume=vol;}
        inline void setWidth(const float& width) {m_width=width;}
        inline void setDensity(const float& density) {m_density=density;}
        inline void setScattering(const float& scat) { 
			m_scattering=(unsigned int)(scat
										*float(m_maxScattering-m_minScattering)
										+float(m_minScattering));
		}
        inline void setPitch(const float& pitch){ 
            m_pitch=(pitch*127.0 - 64)/2.0;
        }

	private:
        unsigned int m_id;

        unsigned int m_minGrainSize;
        unsigned int m_maxGrainSize;
        unsigned int m_minScattering;
        unsigned int m_maxScattering;

		bool m_stop;
        bool m_done;
        //Grain m_grains[2];
        std::list<Grain> m_grains;

        unsigned int m_grainSize;
        float m_volume;
        float m_density;
        float m_densityCounter;
        unsigned int m_scattering;
        float m_width;
        float m_widthSign;
        float m_pitch;
        std::vector<AnalysedGrain> m_analysedGrains;

};



#endif 
