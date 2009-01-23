#ifndef TEXTURE_H
#define TEXTURE_H

#include <neko.h>
#include <GL/gl.h>

GLuint* textureCreate();
void textureDelete( GLuint* tex );
void textureBind( GLuint* tex );

void textureSubImageRGBA( int x, int y, int w, int h, const unsigned char *data );
void textureSubImageBGRA( int x, int y, int w, int h, const unsigned char *data );
void textureSubImageRGB( int x, int y, int w, int h, const unsigned char *data );
void textureSubImageBGR( int x, int y, int w, int h, const unsigned char *data );
void textureSubImageGRAY( int x, int y, int w, int h, const unsigned char *data );
void textureSubImageALPHA( int x, int y, int w, int h, const unsigned char *data );
void textureImageClearFT( int w, int h );
void textureSubImageFT( int x, int y, int w, int h, const unsigned char *data );

#endif

