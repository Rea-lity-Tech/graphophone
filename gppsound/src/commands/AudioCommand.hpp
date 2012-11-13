/***************************************************************************
 *  AudioCommand.hpp
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
 
#ifndef _AUDIO_COMMAND_H
#define _AUDIO_COMMAND_H

#include <vector>
#include <string>
#include <iostream>

#include "../Voice.hpp"

class GppSound;

class AudioCommand{
	public:
		AudioCommand(const unsigned int&, GppSound*);	
		virtual ~AudioCommand();	
		virtual void run()=0;
		virtual void clear(){}
		virtual AudioCommand* clone()=0;


	protected:

		unsigned int m_voiceID;
        Voice* m_voice;
		std::list<float> m_args;
		GppSound* m_perc;


};



#endif
