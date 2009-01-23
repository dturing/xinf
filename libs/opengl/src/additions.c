#include "additions.h"

#include <string.h>
#include <stdio.h>
#include <GL/glfw.h>

void glTexSubImageRGBA( int x, int y, int w, int h, const unsigned char *data ) {
    glTexSubImage2D( GL_TEXTURE_2D, 0, x, y, w, h,
        GL_RGBA, GL_UNSIGNED_BYTE, (unsigned char *)data );
}

void glTexSubImageBGRA( int x, int y, int w, int h, const unsigned char *data ) {
//	printf("GL_BGRA is not valid on Windows, thus disabled.\n");
    glTexSubImage2D( GL_TEXTURE_2D, 0, x, y, w, h,
        GL_BGRA, GL_UNSIGNED_BYTE, (unsigned char *)data );
}

void glTexSubImageRGB( int x, int y, int w, int h, const unsigned char *data ) {
       glTexSubImage2D( GL_TEXTURE_2D, 0, x, y, w, h,
        GL_RGB, GL_UNSIGNED_BYTE, (unsigned char *)data );
}

void glTexSubImageBGR( int x, int y, int w, int h, const unsigned char *data ) {
	val_throw(alloc_string("glTexSubImageBGR not implemented"));
//       glTexSubImage2D( GL_TEXTURE_2D, 0, x, y, w, h,
//        GL_BGR, GL_UNSIGNED_BYTE, (unsigned char *)data );
}

void glTexSubImageGRAY( int x, int y, int w, int h, const unsigned char *data ) {
	/*
    glPushClientAttrib( GL_CLIENT_PIXEL_STORE_BIT);
    glPixelStorei( GL_UNPACK_LSB_FIRST, GL_FALSE);
    glPixelStorei( GL_UNPACK_ROW_LENGTH, 0);
    glPixelStorei( GL_UNPACK_ALIGNMENT, 1);
	*/
    glTexSubImage2D( GL_TEXTURE_2D, 0, x, y, w, h,
        GL_LUMINANCE, GL_UNSIGNED_BYTE, (unsigned char *)data );
   // glPopClientAttrib();    
}

void glTexSubImageALPHA( int x, int y, int w, int h, const unsigned char *data ) {
    glTexSubImage2D( GL_TEXTURE_2D, 0, x, y, w, h,
        GL_ALPHA, GL_UNSIGNED_BYTE, (unsigned char *)data );
}

void glTexImageClearFT( int w, int h ) {
/*    glPushClientAttrib( GL_CLIENT_PIXEL_STORE_BIT);
    glPixelStorei( GL_UNPACK_LSB_FIRST, GL_FALSE);
    glPixelStorei( GL_UNPACK_ROW_LENGTH, 0);
    glPixelStorei( GL_UNPACK_ALIGNMENT, 1);
	*/
    unsigned char empty[w*h]; // FIXME. but it should be cleared on creation...
    memset( empty, 0, w*h );
    glTexSubImage2D( GL_TEXTURE_2D, 0, 0, 0, w, h,
        GL_ALPHA, GL_UNSIGNED_BYTE, empty );

//    glPopClientAttrib();
}

void glTexSubImageFT( int x, int y, int w, int h, const unsigned char *data ) {
    glPushClientAttrib( GL_CLIENT_PIXEL_STORE_BIT);
    glPixelStorei( GL_UNPACK_LSB_FIRST, GL_FALSE);
    glPixelStorei( GL_UNPACK_ROW_LENGTH, 0);
    glPixelStorei( GL_UNPACK_ALIGNMENT, 1);
    
    glTexSubImage2D( GL_TEXTURE_2D, 0, x, y, w, h,
        GL_ALPHA, GL_UNSIGNED_BYTE, (unsigned char *)data );
    
    glPopClientAttrib();    
}

/* GLFW helpers */

static field f_x;
static field f_y; 

