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


#define MAX_WINDOWS 32

static field f_Display;
static field f_Timer;
static field f_Reshape;
value *glutCallbacks = NULL;


void glut_setup() {
	int i=0;
	glutCallbacks = alloc_root(MAX_WINDOWS);
	for( i=0; i<MAX_WINDOWS; i++ ) glutCallbacks[i] = alloc_object(NULL);
		
	f_Display = val_id("display");
	f_Timer = val_id("timer");
	f_Reshape = val_id("reshape");
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
value glutSet## func( value f ) { \
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
	val_call1( callback, alloc_float(a) ); \
}


GLUT_WRAP_CALLBACK(Display)
GLUT_SET_CALLBACK(Display)

GLUT_WRAP_CALLBACK_INT(Timer)


value glutSetTimer( int t, value f, int v ) {
	glut_set_callback( f_Timer, f );
	glutTimerFunc( t, glut_wrap_Timer, v );
}

void glut_wrap_Reshape( int w, int h ) {
	value callback = glut_get_callback( f_Reshape );
	if( callback == val_null ) return;
	val_call2( callback, alloc_int(w), alloc_int(h) );
}
GLUT_SET_CALLBACK(Reshape)


void glutInitSimple() {
	char *argv[] = { "", NULL };
	int argn=1;
	glutInit(&argn,argv);
}
