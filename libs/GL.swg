%module GL

%include <GL/gl.h>

void glMap1d_01( GLenum target, GLint stride, GLint order, const GLdouble *points );
int _glCreateTexture( unsigned int tex, int width, int height );
void _glTexSubImage2D_BGRA_BYTE( unsigned int tex, value pos, value size, unsigned int *data );

