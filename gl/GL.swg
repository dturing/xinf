%module GL

%{
#include <GL/gl.h>
#include <GL/glu.h>

extern vkind k_cptr_float;

GLuint *_glCreateUintBuffer( int sz ) {   
    GLuint *buf = (GLuint*)malloc( sizeof(GLuint)*sz );
    return( buf );
}

GLint *_glCreateIntBuffer( int sz ) {   
    GLuint *buf = (GLint*)malloc( sizeof(GLint)*sz );
    return( buf );
}

value _glMakeArrayUint( GLuint *buf, int sz ) {
    int i;
    value result = alloc_array( sz );
    value *a = val_array_ptr(result);
    for( i=0; i<sz; i++ ) {
        a[i] = alloc_int( buf[i] );
    }
    return result;
}

%}

%include <GL/gl.h>
%include <GL/glu.h>

GLuint *_glCreateUintBuffer( int sz );
GLint *_glCreateIntBuffer( int sz );
value _glMakeArrayUint( GLuint *buf, int sz );
