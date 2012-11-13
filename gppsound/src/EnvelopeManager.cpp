/***************************************************************************
 *  EnvelopeManager.cpp
 *  2012 Florent Berthaut
 *	hitmuri.net
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


#include "EnvelopeManager.hpp"

using namespace std;


EnvelopeManager::EnvelopeManager() {

}

EnvelopeManager::~EnvelopeManager() {

}

EnvelopeManager* EnvelopeManager::getInstance() {
    static EnvelopeManager instance;
    return &instance;
}

void EnvelopeManager::init(const unsigned int& minSize, 
                            const unsigned int& maxSize) {
    for(unsigned int s=minSize; s<=maxSize; ++s) {
        m_envelopes[s]=new float[s];
        for(unsigned int i=0; i<s; ++i) { 
			//hann
            //m_envelopes[s][i]=0.5*(1.0 - cos ((2.0*M_PI*float(i))/float(s-1)));
			//cosine
            m_envelopes[s][i]=sin(M_PI*float(i)/float(s-1)); 
        }
    }
}

float* EnvelopeManager::getEnvelope(const unsigned int& size) {
    if(m_envelopes.find(size)==m_envelopes.end()) {
        throw logic_error("Envelope size not found");
    }
    return m_envelopes[size];
}

