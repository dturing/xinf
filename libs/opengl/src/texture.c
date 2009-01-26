#include "texture.h"
#include <stdlib.h>
#include <string.h>

DEFINE_KIND( k_texture );

GLuint* textureCreate() {
	GLuint* tex = malloc( sizeof(GLuint) );
	glGenTextures( 1, tex );
	return tex;
}

void textureDelete( GLuint *tex ) {
	glDeleteTextures( 1, tex );
	free( tex );
}

void textureBind( GLuint *tex ) {
	glBindTexture( GL_TEXTURE_2D, *tex );
}

void textureInitialize( int format, int width, int height ) {
    glTexImage2D( GL_TEXTURE_2D, 0, format, width, height,
    	0, GL_RGBA, GL_UNSIGNED_BYTE, (unsigned char *)NULL );
}

void textureSubImageRGBA( int x, int y, int w, int h, const unsigned char *data ) {
    glTexSubImage2D( GL_TEXTURE_2D, 0, x, y, w, h,
		GL_RGBA, GL_UNSIGNED_BYTE, (unsigned char *)data );
}

void textureSubImageBGRA( int x, int y, int w, int h, const unsigned char *data ) {
	glTexSubImage2D( GL_TEXTURE_2D, 0, x, y, w, h,
		GL_BGRA, GL_UNSIGNED_BYTE, (unsigned char *)data );
}

void textureSubImageRGB( int x, int y, int w, int h, const unsigned char *data ) {
	glTexSubImage2D( GL_TEXTURE_2D, 0, x, y, w, h,
		GL_RGB, GL_UNSIGNED_BYTE, (unsigned char *)data );
}

void textureSubImageBGR( int x, int y, int w, int h, const unsigned char *data ) {
	val_throw(alloc_string("textureSubImageBGR not implemented"));
}

void textureSubImageGRAY( int x, int y, int w, int h, const unsigned char *data ) {
	glTexSubImage2D( GL_TEXTURE_2D, 0, x, y, w, h,
		GL_LUMINANCE, GL_UNSIGNED_BYTE, (unsigned char *)data );
}

void textureSubImageALPHA( int x, int y, int w, int h, const unsigned char *data ) {
	glTexSubImage2D( GL_TEXTURE_2D, 0, x, y, w, h,
		GL_ALPHA, GL_UNSIGNED_BYTE, (unsigned char *)data );
}

void textureImageClearFT( int w, int h ) {
    unsigned char empty[w*h]; // FIXME. but it should be cleared on creation...
    memset( empty, 0, w*h );
    glTexSubImage2D( GL_TEXTURE_2D, 0, 0, 0, w, h,
        GL_ALPHA, GL_UNSIGNED_BYTE, empty );
}

void textureSubImageFT( int x, int y, int w, int h, const unsigned char *data ) {
    glPushClientAttrib( GL_CLIENT_PIXEL_STORE_BIT);
    glPixelStorei( GL_UNPACK_LSB_FIRST, GL_FALSE);
    glPixelStorei( GL_UNPACK_ROW_LENGTH, 0);
    glPixelStorei( GL_UNPACK_ALIGNMENT, 1);
    
    glTexSubImage2D( GL_TEXTURE_2D, 0, x, y, w, h,
        GL_ALPHA, GL_UNSIGNED_BYTE, (unsigned char *)data );
    
    glPopClientAttrib();    
}

