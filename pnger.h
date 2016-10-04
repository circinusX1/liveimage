/*

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/

    Author:  Marius O. Chincisan
    First Release: September 16 - 29 2016
*/
#ifndef PNGER_H
#define PNGER_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <string>
#include "outfilefmt.h"
#include <time.h>
#include <png.h>

struct pngbuffer
{
    char *buffer;
    size_t accum;
    size_t isize;
};


class pnger : public outfilefmt
{
public:
    pnger(int quality);
    virtual ~pnger();
    uint32_t convert420(const uint8_t* fmt420, int w ,int h, int isize, int quality, uint8_t** ppng);
    uint32_t convertBW(const uint8_t* uint8buf, int w, int h, int isize,
                           int quality, uint8_t** pjpeg);

private:
    pngbuffer   _png;
};

#endif // PNGER_H
