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

#include "xinfinity-dummy.h"

static void indent( int indent ) {
    int i;
    for( i=0; i<indent; i++ ) {
        printf("  ");
    }
}

dummyRenderer* dummyCreateRenderer( int w, int h ) {
    printf("CreateRenderer(%i,%i)\n",w,h);
    
    dummyRenderer *re = (dummyRenderer*)malloc(sizeof(dummyRenderer));
    memset(re,0,sizeof(dummyRenderer));
    return re;
}

void dummyStartObject( dummyRenderer* re, int id ) {
    indent(re->indent);
    printf("StartObject(%i)\n",id);
    re->indent++;
}

void dummyEndObject( dummyRenderer* re ) {
    re->indent--;
    indent(re->indent);
    printf("EndObject()\n");
}

void dummyShowObject( dummyRenderer* re, int id ) {
    indent(re->indent);
    printf("ShowObject(%i)\n",id);
}

void dummySetTransform( dummyRenderer* re, int id, float x, float y, float a, float b, float c, float d ) {
    indent(re->indent);
    printf("SetTransform(%i,%f,%f,%f,%f,%f,%f)\n",id,a,b,c,d,x,y);
}

void dummySetTranslation( dummyRenderer* re, int id, float x, float y ) {
    indent(re->indent);
    printf("SetTranslation(%i,%f,%f)\n",id,x,y);
}

void dummySetFill( dummyRenderer* re, float r, float g, float b, float a ) {
    indent(re->indent);
    printf("SetFill(%f,%f,%f,%f)\n",r,g,b,a);
}

void dummySetStroke( dummyRenderer* re, float r, float g, float b, float a, float width ) {
    indent(re->indent);
    printf("SetStroke(%f,%f,%f,%f,%f)\n",r,g,b,a,width);
}

void dummySetFont( dummyRenderer* re, const char *family, int italic, int bold, float size ) {
    indent(re->indent);
    printf("SetFont(%s %s%s%f)\n",family,italic?"italic ":"",bold?"bold":"",size);
}

void dummyStartShape( dummyRenderer* re ) {
    indent(re->indent);
    printf("StartShape()\n");
}

void dummyEndShape( dummyRenderer* re ) {
    indent(re->indent);
    printf("EndShape()\n");
}

void dummyStartPath( dummyRenderer* re, float x, float y ) {
    indent(re->indent);
    printf("StartPath(%f,%f)\n",x,y);
}

void dummyEndPath( dummyRenderer* re ) {
    indent(re->indent);
    printf("EndPath()\n");
}

void dummyClose( dummyRenderer* re ) {
    indent(re->indent);
    printf("Close()\n");
}

void dummyLineTo( dummyRenderer* re, float x, float y ) {
    indent(re->indent);
    printf("LineTo(%f,%f)\n",x,y);
}

void dummyQuadraticTo( dummyRenderer* re, float x1, float y1, float x, float y ) {
    indent(re->indent);
    printf("QuadraticTo(%f,%f,%f,%f)\n",x1,y1,x,y);
}

void dummyCubicTo( dummyRenderer* re, float x1, float y1, float x2, float y2, float x, float y ) {
    indent(re->indent);
    printf("CubicTo(%f,%f,%f,%f,%f,%f)\n",x1,y1,x2,y2,x,y);
}

void dummyRect( dummyRenderer* re, float l, float t, float w, float h ) {
    indent(re->indent);
    printf("Rect(%f,%f,%fx%f)\n",l,t,w,h);
}

void dummyCircle( dummyRenderer* re, float x, float y, float radius ) {
    indent(re->indent);
    printf("Circle(%f,%f,%f)\n",x,y,radius);
}

void dummyText( dummyRenderer* re, float x, float y, const char *text ) {
    indent(re->indent);
    printf("Text(%f,%f,%s)\n",x,y,text);
}

void dummyStartNative( dummyRenderer* re, value n ) {
    indent(re->indent);
    printf("StartNative( ");
    val_print(n);
    printf(" )\n");
}

void dummyEndNative( dummyRenderer* re ) {
    indent(re->indent);
    printf("EndNative()\n");
}

