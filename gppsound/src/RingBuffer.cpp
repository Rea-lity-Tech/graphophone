/***************************************************************************
 *  RingBuffer.cpp
 *  Part of HitPad
 *  2012 Florent Berthaut
 *  florent@hitmuri.net
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

#include "RingBuffer.hpp"

using namespace std;

RingBuffer::RingBuffer() {
	AudioCommand* command=NULL;
	m_commandSize=sizeof(command);
	m_ringBuffer = jack_ringbuffer_create(1000*m_commandSize);
	jack_ringbuffer_mlock(m_ringBuffer);
}

RingBuffer::~RingBuffer() {

}

void RingBuffer::addCommand(AudioCommand* command) {
	if(jack_ringbuffer_write_space(m_ringBuffer)>m_commandSize) {
		jack_ringbuffer_write(m_ringBuffer,(char* )&command, m_commandSize);
	}
}


bool RingBuffer::commandsAvailable() {
	return (jack_ringbuffer_read_space(m_ringBuffer)>=m_commandSize);
}

AudioCommand* RingBuffer::getCommand() {
	AudioCommand* newCommand=NULL;
	jack_ringbuffer_read(m_ringBuffer, (char*)&newCommand, m_commandSize);
	return newCommand;
}



