/***************************************************************************
 *            Sample.cpp
 *            Part of Drile
 *
 *  2010  Tardigrade Inc.
 *  http://tardigrade-inc.com 
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

#include "Sample.hpp"

using namespace std;

Sample::Sample(const std::string& name): m_name(name), m_buffer(NULL), 
										m_loaded(false), m_nbUsers(0), 
										m_defaultFrame(0), m_volume(1.0), 
										m_rms(0.0), m_fftSize(1024){
}

Sample::~Sample()
{
	unload();
}

float* Sample::getBuffer()
{
	if(m_loaded) {
		return m_buffer;
	}
	else {
		return NULL;
	}
}

bool Sample::load() {
	//get the file
	SF_INFO sfInfo;
	sfInfo.format=0;
	SNDFILE* sndFile = sf_open(m_name.c_str(), SFM_READ, &sfInfo);

	if(!sndFile) {
		return false;
	}
	
	//test the Samplerate
	m_sampleRate = sfInfo.samplerate;
	
	//channels
	m_channelsCount =  sfInfo.channels;
	
	//frames number
	m_framesCount = (long)(sfInfo.frames);
	m_floatFramesCount = float(m_framesCount);

	//create the buffers
	m_buffer = new float[m_framesCount];

	//read in mono
	int maxNbFramesToRead=1000;
	float cf[m_channelsCount * maxNbFramesToRead];
	int nbFrames;
	int pos = 0;
	while ((nbFrames = sf_readf_float(sndFile,cf,maxNbFramesToRead)) > 0) {
		for (int i = 0; i < nbFrames; ++i) {
			m_buffer[pos]=0;
			for(int j=0; j<m_channelsCount; ++j) {
				m_buffer[pos]+= cf[i*m_channelsCount+j];
			}
			m_buffer[pos]/=float(m_channelsCount);
			pos++;
		}
	}

	m_loaded=true;

	//close the file
	if(sf_close(sndFile)) {
		return false;
	}

	return true;
}

void Sample::setSampleRate(int sr)
{
	m_sampleRate=sr;
	/*
	//if Samplerate different from jack's Samplerate -> reSample
	if(sr != m_sampleRate && m_loaded) {
		m_loaded=false;
		long newFramesCount = (long)((double)m_framesCount / (double) m_sampleRate * (double)sr); 
		float** convs = new float*[m_channelsCount];
		SRC_DATA *datas = new SRC_DATA[m_channelsCount];
		for(int i=0;i<m_channelsCount;++i) {
			convs[i] = new float[newFramesCount];
			datas[i].data_in = m_buffers[i];
			datas[i].data_out = convs[i];
			datas[i].input_frames = m_framesCount;
			datas[i].output_frames = newFramesCount;
			datas[i].src_ratio = (double)sr / (double)m_sampleRate;
			src_simple(datas+i, 0, 1);
		}

		for(int i=0;i<m_channelsCount;++i) {
			delete [] m_buffers[i];	
			m_buffers[i] = new float[datas[i].output_frames_gen];
			for(int j=0;j<datas[i].output_frames_gen;++j) {
				m_buffers[i][j] = convs[i][j];
			}
		}

		m_framesCount = newFramesCount;
		m_floatFramesCount = float(m_framesCount);
		m_sampleRate = sr;

		for(int i=0;i<m_channelsCount;++i) {
			delete [] convs[i];
		}
		delete [] convs;
		delete [] datas;
		
		m_loaded=true;
	}
	*/
}

void Sample::unload() {
	//unload the file
	if(m_buffer) {
		delete [] m_buffer;
	}
	m_loaded=false;
}

const float& Sample::getFrame(const long& offset) {
	if(m_loaded) {
		return m_buffer[offset%m_framesCount];
	}
	else {
		return m_defaultFrame;
	}
}