static field f_WindowSize;
static field f_WindowClose;
static field f_WindowRefresh;
static field f_Key;
static field f_Char;
static field f_MouseButton;
static field f_MousePos;
static field f_MouseWheel;

value *glfwCallbacks = NULL;


void glfw_setup() {
	int i=0;
	glfwCallbacks = alloc_root(1);
	glfwCallbacks[0] = alloc_object(NULL);
	
	f_x = val_id("x");
	f_y = val_id("y");
	
	f_WindowSize = val_id("windowSize");
	f_WindowClose = val_id("windowClose");
	f_WindowRefresh = val_id("windowRefresh");
	f_Key = val_id("key");
	f_Char = val_id("char");
	f_MouseButton = val_id("mouseButton");
	f_MousePos = val_id("mousePos");
	f_MouseWheel = val_id("mouseWheel");
    
	glfwInit();
}
DEFINE_ENTRY_POINT(glfw_setup);

value glfwGetMousePosition() {
	int x,y;
	glfwGetMousePos( &x, &y );
	value r = alloc_object(NULL);
	alloc_field( r, f_x, alloc_int(x) );
	alloc_field( r, f_y, alloc_int(y) );
	return r;
}


value glfw_get_callback( field which ) {
	value callbacks = glfwCallbacks[0];
	if( callbacks == val_null ) return val_null;
	value cb = val_field( callbacks, which );
	return cb;
}

void glfw_set_callback( field which, value cb ) {
	if( !val_is_function(cb) ) val_throw(alloc_string("callback is not a function"));
	alloc_field( glfwCallbacks[0], which, cb );
}


#define GLFW_SET_CALLBACK(func) \
value glfwSet## func ##Function( value f ) { \
	glfw_set_callback( f_## func, f ); \
	glfwSet## func ##Callback( glfw_wrap_## func ); \
}

#define GLFW_WRAP_CALLBACK(func) \
void glfw_wrap_## func() { \
	value callback = glfw_get_callback( f_## func ); \
	if( callback == val_null ) return; \
	val_call0( callback ); \
}

#define GLFW_WRAP_CALLBACK_INT(func) \
void glfw_wrap_## func( int a ) { \
	value callback = glfw_get_callback( f_## func ); \
	if( callback == val_null ) return; \
	val_call1( callback, alloc_int(a) ); \
}

#define GLFW_WRAP_CALLBACK_INT_INT(func) \
void glfw_wrap_## func( int a, int b ) { \
	value callback = glfw_get_callback( f_## func ); \
	if( callback == val_null ) return; \
	val_call2( callback, alloc_int(a), alloc_int(b) ); \
}

#define GLFW_WRAP_CALLBACK_INT_INT_INT(func) \
void glfw_wrap_## func( int a, int b, int c ) { \
	value callback = glfw_get_callback( f_## func ); \
	if( callback == val_null ) return; \
	val_call3( callback, alloc_int(a), alloc_int(b), alloc_int(c) ); \
}

GLFW_WRAP_CALLBACK_INT_INT(WindowSize)
GLFW_SET_CALLBACK(WindowSize)

int glfw_wrap_WindowClose() {
	value callback = glfw_get_callback( f_WindowClose );
	if( callback == val_null ) return;
	return( val_number( val_call0( callback ) ) );
}
GLFW_SET_CALLBACK(WindowClose)

GLFW_WRAP_CALLBACK(WindowRefresh)
GLFW_SET_CALLBACK(WindowRefresh)

GLFW_WRAP_CALLBACK_INT_INT(MouseButton)
GLFW_SET_CALLBACK(MouseButton)

GLFW_WRAP_CALLBACK_INT_INT(MousePos)
GLFW_SET_CALLBACK(MousePos)

GLFW_WRAP_CALLBACK_INT(MouseWheel)
GLFW_SET_CALLBACK(MouseWheel)

GLFW_WRAP_CALLBACK_INT_INT(Key)
GLFW_SET_CALLBACK(Key)

GLFW_WRAP_CALLBACK_INT_INT(Char)
GLFW_SET_CALLBACK(Char)
