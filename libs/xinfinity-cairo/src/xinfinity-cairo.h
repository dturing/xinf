#ifndef _XINFINITY_cairo_H
#define _XINFINITY_cairo_H

#include <neko/neko.h>
#include <cairo.h>

struct _cairoRenderer {
    int indent;
    
    cairo_surface_t *surface;
    cairo_t *cr;

    float fill_r, fill_g, fill_b, fill_a;
    float stroke_r, stroke_g, stroke_b, stroke_a, stroke_width;
    
    float x, y;
};
typedef struct _cairoRenderer cairoRenderer;
    
cairoRenderer* cairoCreateRenderer( int w, int h );
void cairoDeleteRenderer( cairoRenderer *re );

void cairoWriteToPNG( cairoRenderer *re, const char *filename );

void cairoStartObject( cairoRenderer* re, int id );
void cairoEndObject( cairoRenderer* re );
void cairoShowObject( cairoRenderer* re, int id );

void cairoSetTransform( cairoRenderer* r, int id, float x, float y, float a, float b, float c, float d );
void cairoSetTranslation( cairoRenderer* r, int id, float x, float y );

void cairoSetFill( cairoRenderer* re, float r, float g, float b, float a );
void cairoSetStroke( cairoRenderer* re, float r, float g, float b, float a, float width );
void cairoSetFont( cairoRenderer* re, const char *family, int italic, int bold, float size );

void cairoStartShape( cairoRenderer* re );
void cairoEndShape( cairoRenderer* re );
void cairoStartPath( cairoRenderer* re, float x, float y );
void cairoEndPath( cairoRenderer* re );
void cairoClose( cairoRenderer* re );
void cairoLineTo( cairoRenderer* re, float x, float y );
void cairoQuadraticTo( cairoRenderer* re, float x1, float y1, float x, float y );
void cairoCubicTo( cairoRenderer* re, float x1, float y1, float x2, float y2, float x, float y );

void cairoRect( cairoRenderer* re, float l, float t, float w, float h );
void cairoCircle( cairoRenderer* re, float x, float y, float radius );
void cairoText( cairoRenderer* re, float x, float y, const char *text );

void cairoStartNative( cairoRenderer* re, value n );
void cairoEndNative( cairoRenderer* re );

void cairoNative( cairoRenderer* re, value n );

#endif // _XINFINITY_GL_H
