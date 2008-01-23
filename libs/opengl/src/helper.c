#include <neko.h>

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
		return array; \
	} \
	return val_null; \
}\
DEFINE_PRIM(opengl_get_## functype,2);

OPENGL_GET(bool,bool,GLboolean,glGetBooleanv)
OPENGL_GET(double,float,GLdouble,glGetDoublev)
OPENGL_GET(float,float,GLfloat,glGetFloatv)
OPENGL_GET(int,int,GLint,glGetIntegerv)
