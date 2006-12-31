#ifndef _XINFINITY_gl0_H
#define _XINFINITY_gl0_H

#include <neko/neko.h>

struct _gl0Renderer {
    int indent;
    
    float fill_r, fill_g, fill_b, fill_a;
    float stroke_r, stroke_g, stroke_b, stroke_a, stroke_width;
};
typedef struct _gl0Renderer gl0Renderer;

gl0Renderer* gl0CreateRenderer( int w, int h );

void gl0StartObject( gl0Renderer* re, int id );
void gl0EndObject( gl0Renderer* re );
void gl0ShowObject( gl0Renderer* re, int id );

void gl0SetTransform( gl0Renderer* r, int id, float x, float y, float a, float b, float c, float d );
void gl0SetTranslation( gl0Renderer* r, int id, float x, float y );

void gl0SetFill( gl0Renderer* re, float r, float g, float b, float a );
void gl0SetStroke( gl0Renderer* re, float r, float g, float b, float a, float width );
void gl0SetFont( gl0Renderer* re, const char *family, int italic, int bold, float size );

void gl0StartShape( gl0Renderer* re );
void gl0EndShape( gl0Renderer* re );
void gl0StartPath( gl0Renderer* re, float x, float y );
void gl0EndPath( gl0Renderer* re );
void gl0Close( gl0Renderer* re );
void gl0LineTo( gl0Renderer* re, float x, float y );
void gl0QuadraticTo( gl0Renderer* re, float x1, float y1, float x, float y );
void gl0CubicTo( gl0Renderer* re, float x1, float y1, float x2, float y2, float x, float y );

void gl0Rect( gl0Renderer* re, float l, float t, float w, float h );
void gl0Circle( gl0Renderer* re, float x, float y, float radius );
void gl0Text( gl0Renderer* re, float x, float y, const char *text );

void gl0StartNative( gl0Renderer* re, value n );
void gl0EndNative( gl0Renderer* re );

void gl0Native( gl0Renderer* re, value n );

#endif // _XINFINITY_GL_H
