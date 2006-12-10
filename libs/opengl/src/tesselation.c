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
#include <additions.h>
#include <stdlib.h>

#ifdef NEKO_OSX
typedef void(*_GLUfuncptr)();
#endif

/* ------------------------------------------------------------- */
/* simple GLU tesselator, outputs the tesselation using glVertex */
/* ------------------------------------------------------------- */

void simple_tess_combine( GLdouble c[3], void *d[4], GLfloat w[4], void **out ) {
    GLdouble *nv = (GLdouble*)malloc(sizeof(GLdouble)*3);
    nv[0] = c[0];
    nv[1] = c[1];
    nv[2] = c[2];
    *out = nv;
}

void simple_tess_error( GLenum err ) {
    val_throw( alloc_string( "tesselation error" ) );
}

GLUtesselator *gluTessCreate( void ) {
    GLUtesselator *tess = gluNewTess();
    gluTessCallback( tess, GLU_TESS_BEGIN, (_GLUfuncptr)glBegin );
    gluTessCallback( tess, GLU_TESS_VERTEX, (_GLUfuncptr)glVertex3dv );
    gluTessCallback( tess, GLU_TESS_END, (_GLUfuncptr)glEnd );
    gluTessCallback( tess, GLU_TESS_COMBINE, (_GLUfuncptr)simple_tess_combine );
    gluTessCallback( tess, GLU_TESS_ERROR, (_GLUfuncptr)simple_tess_error );
    return tess;
}

void gluTessVertexSimple( GLUtesselator *tess, double *v ) {
    gluTessVertex( tess, v, (void*)v );
}

void gluTessVertexOffset( GLUtesselator *tess, int offset, double *v ) {
	double *_v = v+offset;
    gluTessVertex( tess, _v, (void*)_v );
}

void gluTessClose( GLUtesselator *tess ) {
	gluDeleteTess( tess );
}
