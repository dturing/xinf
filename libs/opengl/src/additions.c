#include "additions.h"

#include <string.h>
#include <stdio.h>

void glTexSubImageRGBA( unsigned int tex, int x, int y, int w, int h, const unsigned char *data ) {
    glTexSubImage2D( GL_TEXTURE_2D, 0, x, y, w, h,
        GL_RGBA, GL_UNSIGNED_BYTE, (unsigned char *)data );
}

void glTexSubImageBGRA( unsigned int tex, int x, int y, int w, int h, const unsigned char *data ) {
	printf("GL_BGRA is not valid on Windows, thus disabled.\n");
	/*
    glTexSubImage2D( GL_TEXTURE_2D, 0, x, y, w, h,
        GL_BGRA, GL_UNSIGNED_BYTE, (unsigned char *)data );
	*/
}

void glTexSubImageRGB( unsigned int tex, int x, int y, int w, int h, const unsigned char *data ) {
       glTexSubImage2D( GL_TEXTURE_2D, 0, x, y, w, h,
        GL_RGB, GL_UNSIGNED_BYTE, (unsigned char *)data );
}

void glTexSubImageBGR( unsigned int tex, int x, int y, int w, int h, const unsigned char *data ) {
	val_throw(alloc_string("glTexSubImageBGR not implemented"));
//       glTexSubImage2D( GL_TEXTURE_2D, 0, x, y, w, h,
//        GL_BGR, GL_UNSIGNED_BYTE, (unsigned char *)data );
}

