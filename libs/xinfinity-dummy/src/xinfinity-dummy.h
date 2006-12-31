#ifndef _XINFINITY_dummy_H
#define _XINFINITY_dummy_H

#include <neko/neko.h>

struct _dummyRenderer {
    int indent;
};
typedef struct _dummyRenderer dummyRenderer;

dummyRenderer* dummyCreateRenderer( int w, int h );

void dummyStartObject( dummyRenderer* re, int id );
void dummyEndObject( dummyRenderer* re );
void dummyShowObject( dummyRenderer* re, int id );

void dummySetTransform( dummyRenderer* r, int id, float x, float y, float a, float b, float c, float d );
void dummySetTranslation( dummyRenderer* r, int id, float x, float y );

void dummySetFill( dummyRenderer* re, float r, float g, float b, float a );
void dummySetStroke( dummyRenderer* re, float r, float g, float b, float a, float width );
void dummySetFont( dummyRenderer* re, const char *family, int italic, int bold, float size );

void dummyStartShape( dummyRenderer* re );
void dummyEndShape( dummyRenderer* re );
void dummyStartPath( dummyRenderer* re, float x, float y );
void dummyEndPath( dummyRenderer* re );
void dummyClose( dummyRenderer* re );
void dummyLineTo( dummyRenderer* re, float x, float y );
void dummyQuadraticTo( dummyRenderer* re, float x1, float y1, float x, float y );
void dummyCubicTo( dummyRenderer* re, float x1, float y1, float x2, float y2, float x, float y );

void dummyRect( dummyRenderer* re, float l, float t, float w, float h );
void dummyCircle( dummyRenderer* re, float x, float y, float radius );
void dummyText( dummyRenderer* re, float x, float y, const char *text );

void dummyStartNative( dummyRenderer* re, value n );
void dummyEndNative( dummyRenderer* re );

void dummyNative( dummyRenderer* re, value n );

#endif // _XINFINITY_GL_H
