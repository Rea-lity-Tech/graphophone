/***************************************************************************
 *  UpdateVoiceCommand.cpp
 *  2012  Florent Berthaut
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
 
#include "UpdateVoiceCommand.hpp"
#include "../GppSound.hpp"

using namespace std;




UpdateVoiceCommand::UpdateVoiceCommand(const unsigned int& id, 
										GppSound* perc): 
                                        AudioCommand(id, perc), 
										m_nbAnalysedGrains(3) 
{}

UpdateVoiceCommand::~UpdateVoiceCommand() {

}

void UpdateVoiceCommand::run() {

    Voice* voice = m_perc->getVoice(m_voiceID);
	if(voice!=NULL) {
		list<float>::iterator itArgs=m_args.begin();
		voice->setVolume(*itArgs);
		itArgs++;
		voice->setPitch(*itArgs);
		itArgs++;
		voice->setScattering(*itArgs);
		itArgs++;
		voice->setWidth(*itArgs);
		voice->setAnalysedGrains(m_analysedGrains);
	}
}

AudioCommand* UpdateVoiceCommand::clone() {
	return new UpdateVoiceCommand(m_voiceID, m_perc);
}


void UpdateVoiceCommand::setArgs(std::list<float>& args){

	//make sure we have the correct number of values
	args.resize(m_perc->getNbFeatures()+4, 0);

	list<float> features;
	list<float>::iterator itArgs=args.begin();
	//get args
	//volume
	m_args.push_back(*itArgs);
	itArgs++;
	//grainsize
	m_args.push_back(*itArgs);
	itArgs++;
	//scattering
	m_args.push_back(*itArgs);
	itArgs++;
	//width
	m_args.push_back(*itArgs);
	itArgs++;
	//get features: brightness, irreg
	for(;itArgs!=args.end();++itArgs) {
		features.push_back(*itArgs);
	}

	m_perc->getAnalysedGrainsFromFeatures(features, 
											m_analysedGrains, 
											m_nbAnalysedGrains);
}

