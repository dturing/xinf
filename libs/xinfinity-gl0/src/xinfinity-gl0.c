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

#include "xinfinity-gl0.h"
#include <GL/gl.h>

static void indent( int indent ) {
    int i;
    for( i=0; i<indent; i++ ) {
        printf("  ");
    }
}

gl0Renderer* gl0CreateRenderer( int w, int h ) {
    printf("CreateRenderer(%i,%i)\n",w,h);
    
    gl0Renderer *re = (gl0Renderer*)malloc(sizeof(gl0Renderer));
    memset(re,0,sizeof(gl0Renderer));
    return re;
}

void gl0StartObject( gl0Renderer* re, int id ) {
    glNewList( id+1, GL_COMPILE );
}

void gl0EndObject( gl0Renderer* re ) {
    glEndList();
}

void gl0ShowObject( gl0Renderer* re, int id ) {
    glCallList( id );
}

void gl0SetTransform( gl0Renderer* re, int id, float x, float y, float a, float b, float c, float d ) {
    indent(re->indent);
    printf("SetTransform(%i,%f,%f,%f,%f,%f,%f)\n",id,a,b,c,d,x,y);
}

void gl0SetTranslation( gl0Renderer* re, int id, float x, float y ) {
    glNewList( id, GL_COMPILE );
        glPushName( id );
        glPushMatrix();
        glTranslatef( x, y, 0 );
        glCallList( id+1 );
        glPopMatrix();
        glPopName();
    glEndList();
}

void gl0SetFill( gl0Renderer* re, float r, float g, float b, float a ) {
    re->fill_r = r;
    re->fill_g = g;
    re->fill_b = b;
    re->fill_a = a;
}

void gl0SetStroke( gl0Renderer* re, float r, float g, float b, float a, float width ) {
    re->stroke_r = r;
    re->stroke_g = g;
    re->stroke_b = b;
    re->stroke_a = a;
    re->stroke_width = width;
}

void gl0SetFont( gl0Renderer* re, const char *family, int italic, int bold, float size ) {
    indent(re->indent);
    printf("SetFont(%s %s%s%f)\n",family,italic?"italic ":"",bold?"bold":"",size);
}

void gl0StartShape( gl0Renderer* re ) {
    indent(re->indent);
    printf("StartShape()\n");
}

void gl0EndShape( gl0Renderer* re ) {
    indent(re->indent);
    printf("EndShape()\n");
}

void gl0StartPath( gl0Renderer* re, float x, float y ) {
    indent(re->indent);
    printf("StartPath(%f,%f)\n",x,y);
}

void gl0EndPath( gl0Renderer* re ) {
    indent(re->indent);
    printf("EndPath()\n");
}

void gl0Close( gl0Renderer* re ) {
    indent(re->indent);
    printf("Close()\n");
}

void gl0LineTo( gl0Renderer* re, float x, float y ) {
    indent(re->indent);
    printf("LineTo(%f,%f)\n",x,y);
}

void gl0QuadraticTo( gl0Renderer* re, float x1, float y1, float x, float y ) {
    indent(re->indent);
    printf("QuadraticTo(%f,%f,%f,%f)\n",x1,y1,x,y);
}

void gl0CubicTo( gl0Renderer* re, float x1, float y1, float x2, float y2, float x, float y ) {
    indent(re->indent);
    printf("CubicTo(%f,%f,%f,%f,%f,%f)\n",x1,y1,x2,y2,x,y);
}

void gl0Rect( gl0Renderer* re, float l, float t, float w, float h ) {
    if( re->fill_a != 0 ) {
        glColor4f( re->fill_r, re->fill_g, re->fill_b, re->fill_a );
        glRectf( l, t, l+w, t+h );
    }
}

void gl0Circle( gl0Renderer* re, float x, float y, float radius ) {
    indent(re->indent);
    printf("Circle(%f,%f,%f)\n",x,y,radius);
}

void gl0Text( gl0Renderer* re, float x, float y, const char *text ) {
    indent(re->indent);
    printf("Text(%f,%f,%s)\n",x,y,text);
}

void gl0StartNative( gl0Renderer* re, value n ) {
    // FIXME: natives should maybe be int?
    if( !val_is_object(n) ) val_throw(alloc_string("startNative expects a GLObject"));
    int id = val_number( val_field( n, val_id("id") ) );
    indent(re->indent);
    printf("StartNative( %i )\n", id);
    
    glNewList(id,GL_COMPILE);
}

void gl0EndNative( gl0Renderer* re ) {
    glEndList();
}

