/***************************************************************************
 *  DeleteVoiceCommand.cpp
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
 
#include "DeleteVoiceCommand.hpp"
#include "../GppSound.hpp"

DeleteVoiceCommand::DeleteVoiceCommand(const unsigned int& id, 
										GppSound* perc): 
                                        UpdateVoiceCommand(id, perc){
}

DeleteVoiceCommand::~DeleteVoiceCommand() {

}

void DeleteVoiceCommand::run() {
    UpdateVoiceCommand::run();
	Voice* voice = m_perc->getVoice(m_voiceID);
	if(voice!=NULL) {
		voice->stop();
	}
}

AudioCommand* DeleteVoiceCommand::clone() {
	return new DeleteVoiceCommand(m_voiceID, m_perc);
}


