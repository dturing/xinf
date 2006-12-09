#include <neko/neko.h>

#include <additions.h>

#include <stdio.h>
#include <stdlib.h>

#define MAX_GET_PARAMS 16

#define OPENGL_GET(functype,nekotype,gltype,glget) \
value opengl_get_## functype( value _pname, value _interest ) {	\
	static gltype buf[MAX_GET_PARAMS];	\
	int i;	\
	\
	val_check(_pname,number);				\
	int pname = val_number(_pname);			\
	val_check(_interest,number);			\
	int interest = val_number(_interest);	\
	\
	if( interest>MAX_GET_PARAMS || interest < 1 ) { \
		val_throw( alloc_string("illegal number of parameters-of-interest") ); \
		return val_null; \
	} \
	\
	glget( pname, buf ); \
	\
	value ret = val_null; \
	if( interest==1 ) { \
		return( alloc_## nekotype( buf[0] ) ); \
	} else { \
		value array = alloc_array(interest ); \
		value *a = val_array_ptr( array ); \
		for( i=0; i<interest; i++ ) { \
			a[i] = alloc_## nekotype( buf[i] ); \
		} \
		printf("glget %i %s %p\n",interest,#functype,array); \
		val_print( array ); \
		return array; \
	} \
	return val_null; \
}\
DEFINE_PRIM(opengl_get_## functype,2);

OPENGL_GET(bool,bool,GLboolean,glGetBooleanv)
OPENGL_GET(double,float,GLdouble,glGetDoublev)
OPENGL_GET(float,float,GLfloat,glGetFloatv)
OPENGL_GET(int,int,GLint,glGetIntegerv)



/* ------------------------------------------------------------- */
/* Evaluate to Callback f( x:Float, y:Float ) */

value gluEvaluateCubicBezier( value _ctrl, value _n, value callback ) {
    unsigned int i;
	val_check( _n, number );
    int n = val_number(_n)-1;
    
    // FIXME: check array, callback
    
    value *ctrl = val_array_ptr( _ctrl );
	double controlPoints[4][2] = {
            { val_number( ctrl[0] ), val_number( ctrl[1] ) },
            { val_number( ctrl[2] ), val_number( ctrl[3] ) },
            { val_number( ctrl[4] ), val_number( ctrl[5] ) },
            { val_number( ctrl[6] ), val_number( ctrl[7] ) }
		};

    double bezierValues[3][2];
    double stepsize = 1.0/n;

	value result = alloc_array( n*2 );
	value *a = val_array_ptr( result );

	for( i = 0; i <= n; i++) {
        double t = ((float)i) * stepsize;
        double t1 = (1.0f - t);
        
        bezierValues[0][0] = t1 * controlPoints[0][0] + t * controlPoints[1][0];
        bezierValues[0][1] = t1 * controlPoints[0][1] + t * controlPoints[1][1];
    
        bezierValues[1][0] = t1 * controlPoints[1][0] + t * controlPoints[2][0];
        bezierValues[1][1] = t1 * controlPoints[1][1] + t * controlPoints[2][1];
        
        bezierValues[2][0] = t1 * controlPoints[2][0] + t * controlPoints[3][0];
        bezierValues[2][1] = t1 * controlPoints[2][1] + t * controlPoints[3][1];
        
        bezierValues[0][0] = t1 * bezierValues[0][0] + t * bezierValues[1][0];
        bezierValues[0][1] = t1 * bezierValues[0][1] + t * bezierValues[1][1];
    
        bezierValues[1][0] = t1 * bezierValues[1][0] + t * bezierValues[2][0];
        bezierValues[1][1] = t1 * bezierValues[1][1] + t * bezierValues[2][1];
        
        bezierValues[0][0] = t1 * bezierValues[0][0] + t * bezierValues[1][0];
        bezierValues[0][1] = t1 * bezierValues[0][1] + t * bezierValues[1][1];
		
		val_call2( callback, alloc_float( bezierValues[0][0] ), alloc_float( bezierValues[0][1] ) );
    }	
	return val_true;
}
DEFINE_PRIM(gluEvaluateCubicBezier,3);

value gluEvaluateQuadraticBezier( value _ctrl, value _n, value callback ) {
    unsigned int i;
	val_check( _n, number );
    int n = val_number(_n)-1;
    
    // FIXME: check array, callback
    
    value *ctrl = val_array_ptr( _ctrl );
	float controlPoints[3][2] = {
            { val_number( ctrl[0] ), val_number( ctrl[1] ) },
            { val_number( ctrl[2] ), val_number( ctrl[3] ) },
            { val_number( ctrl[4] ), val_number( ctrl[5] ) }
		};

    float bezierValues[2][2];
    float stepsize = 1.0/n;

	value result = alloc_array( n*2 );
	value *a = val_array_ptr( result );

	for( i = 0; i <= n; i++) {
        float t = ((float)i) * stepsize;
        float t1 = (1.0f - t);
        
        bezierValues[0][0] = t1 * controlPoints[0][0] + t * controlPoints[1][0];
        bezierValues[0][1] = t1 * controlPoints[0][1] + t * controlPoints[1][1];
    
        bezierValues[1][0] = t1 * controlPoints[1][0] + t * controlPoints[2][0];
        bezierValues[1][1] = t1 * controlPoints[1][1] + t * controlPoints[2][1];
        
        bezierValues[0][0] = t1 * bezierValues[0][0] + t * bezierValues[1][0];
        bezierValues[0][1] = t1 * bezierValues[0][1] + t * bezierValues[1][1];
    
		val_call2( callback, alloc_float( bezierValues[0][0] ), alloc_float( bezierValues[0][1] ) );
    }
	
	return val_true;
}
DEFINE_PRIM(gluEvaluateQuadraticBezier,3);

