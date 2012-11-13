/***************************************************************************
 *            Sample.hpp
 *            Part of HitPad
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
 
#ifndef _SAMPLE_H
#define _SAMPLE_H

#include <iostream>
#include <stdio.h>
#include <sndfile.h>
#include <samplerate.h>
#include <string.h>
#include <vector>
#include <cmath>



class Sample {
	public:
		Sample(const std::string&);	
		~Sample();	
		
		inline std::string getName(){return m_name;}
		
		bool load();
		void unload();

		const float& getFrame(const long&);
		inline const long& getFramesCount(){return m_framesCount;};
		inline const float& getFloatFramesCount(){return m_floatFramesCount;};
		inline bool isLoaded(){return m_loaded;};	
		float* getBuffer();
		void setSampleRate(int);

		inline std::vector<std::vector<float> >& getAnalysedGrains() {
			return m_analysedGrains;
		}

	private:
		std::string m_name;
		float* m_buffer;
		int m_channelsCount;
		int m_sampleRate;
		long m_framesCount; 
		float m_floatFramesCount;
		bool m_loaded;
		int m_nbUsers;
		float m_defaultFrame;
		float m_volume;
		float m_rms,m_tempRms;

		unsigned int m_fftSize;
		unsigned int m_grainSize;

		std::vector<std::vector<float> > m_analysedGrains;
};



#endif 
