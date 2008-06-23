/***********************************************************************

   xinf is not flash.
   Copyright (c) 2006, Daniel Fischer.
 
   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.
																			
   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU		
   Lesser General Public License or the LICENSE file for more details.
   
***********************************************************************/

#include <neko/neko.h>
#ifdef NEKO_OSX
#include <OpenGL/gl.h>
#include <OpenGL/glu.h>
#else
#include <GL/gl.h>
#include <GL/glext.h>
#include <GL/glu.h>
#endif

#ifndef __ADDITIONS_H
#define __ADDITIONS_H

value glfwGetMousePosition();

/*
void gluVerticesOffset( int offset, int n, double *v );
void glTexSubImage2D_RGBA_BYTE( unsigned int tex, int x, int y, int width, int height, const unsigned int *data );
*/


#endif //__ADDITIONS_H
