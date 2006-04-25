%module GL

%{
#include <GL/gl.h>
#include <GL/glu.h>
#include <GL/glext.h>

extern vkind k_cptr_float;
extern vkind k_cptr_int;

// FIXME: remove these, replaced by IntPointer class
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

/*  helper for gluErrorString,
    i dont know why my neko swig binding doesnt handle const GLubyte* as string */
value _gluErrorString() {
    return( val_string( gluErrorString(glGetError()) ) );
}


/* texture helper */
value _glCreateTexture( value id, value width, value height ) {
    int i;
    
    VAL_CHECK( id, int );
    VAL_CHECK( width, int );
    VAL_CHECK( height, int );
    
    int w = val_number(width);
    int h = val_number(height);
        
    glBindTexture( GL_TEXTURE_2D, val_number(id) );
    glTexImage2D( GL_TEXTURE_2D, 0, GL_RGBA, w, h, 0, 
        GL_BGRA, GL_UNSIGNED_BYTE, NULL );

    GLenum errCode;
	if((errCode = glGetError()) != GL_NO_ERROR) {
		printf( "OpenGL Error: %s\n", gluErrorString(errCode) );
	}
        
    return val_true;
}

value _glTexSubImage2D( value id, value pos, value size, value data  ) {
    // FIXME: check, cache keys
    int x = val_number( val_field( pos, val_id("x") ) );
    int y = val_number( val_field( pos, val_id("y") ) );
    int w = val_number( val_field( size, val_id("x") ) );
    int h = val_number( val_field( size, val_id("y") ) );

    VAL_CHECK( id, int );
    VAL_CHECK_KIND( data, k_cptr_int );

    GLubyte *d = (GLubyte*)val_data(data);
    
    glBindTexture( GL_TEXTURE_2D, val_number(id) );
    glTexSubImage2D( GL_TEXTURE_2D, 0, x, y, w, h,
        GL_BGRA, GL_UNSIGNED_BYTE, d );

    return val_true;
}



%}

%include <GL/gl.h>
%include <GL/glu.h>
%include <GL/glext.h>

GLuint *_glCreateUintBuffer( int sz );
GLint *_glCreateIntBuffer( int sz );
value _glMakeArrayUint( GLuint *buf, int sz );

value _gluErrorString();
value _glCreateTexture( value id, value width, value height );
value _glTexSubImage2D( value id, value pos, value size, value data  );
