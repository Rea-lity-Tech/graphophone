/***************************************************************************
 *  EnvelopeManager.hpp
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


#ifndef EnvelopeManager_h
#define EnvelopeManager_h

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
#include <cmath>

#include <jack/types.h>

class EnvelopeManager {
	public:
		static EnvelopeManager* getInstance();
		~EnvelopeManager();

        void init(const unsigned int& minSize, const unsigned int& maxSize);

        float* getEnvelope(const unsigned int& size);

	protected:
		EnvelopeManager();

        std::map<unsigned int, float*> m_envelopes;
};

#endif