void glTexSubImageGRAY( unsigned int tex, int x, int y, int w, int h, const unsigned char *data ) {
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

void glTexImageClearFT( unsigned int text, int w, int h ) {
    glPushClientAttrib( GL_CLIENT_PIXEL_STORE_BIT);
    glPixelStorei( GL_UNPACK_LSB_FIRST, GL_FALSE);
    glPixelStorei( GL_UNPACK_ROW_LENGTH, 0);
    glPixelStorei( GL_UNPACK_ALIGNMENT, 1);
	
    unsigned char empty[w*h]; // FIXME. but it should be cleared on creation...
    memset( empty, 0, w*h );
    glTexSubImage2D( GL_TEXTURE_2D, 0, 0, 0, w, h,
        GL_ALPHA, GL_UNSIGNED_BYTE, empty );
}

void glTexSubImageFT( unsigned int tex, int x, int y, int w, int h, const unsigned char *data ) {
    glPushClientAttrib( GL_CLIENT_PIXEL_STORE_BIT);
    glPixelStorei( GL_UNPACK_LSB_FIRST, GL_FALSE);
    glPixelStorei( GL_UNPACK_ROW_LENGTH, 0);
    glPixelStorei( GL_UNPACK_ALIGNMENT, 1);
    
    glTexSubImage2D( GL_TEXTURE_2D, 0, x, y, w, h,
        GL_ALPHA, GL_UNSIGNED_BYTE, (unsigned char *)data );
    
    
    
    glPopClientAttrib();    
}


void glutInitEmpty() {
	int argc = 0;
	char *argv = 0;
	glutInit(&argc,&argv);
}

#define MAX_WINDOWS 32

static field f_Display;
static field f_Reshape;
static field f_Keyboard;
static field f_KeyboardUp;
static field f_Special;
static field f_SpecialUp;
static field f_Mouse;
static field f_Motion;
static field f_PassiveMotion;
static field f_Entry;
static field f_Visibility;
static field f_Idle;
static field f_Timer;
static field f_Exit;
static field f_Idle;
static field f_MouseWheel;
static field f_Close;
static field f_WMClose;
value *glutCallbacks = NULL;


void glut_setup() {
	int i=0;
	glutCallbacks = alloc_root(MAX_WINDOWS);
	for( i=0; i<MAX_WINDOWS; i++ ) glutCallbacks[i] = alloc_object(NULL);
		
	f_Display = val_id("display");
	f_Reshape = val_id("reshape");
	f_Keyboard = val_id("keyboard");
	f_KeyboardUp = val_id("keyboardUp");
	f_Special = val_id("special");
	f_SpecialUp = val_id("specialUp");
	f_Mouse = val_id("mouse");
	f_Motion = val_id("motion");
	f_PassiveMotion = val_id("passiveMotion");
	f_Entry = val_id("entry");
	f_Visibility = val_id("visibility");
	f_Idle = val_id("idle");
	f_Timer = val_id("timer");
	f_Exit = val_id("exit");
	f_Idle = val_id("idle");
	f_MouseWheel = val_id("mouseWheel");
	f_Close = val_id("close");
	f_WMClose = val_id("wmClose");
    
    
	char *argv[] = { "", NULL };
	int argn=1;
	glutInit(&argn,argv);
}
DEFINE_ENTRY_POINT(glut_setup);


int glut_current_window() {
	int window = glutGetWindow();
	if( window<0 || window>MAX_WINDOWS ) 
		val_throw( alloc_string("Illegal GLUT window ID (32 maximum)") );
	return window;
}

value glut_get_callback( field which ) {
	int window = glut_current_window();
	value callbacks = glutCallbacks[window];
	if( callbacks == val_null ) return val_null;
	value cb = val_field( callbacks, which );
	return cb;
}

void glut_set_callback( field which, value cb ) {
	if( !val_is_function(cb) ) val_throw(alloc_string("callback is not a function"));
	int window = glut_current_window();
	if( glutCallbacks[window] == NULL ) {
		glutCallbacks[window] = alloc_object(NULL);
	}
	alloc_field( glutCallbacks[window], which, cb );
}


#define GLUT_SET_CALLBACK(func) \
value glutSet## func ##Func( value f ) { \
	glut_set_callback( f_## func, f ); \
	glut## func ##Func( glut_wrap_## func ); \
}

#define GLUT_WRAP_CALLBACK(func) \
void glut_wrap_## func() { \
	value callback = glut_get_callback( f_## func ); \
	if( callback == val_null ) return; \
	val_call0( callback ); \
}

#define GLUT_WRAP_CALLBACK_INT(func) \
void glut_wrap_## func( int a ) { \
	value callback = glut_get_callback( f_## func ); \
	if( callback == val_null ) return; \
	val_call1( callback, alloc_int(a) ); \
}

#define GLUT_WRAP_CALLBACK_INT_INT(func) \
void glut_wrap_## func( int a, int b ) { \
	value callback = glut_get_callback( f_## func ); \
	if( callback == val_null ) return; \
	val_call2( callback, alloc_int(a), alloc_int(b) ); \
}

#define GLUT_WRAP_CALLBACK_INT_INT_INT(func) \
void glut_wrap_## func( int a, int b, int c ) { \
	value callback = glut_get_callback( f_## func ); \
	if( callback == val_null ) return; \
	val_call3( callback, alloc_int(a), alloc_int(b), alloc_int(c) ); \
}


GLUT_WRAP_CALLBACK(Display)
GLUT_SET_CALLBACK(Display)

GLUT_WRAP_CALLBACK_INT_INT(Reshape)
GLUT_SET_CALLBACK(Reshape)

void glut_wrap_Keyboard( unsigned char key, int x, int y ) { \
	value callback = glut_get_callback( f_Keyboard ); 
	if( callback == val_null ) return; 
	val_call3( callback, alloc_int(key), alloc_int(x), alloc_int(y) ); 
}
GLUT_SET_CALLBACK(Keyboard)

void glut_wrap_KeyboardUp( unsigned char key, int x, int y ) { \
	value callback = glut_get_callback( f_KeyboardUp ); 
	if( callback == val_null ) return; 
	val_call3( callback, alloc_int(key), alloc_int(x), alloc_int(y) ); 
}
GLUT_SET_CALLBACK(KeyboardUp)

GLUT_WRAP_CALLBACK_INT_INT_INT(Special)
GLUT_SET_CALLBACK(Special)

GLUT_WRAP_CALLBACK_INT_INT_INT(SpecialUp)
GLUT_SET_CALLBACK(SpecialUp)

void glut_wrap_Mouse( int button, int state, int x, int y ) { 
	value callback = glut_get_callback( f_Mouse ); 
	if( callback == val_null ) return; 
	value args[4] = { alloc_int(button), alloc_int(state), alloc_int(x), alloc_int(y) };
	val_callN( callback, args, 4 ); 
}
GLUT_SET_CALLBACK(Mouse)

GLUT_WRAP_CALLBACK_INT_INT(Motion)
GLUT_SET_CALLBACK(Motion)

GLUT_WRAP_CALLBACK_INT_INT(PassiveMotion)
GLUT_SET_CALLBACK(PassiveMotion)

GLUT_WRAP_CALLBACK_INT(Entry)
GLUT_SET_CALLBACK(Entry)

GLUT_WRAP_CALLBACK_INT(Visibility)
GLUT_SET_CALLBACK(Visibility)

GLUT_WRAP_CALLBACK_INT(Timer)
value glutSetTimerFunc( int t, value f, int v ) {
	glut_set_callback( f_Timer, f );
	glutTimerFunc( t, glut_wrap_Timer, v );
}


GLUT_WRAP_CALLBACK(Exit)
value glutSetExitFunc( value f ) {
	glut_set_callback( f_Exit, f );
	atexit( glut_wrap_Exit );
}

GLUT_WRAP_CALLBACK(Idle)
GLUT_SET_CALLBACK(Idle)


void glut_wrap_MouseWheel( int wheel, int direction, int x, int y ) { 
	value callback = glut_get_callback( f_MouseWheel ); 
	if( callback == val_null ) return; 
	value args[4] = { alloc_int(wheel), alloc_int(direction), alloc_int(x), alloc_int(y) };
	val_callN( callback, args, 4 ); 
}
GLUT_SET_CALLBACK(MouseWheel)

GLUT_WRAP_CALLBACK(Close)
GLUT_SET_CALLBACK(Close)

GLUT_WRAP_CALLBACK(WMClose)
GLUT_SET_CALLBACK(WMClose)
