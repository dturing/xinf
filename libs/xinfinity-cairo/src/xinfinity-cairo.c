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
#include <math.h>

#include "xinfinity-cairo.h"

static void indent( int indent ) {
    int i;
    for( i=0; i<indent; i++ ) {
        printf("  ");
    }
}

void cairoPaint( cairoRenderer *re ) {
    if( re->fill_a > 0 ) {
        cairo_set_source_rgba( re->cr, re->fill_r, re->fill_g, re->fill_b, re->fill_a );
        cairo_fill( re->cr );
    }
    if( re->stroke_a > 0 && re->stroke_width>0 ) {
        cairo_set_source_rgba( re->cr, re->stroke_r, re->stroke_g, re->stroke_b, re->stroke_a );
        cairo_set_line_width( re->cr, re->stroke_width );
        cairo_stroke( re->cr );
    }
}

cairoRenderer* cairoCreateRenderer( int w, int h ) {
    printf("CreateRenderer(%i,%i)\n",w,h);
    
    cairoRenderer *re = (cairoRenderer*)malloc(sizeof(cairoRenderer));
    memset(re,0,sizeof(cairoRenderer));
    re->surface = cairo_image_surface_create( CAIRO_FORMAT_ARGB32, w, h );
    re->cr = cairo_create( re->surface );
    return re;
}

void cairoDeleteRenderer( cairoRenderer *re ) {
    // TODO
}

void cairoWriteToPNG( cairoRenderer *re, const char *filename ) {
    cairo_status_t status = cairo_status( re->cr );
    printf("Cairo status: %s\n", cairo_status_to_string(status) );
    
    cairo_surface_flush( re->surface );
//    cairo_surface_finish( re->surface );
    cairo_surface_write_to_png( re->surface, filename );
}

void cairoStartObject( cairoRenderer* re, int id ) {
    cairo_save( re->cr );
}

void cairoEndObject( cairoRenderer* re ) {
    cairo_restore( re->cr );
}

void cairoShowObject( cairoRenderer* re, int id ) {
    indent(re->indent);
    printf("ShowObject(%i)\n",id);
}


void cairoSetTransform( cairoRenderer* re, int id, float x, float y, float a, float b, float c, float d ) {
    // TODO
    cairo_translate( re->cr, x, y );
}

void cairoSetTranslation( cairoRenderer* re, int id, float x, float y ) {
    cairo_translate( re->cr, x, y );
}

void cairoSetFill( cairoRenderer* re, float r, float g, float b, float a ) {
    re->fill_r = r;
    re->fill_g = g;
    re->fill_b = b;
    re->fill_a = a;
}

void cairoSetStroke( cairoRenderer* re, float r, float g, float b, float a, float width ) {
    re->stroke_r = r;
    re->stroke_g = g;
    re->stroke_b = b;
    re->stroke_a = a;
    re->stroke_width = width;
}

void cairoSetFont( cairoRenderer* re, const char *family, int italic, int bold, float size ) {
    cairo_select_font_face( re->cr, family, 
        italic?CAIRO_FONT_SLANT_ITALIC:CAIRO_FONT_SLANT_NORMAL, 
        bold?CAIRO_FONT_WEIGHT_BOLD:CAIRO_FONT_WEIGHT_NORMAL );
    cairo_set_font_size( re->cr, size );
    printf("setFont %s\n",family );
}

void cairoStartShape( cairoRenderer* re ) {
//    cairo_new_path( re->cr );
}

void cairoEndShape( cairoRenderer* re ) {
}

void cairoStartPath( cairoRenderer* re, float x, float y ) {
 //   cairo_new_sub_path( re->cr );
    cairo_move_to( re->cr, x, y );
    re->x=x; re->y=y;
}

void cairoEndPath( cairoRenderer* re ) {
    cairoPaint( re );
}

void cairoClose( cairoRenderer* re ) {
    cairo_close_path( re->cr );
}

void cairoLineTo( cairoRenderer* re, float x, float y ) {
    cairo_line_to( re->cr, x, y );
    re->x=x; re->y=y;
}

void cairoQuadraticTo( cairoRenderer* re, float x1, float y1, float x, float y ) {
    // TODO: check for correctness
    cairoCubicTo( re, 
        re->x+( (x1-re->x)*2/3), 
        re->y+( (y1-re->y)*2/3),
        x1+( (x-x1)/3), 
        y1+( (y-y1)/3),
        x, y );
}

void cairoCubicTo( cairoRenderer* re, float x1, float y1, float x2, float y2, float x, float y ) {
    cairo_curve_to( re->cr, x1, y1, x2, y2, x, y );
    re->x=x; re->y=y;
}

void cairoRect( cairoRenderer* re, float x, float y, float w, float h ) {
    cairo_rectangle( re->cr, x, y, w, h );
    cairoPaint( re );
}

void cairoCircle( cairoRenderer* re, float x, float y, float radius ) {
    cairo_arc( re->cr, x, y, radius, 0, 2*M_PI );
    cairoPaint( re );
}

void cairoText( cairoRenderer* re, float x, float y, const char *text ) {
    if( re->fill_a > 0 ) {
        cairo_save( re->cr );
            cairo_set_source_rgba( re->cr, re->fill_r, re->fill_g, re->fill_b, re->fill_a );
            cairo_move_to( re->cr, x, y );
        
            char* first=strdup(text);
            char* last=first;
            while( *last != 0 ) {
                last++;
                if( *last == '\n' ) {
                    
                }
            }
            cairo_show_text( re->cr, text );
        cairo_restore( re->cr );
    }
}

void cairoStartNative( cairoRenderer* re, value n ) {
    indent(re->indent);
    printf("StartNative( ");
    val_print(n);
    printf(" )\n");
}

void cairoEndNative( cairoRenderer* re ) {
    indent(re->indent);
    printf("EndNative()\n");
}

