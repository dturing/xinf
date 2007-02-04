#include "additions.h"

/* FIXME: use proper GL vertex array, not this hacky crap! */
void gluVerticesOffset( int offset, int n, double *v ) {
	double *_v = v+offset;
	int i;
	for( i=0; i<n; i++ ) {
		glVertex3dv( _v );
		_v += 3;
	}
}

void glTexSubImageRGBA( unsigned int tex, int x, int y, int w, int h, const unsigned char *data ) {
    glTexSubImage2D( GL_TEXTURE_2D, 0, x, y, w, h,
        GL_RGBA, GL_UNSIGNED_BYTE, (unsigned char *)data );
}

void glTexSubImageRGB( unsigned int tex, int x, int y, int w, int h, const unsigned char *data ) {
    glTexSubImage2D( GL_TEXTURE_2D, 0, x, y, w, h,
        GL_RGB, GL_UNSIGNED_BYTE, (unsigned char *)data );
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


#define MAX_WINDOWS 32

static field f_Display;
static field f_Reshape;
static field f_Keyboard;
static field f_Special;
static field f_Mouse;
static field f_Motion;
static field f_PassiveMotion;
static field f_Entry;
static field f_Visibility;
static field f_Idle;
static field f_Timer;
static field f_Exit;
value *glutCallbacks = NULL;


void glut_setup() {
	int i=0;
	glutCallbacks = alloc_root(MAX_WINDOWS);
	for( i=0; i<MAX_WINDOWS; i++ ) glutCallbacks[i] = alloc_object(NULL);
		
	f_Display = val_id("display");
	f_Reshape = val_id("reshape");
	f_Keyboard = val_id("keyboard");
	f_Special = val_id("special");
	f_Mouse = val_id("mouse");
	f_Motion = val_id("motion");
	f_PassiveMotion = val_id("passiveMotion");
	f_Entry = val_id("entry");
	f_Visibility = val_id("visibility");
	f_Idle = val_id("idle");
	f_Timer = val_id("timer");
	f_Exit = val_id("exit");
    
    
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

GLUT_WRAP_CALLBACK_INT_INT_INT(Special)
GLUT_SET_CALLBACK(Special)

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
