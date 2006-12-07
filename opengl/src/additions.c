#include "additions.h"

#include <GL/gl.h>

/* FIXME: use proper GL vertex array, not this hacky crap! */
void gluVerticesOffset( int offset, int n, double *v ) {
	double *_v = v+offset;
	int i;
	for( i=0; i<n; i++ ) {
		glVertex3dv( _v );
		_v += 3;
	}
}


value *glutCallbacks = NULL;

void glut_display() {
	value callback = val_field( *glutCallbacks, val_id("display") );
	if( callback == val_null ) return;
	if( !val_is_function(callback) ) val_throw(alloc_string("callbacks.display is not a function"));
	
	val_call0( callback );
}

void glut_timer() {
	value callback = val_field( *glutCallbacks, val_id("timer") );
	if( callback == val_null ) return;
	if( !val_is_function(callback) ) val_throw(alloc_string("callbacks.timer is not a function"));
	
	val_call0( callback );
	glutTimerFunc( 1000/25, glut_timer, 0 );
}

void glutSetupHandlers( value f ) {
	if( glutCallbacks == NULL ) glutCallbacks = alloc_root(1);
	*glutCallbacks = f;

	glutDisplayFunc( glut_display );
	glutTimerFunc( 1000/25, glut_timer, 0 );
}

void glutInitSimple() {
	char *argv[] = { "foo", NULL };
	int argn=1;
	glutInit(&argn,argv);
}
