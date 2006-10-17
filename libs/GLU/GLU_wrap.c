/* this file is generated with nekobind. do not modify it direcly. */

#define HEADER_IMPORTS
#include <neko.h>
#include "cptr.h"

/***********************************************************************

   xinf is not flash.
   Copyright (c) 2006, Daniel Fischer.
 
   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.
																			
   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU		
   Lesser General Public License or the LICENSE file for more details.
   
***********************************************************************/

#include <GL/gl.h>
#include <GL/glu.h>

/* ------------------------------------------------------------- */
/* simple GLU tesselator, outputs the tesselation using glVertex */
/* ------------------------------------------------------------- */

void simple_tess_combine( GLdouble c[3], void *d[4], GLfloat w[4], void **out ) {
    GLdouble *nv = (GLdouble*)malloc(sizeof(GLdouble)*3);
    nv[0] = c[0];
    nv[1] = c[1];
    nv[2] = c[2];
    *out = nv;
}

void simple_tess_error( GLenum err ) {
    val_throw( alloc_string( "tesselation error" ) );
}

GLUtesselator *gluSimpleTesselator( void ) {
    GLUtesselator *tess = gluNewTess();
    gluTessCallback( tess, GLU_TESS_BEGIN, (_GLUfuncptr)glBegin );
    gluTessCallback( tess, GLU_TESS_VERTEX, (_GLUfuncptr)glVertex3dv );
    gluTessCallback( tess, GLU_TESS_END, (_GLUfuncptr)glEnd );
    gluTessCallback( tess, GLU_TESS_COMBINE, (_GLUfuncptr)simple_tess_combine );
    gluTessCallback( tess, GLU_TESS_ERROR, (_GLUfuncptr)simple_tess_error );
    return tess;
}

void gluTessVertexSimple( GLUtesselator *tess, double *v ) {
    gluTessVertex( tess, v, (void*)v );
}

void gluTessVertexOffset( GLUtesselator *tess, double *v, int offset ) {
	double *_v = v+offset;
    gluTessVertex( tess, _v, (void*)_v );
}

/* FIXME: use proper GL vertex array, not this hacky crap! */
void gluVerticesOffset( double *v, int offset, int n ) {
	double *_v = v+offset;
	int i;
	for( i=0; i<n; i++ ) {
		glVertex3dv( _v );
		_v += 3;
	}
}

void gluTessCubicCurve( GLUtesselator *tess, value _ctrl, double *v, int _n ) {
    unsigned int i;
    int n = _n-1;
    
    // FIXME: check array
    
    value *ctrl = val_array_ptr( _ctrl );
	float controlPoints[4][2] = {
            { val_number( ctrl[0] ), val_number( ctrl[1] ) },
            { val_number( ctrl[2] ), val_number( ctrl[3] ) },
            { val_number( ctrl[4] ), val_number( ctrl[5] ) },
            { val_number( ctrl[6] ), val_number( ctrl[7] ) }
		};

    double bezierValues[3][2];
    double stepsize = 1.0/n;

	for( i = 0; i <= n; i++) {
        float t = ((float)i) * stepsize;
        float t1 = (1.0f - t);

        double *_v = &v[(i*3)];
        
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
        _v[0] = bezierValues[0][0];
        _v[1] = bezierValues[0][1];
        _v[2] = .0;
        
        gluTessVertex( tess, _v, (void*)_v );
    }	
}

void gluTessQuadraticCurve( GLUtesselator *tess, value _ctrl, double *v, int _n ) {
    unsigned int i;
    int n = _n-1;
    
    // FIXME: check array
    
    value *ctrl = val_array_ptr( _ctrl );
	float controlPoints[3][2] = {
            { val_number( ctrl[0] ), val_number( ctrl[1] ) },
            { val_number( ctrl[2] ), val_number( ctrl[3] ) },
            { val_number( ctrl[4] ), val_number( ctrl[5] ) }
		};

    float bezierValues[2][2];
    float stepsize = 1.0/n;

	for( i = 0; i <= n; i++) {
        float t = ((float)i) * stepsize;
        float t1 = (1.0f - t);

        double *_v = &v[(i*3)];
        
        bezierValues[0][0] = t1 * controlPoints[0][0] + t * controlPoints[1][0];
        bezierValues[0][1] = t1 * controlPoints[0][1] + t * controlPoints[1][1];
    
        bezierValues[1][0] = t1 * controlPoints[1][0] + t * controlPoints[2][0];
        bezierValues[1][1] = t1 * controlPoints[1][1] + t * controlPoints[2][1];
        
        bezierValues[0][0] = t1 * bezierValues[0][0] + t * bezierValues[1][0];
        bezierValues[0][1] = t1 * bezierValues[0][1] + t * bezierValues[1][1];
    
        _v[0] = bezierValues[0][0];
        _v[1] = bezierValues[0][1];
        _v[2] = .0;
        
        gluTessVertex( tess, _v, (void*)_v );
    }	
}


/* ------------------------------------------------------------- */
/* Tesselate Array ( [x1,y1,x2,y2,...,xn,yn] */
/* ------------------------------------------------------------- */
/*
void gluTesselatePath( GLUtesselator *tess, value _points ) {
	int i, _c, _p;
	
	if( tess == NULL ) {
		tess = gluNewTess();
		gluTessCallback( tess, GLU_TESS_BEGIN, (_GLUfuncptr)glBegin );
		gluTessCallback( tess, GLU_TESS_VERTEX, (_GLUfuncptr)glVertex3dv );
		gluTessCallback( tess, GLU_TESS_END, (_GLUfuncptr)glEnd );
		gluTessCallback( tess, GLU_TESS_COMBINE, (_GLUfuncptr)simple_tess_combine );
		gluTessCallback( tess, GLU_TESS_ERROR, (_GLUfuncptr)simple_tess_error );
	}


	// FIXME: check array
	
	value *p = val_array_ptr( _points );
	int n = val_array_size( _points )/2;

	GLdouble *coords = (GLdouble*)malloc( sizeof(GLdouble)*n*3 );
	
	_c = 0;
	_p = 0;
	for( i=0; i<n; i++ ) {
		coords[_c++] = val_number(p[_p]);
		coords[_c++] = val_number(p[_p+1]);
		coords[_c++] = 0.0;
		_p+=2;
	}

	for( i=0; i<n; i++ ) {
		printf("tess vertex: %f,%f,%f\n", coords[i*3], coords[(i*3)+1], coords[(i*3)+2] );
        gluTessVertex( tess, &coords[i*3], (void*)&coords[i*3] );
	}
	
	//free( coords ); // might be used after, for complex polygons?

	printf("tess'd %i vertices\n", n );
}
*/

/* ------------------------------------------------------------- */
/* Evaluate to Array ( [x1,y1,x2,y2,...,xn,yn] */

value gluEvaluateCubicToArray( value _ctrl, int _n ) {
    unsigned int i;
    int n = _n-1;
    
    // FIXME: check array
    
    value *ctrl = val_array_ptr( _ctrl );
	float controlPoints[4][2] = {
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
        float t = ((float)i) * stepsize;
        float t1 = (1.0f - t);
        
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
		
        a[i*2] = alloc_float( bezierValues[0][0] );
        a[(i*2)+1] = alloc_float( bezierValues[0][1] );
    }	
	
	return result;
}

value gluEvaluateQuadraticToArray( value _ctrl, int _n ) {
    unsigned int i;
    int n = _n-1;
    
    // FIXME: check array
    
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
    
        a[i*2] = alloc_float( bezierValues[0][0] );
        a[(i*2)+1] = alloc_float( bezierValues[0][1] );
    }
	
	return result;
}

/* ------------------------------------------------------------- */
/* Evaluate to Callback f( x:Float, y:Float ) */

value gluEvaluateCubicBezier( value _ctrl, int _n, value callback ) {
    unsigned int i;
    int n = _n-1;
    
    // FIXME: check array
    
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

value gluEvaluateQuadraticBezier( value _ctrl, int _n, value callback ) {
    unsigned int i;
    int n = _n-1;
    
    // FIXME: check array
    
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
DEFINE_KIND(k_struct_GLUnurbs_p);
DEFINE_KIND(k_struct_GLUnurbs_p_p);
DEFINE_KIND(k_struct_GLUtesselator_p);
DEFINE_KIND(k_struct_GLUtesselator_p_p);
DEFINE_KIND(k_struct_GLUquadric_p);
DEFINE_KIND(k_struct_GLUquadric_p_p);


value neko_gluBeginCurve( value v_nurb ) {
	CHECK_KIND( v_nurb, k_struct_GLUnurbs_p );
	struct GLUnurbs* c_nurb = VAL_KIND( v_nurb, k_struct_GLUnurbs_p );
	gluBeginCurve(c_nurb);
	return val_true;
}
DEFINE_PRIM(neko_gluBeginCurve,1);

value neko_gluBeginPolygon( value v_tess ) {
	CHECK_KIND( v_tess, k_struct_GLUtesselator_p );
	struct GLUtesselator* c_tess = VAL_KIND( v_tess, k_struct_GLUtesselator_p );
	gluBeginPolygon(c_tess);
	return val_true;
}
DEFINE_PRIM(neko_gluBeginPolygon,1);

value neko_gluBeginSurface( value v_nurb ) {
	CHECK_KIND( v_nurb, k_struct_GLUnurbs_p );
	struct GLUnurbs* c_nurb = VAL_KIND( v_nurb, k_struct_GLUnurbs_p );
	gluBeginSurface(c_nurb);
	return val_true;
}
DEFINE_PRIM(neko_gluBeginSurface,1);

value neko_gluBeginTrim( value v_nurb ) {
	CHECK_KIND( v_nurb, k_struct_GLUnurbs_p );
	struct GLUnurbs* c_nurb = VAL_KIND( v_nurb, k_struct_GLUnurbs_p );
	gluBeginTrim(c_nurb);
	return val_true;
}
DEFINE_PRIM(neko_gluBeginTrim,1);

value neko_gluBuild1DMipmapLevels( value v_target, value v_internalFormat, value v_width, value v_format, value v_type, value v_level, value v_base, value v_max, value v_data ) {
	CHECK_Int( v_target );
	CHECK_Int( v_internalFormat );
	CHECK_Int( v_width );
	CHECK_Int( v_format );
	CHECK_Int( v_type );
	CHECK_Int( v_level );
	CHECK_Int( v_base );
	CHECK_Int( v_max );
	CHECK_CPTR( v_data );
	unsigned int c_target = VAL_Int( v_target );
	int c_internalFormat = VAL_Int( v_internalFormat );
	int c_width = VAL_Int( v_width );
	unsigned int c_format = VAL_Int( v_format );
	unsigned int c_type = VAL_Int( v_type );
	int c_level = VAL_Int( v_level );
	int c_base = VAL_Int( v_base );
	int c_max = VAL_Int( v_max );
	void* c_data = CPTR_PTR( v_data, void );
	int c_result = gluBuild1DMipmapLevels(c_target,c_internalFormat,c_width,c_format,c_type,c_level,c_base,c_max,c_data);
	return ALLOC_Int( c_result );
}
DEFINE_PRIM(neko_gluBuild1DMipmapLevels,9);

value neko_gluBuild1DMipmaps( value v_target, value v_internalFormat, value v_width, value v_format, value v_type, value v_data ) {
	CHECK_Int( v_target );
	CHECK_Int( v_internalFormat );
	CHECK_Int( v_width );
	CHECK_Int( v_format );
	CHECK_Int( v_type );
	CHECK_CPTR( v_data );
	unsigned int c_target = VAL_Int( v_target );
	int c_internalFormat = VAL_Int( v_internalFormat );
	int c_width = VAL_Int( v_width );
	unsigned int c_format = VAL_Int( v_format );
	unsigned int c_type = VAL_Int( v_type );
	void* c_data = CPTR_PTR( v_data, void );
	int c_result = gluBuild1DMipmaps(c_target,c_internalFormat,c_width,c_format,c_type,c_data);
	return ALLOC_Int( c_result );
}
DEFINE_PRIM(neko_gluBuild1DMipmaps,6);

value neko_gluBuild2DMipmapLevels( value v_target, value v_internalFormat, value v_width, value v_height, value v_format, value v_type, value v_level, value v_base, value v_max, value v_data ) {
	CHECK_Int( v_target );
	CHECK_Int( v_internalFormat );
	CHECK_Int( v_width );
	CHECK_Int( v_height );
	CHECK_Int( v_format );
	CHECK_Int( v_type );
	CHECK_Int( v_level );
	CHECK_Int( v_base );
	CHECK_Int( v_max );
	CHECK_CPTR( v_data );
	unsigned int c_target = VAL_Int( v_target );
	int c_internalFormat = VAL_Int( v_internalFormat );
	int c_width = VAL_Int( v_width );
	int c_height = VAL_Int( v_height );
	unsigned int c_format = VAL_Int( v_format );
	unsigned int c_type = VAL_Int( v_type );
	int c_level = VAL_Int( v_level );
	int c_base = VAL_Int( v_base );
	int c_max = VAL_Int( v_max );
	void* c_data = CPTR_PTR( v_data, void );
	int c_result = gluBuild2DMipmapLevels(c_target,c_internalFormat,c_width,c_height,c_format,c_type,c_level,c_base,c_max,c_data);
	return ALLOC_Int( c_result );
}
DEFINE_PRIM(neko_gluBuild2DMipmapLevels,10);

value neko_gluBuild2DMipmaps( value v_target, value v_internalFormat, value v_width, value v_height, value v_format, value v_type, value v_data ) {
	CHECK_Int( v_target );
	CHECK_Int( v_internalFormat );
	CHECK_Int( v_width );
	CHECK_Int( v_height );
	CHECK_Int( v_format );
	CHECK_Int( v_type );
	CHECK_CPTR( v_data );
	unsigned int c_target = VAL_Int( v_target );
	int c_internalFormat = VAL_Int( v_internalFormat );
	int c_width = VAL_Int( v_width );
	int c_height = VAL_Int( v_height );
	unsigned int c_format = VAL_Int( v_format );
	unsigned int c_type = VAL_Int( v_type );
	void* c_data = CPTR_PTR( v_data, void );
	int c_result = gluBuild2DMipmaps(c_target,c_internalFormat,c_width,c_height,c_format,c_type,c_data);
	return ALLOC_Int( c_result );
}
DEFINE_PRIM(neko_gluBuild2DMipmaps,7);

value neko_gluBuild3DMipmapLevels( value v_target, value v_internalFormat, value v_width, value v_height, value v_depth, value v_format, value v_type, value v_level, value v_base, value v_max, value v_data ) {
	CHECK_Int( v_target );
	CHECK_Int( v_internalFormat );
	CHECK_Int( v_width );
	CHECK_Int( v_height );
	CHECK_Int( v_depth );
	CHECK_Int( v_format );
	CHECK_Int( v_type );
	CHECK_Int( v_level );
	CHECK_Int( v_base );
	CHECK_Int( v_max );
	CHECK_CPTR( v_data );
	unsigned int c_target = VAL_Int( v_target );
	int c_internalFormat = VAL_Int( v_internalFormat );
	int c_width = VAL_Int( v_width );
	int c_height = VAL_Int( v_height );
	int c_depth = VAL_Int( v_depth );
	unsigned int c_format = VAL_Int( v_format );
	unsigned int c_type = VAL_Int( v_type );
	int c_level = VAL_Int( v_level );
	int c_base = VAL_Int( v_base );
	int c_max = VAL_Int( v_max );
	void* c_data = CPTR_PTR( v_data, void );
	int c_result = gluBuild3DMipmapLevels(c_target,c_internalFormat,c_width,c_height,c_depth,c_format,c_type,c_level,c_base,c_max,c_data);
	return ALLOC_Int( c_result );
}
DEFINE_PRIM(neko_gluBuild3DMipmapLevels,11);

value neko_gluBuild3DMipmaps( value v_target, value v_internalFormat, value v_width, value v_height, value v_depth, value v_format, value v_type, value v_data ) {
	CHECK_Int( v_target );
	CHECK_Int( v_internalFormat );
	CHECK_Int( v_width );
	CHECK_Int( v_height );
	CHECK_Int( v_depth );
	CHECK_Int( v_format );
	CHECK_Int( v_type );
	CHECK_CPTR( v_data );
	unsigned int c_target = VAL_Int( v_target );
	int c_internalFormat = VAL_Int( v_internalFormat );
	int c_width = VAL_Int( v_width );
	int c_height = VAL_Int( v_height );
	int c_depth = VAL_Int( v_depth );
	unsigned int c_format = VAL_Int( v_format );
	unsigned int c_type = VAL_Int( v_type );
	void* c_data = CPTR_PTR( v_data, void );
	int c_result = gluBuild3DMipmaps(c_target,c_internalFormat,c_width,c_height,c_depth,c_format,c_type,c_data);
	return ALLOC_Int( c_result );
}
DEFINE_PRIM(neko_gluBuild3DMipmaps,8);

value neko_gluCheckExtension( value v_extName, value v_extString ) {
	CHECK_String( v_extName );
	CHECK_String( v_extString );
	const unsigned char* c_extName = VAL_String( v_extName );
	const unsigned char* c_extString = VAL_String( v_extString );
	unsigned char c_result = gluCheckExtension(c_extName,c_extString);
	return ALLOC_Int( c_result );
}
DEFINE_PRIM(neko_gluCheckExtension,2);

value neko_gluCylinder( value v_quad, value v_base, value v_top, value v_height, value v_slices, value v_stacks ) {
	CHECK_KIND( v_quad, k_struct_GLUquadric_p );
	CHECK_Float( v_base );
	CHECK_Float( v_top );
	CHECK_Float( v_height );
	CHECK_Int( v_slices );
	CHECK_Int( v_stacks );
	struct GLUquadric* c_quad = VAL_KIND( v_quad, k_struct_GLUquadric_p );
	double c_base = VAL_Float( v_base );
	double c_top = VAL_Float( v_top );
	double c_height = VAL_Float( v_height );
	int c_slices = VAL_Int( v_slices );
	int c_stacks = VAL_Int( v_stacks );
	gluCylinder(c_quad,c_base,c_top,c_height,c_slices,c_stacks);
	return val_true;
}
DEFINE_PRIM(neko_gluCylinder,6);

value neko_gluDeleteNurbsRenderer( value v_nurb ) {
	CHECK_KIND( v_nurb, k_struct_GLUnurbs_p );
	struct GLUnurbs* c_nurb = VAL_KIND( v_nurb, k_struct_GLUnurbs_p );
	gluDeleteNurbsRenderer(c_nurb);
	return val_true;
}
DEFINE_PRIM(neko_gluDeleteNurbsRenderer,1);

value neko_gluDeleteQuadric( value v_quad ) {
	CHECK_KIND( v_quad, k_struct_GLUquadric_p );
	struct GLUquadric* c_quad = VAL_KIND( v_quad, k_struct_GLUquadric_p );
	gluDeleteQuadric(c_quad);
	return val_true;
}
DEFINE_PRIM(neko_gluDeleteQuadric,1);

value neko_gluDeleteTess( value v_tess ) {
	CHECK_KIND( v_tess, k_struct_GLUtesselator_p );
	struct GLUtesselator* c_tess = VAL_KIND( v_tess, k_struct_GLUtesselator_p );
	gluDeleteTess(c_tess);
	return val_true;
}
DEFINE_PRIM(neko_gluDeleteTess,1);

value neko_gluDisk( value v_quad, value v_inner, value v_outer, value v_slices, value v_loops ) {
	CHECK_KIND( v_quad, k_struct_GLUquadric_p );
	CHECK_Float( v_inner );
	CHECK_Float( v_outer );
	CHECK_Int( v_slices );
	CHECK_Int( v_loops );
	struct GLUquadric* c_quad = VAL_KIND( v_quad, k_struct_GLUquadric_p );
	double c_inner = VAL_Float( v_inner );
	double c_outer = VAL_Float( v_outer );
	int c_slices = VAL_Int( v_slices );
	int c_loops = VAL_Int( v_loops );
	gluDisk(c_quad,c_inner,c_outer,c_slices,c_loops);
	return val_true;
}
DEFINE_PRIM(neko_gluDisk,5);

value neko_gluEndCurve( value v_nurb ) {
	CHECK_KIND( v_nurb, k_struct_GLUnurbs_p );
	struct GLUnurbs* c_nurb = VAL_KIND( v_nurb, k_struct_GLUnurbs_p );
	gluEndCurve(c_nurb);
	return val_true;
}
DEFINE_PRIM(neko_gluEndCurve,1);

value neko_gluEndPolygon( value v_tess ) {
	CHECK_KIND( v_tess, k_struct_GLUtesselator_p );
	struct GLUtesselator* c_tess = VAL_KIND( v_tess, k_struct_GLUtesselator_p );
	gluEndPolygon(c_tess);
	return val_true;
}
DEFINE_PRIM(neko_gluEndPolygon,1);

value neko_gluEndSurface( value v_nurb ) {
	CHECK_KIND( v_nurb, k_struct_GLUnurbs_p );
	struct GLUnurbs* c_nurb = VAL_KIND( v_nurb, k_struct_GLUnurbs_p );
	gluEndSurface(c_nurb);
	return val_true;
}
DEFINE_PRIM(neko_gluEndSurface,1);

value neko_gluEndTrim( value v_nurb ) {
	CHECK_KIND( v_nurb, k_struct_GLUnurbs_p );
	struct GLUnurbs* c_nurb = VAL_KIND( v_nurb, k_struct_GLUnurbs_p );
	gluEndTrim(c_nurb);
	return val_true;
}
DEFINE_PRIM(neko_gluEndTrim,1);

value neko_gluErrorString( value v_error ) {
	CHECK_Int( v_error );
	unsigned int c_error = VAL_Int( v_error );
	const unsigned char* c_result = gluErrorString(c_error);
	return ALLOC_String( c_result );
}
DEFINE_PRIM(neko_gluErrorString,1);

value neko_gluGetNurbsProperty( value v_nurb, value v_property, value v_data ) {
	CHECK_KIND( v_nurb, k_struct_GLUnurbs_p );
	CHECK_Int( v_property );
	CHECK_CPTR( v_data );
	struct GLUnurbs* c_nurb = VAL_KIND( v_nurb, k_struct_GLUnurbs_p );
	unsigned int c_property = VAL_Int( v_property );
	float* c_data = CPTR_PTR( v_data, float );
	gluGetNurbsProperty(c_nurb,c_property,c_data);
	return val_true;
}
DEFINE_PRIM(neko_gluGetNurbsProperty,3);

value neko_gluGetString( value v_name ) {
	CHECK_Int( v_name );
	unsigned int c_name = VAL_Int( v_name );
	const unsigned char* c_result = gluGetString(c_name);
	return ALLOC_String( c_result );
}
DEFINE_PRIM(neko_gluGetString,1);

value neko_gluGetTessProperty( value v_tess, value v_which, value v_data ) {
	CHECK_KIND( v_tess, k_struct_GLUtesselator_p );
	CHECK_Int( v_which );
	CHECK_CPTR( v_data );
	struct GLUtesselator* c_tess = VAL_KIND( v_tess, k_struct_GLUtesselator_p );
	unsigned int c_which = VAL_Int( v_which );
	double* c_data = CPTR_PTR( v_data, double );
	gluGetTessProperty(c_tess,c_which,c_data);
	return val_true;
}
DEFINE_PRIM(neko_gluGetTessProperty,3);

value neko_gluLoadSamplingMatrices( value v_nurb, value v_model, value v_perspective, value v_view ) {
	CHECK_KIND( v_nurb, k_struct_GLUnurbs_p );
	CHECK_CPTR( v_model );
	CHECK_CPTR( v_perspective );
	CHECK_CPTR( v_view );
	struct GLUnurbs* c_nurb = VAL_KIND( v_nurb, k_struct_GLUnurbs_p );
	float* c_model = CPTR_PTR( v_model, float );
	float* c_perspective = CPTR_PTR( v_perspective, float );
	int* c_view = CPTR_PTR( v_view, int );
	gluLoadSamplingMatrices(c_nurb,c_model,c_perspective,c_view);
	return val_true;
}
DEFINE_PRIM(neko_gluLoadSamplingMatrices,4);

value neko_gluLookAt( value v_eyeX, value v_eyeY, value v_eyeZ, value v_centerX, value v_centerY, value v_centerZ, value v_upX, value v_upY, value v_upZ ) {
	CHECK_Float( v_eyeX );
	CHECK_Float( v_eyeY );
	CHECK_Float( v_eyeZ );
	CHECK_Float( v_centerX );
	CHECK_Float( v_centerY );
	CHECK_Float( v_centerZ );
	CHECK_Float( v_upX );
	CHECK_Float( v_upY );
	CHECK_Float( v_upZ );
	double c_eyeX = VAL_Float( v_eyeX );
	double c_eyeY = VAL_Float( v_eyeY );
	double c_eyeZ = VAL_Float( v_eyeZ );
	double c_centerX = VAL_Float( v_centerX );
	double c_centerY = VAL_Float( v_centerY );
	double c_centerZ = VAL_Float( v_centerZ );
	double c_upX = VAL_Float( v_upX );
	double c_upY = VAL_Float( v_upY );
	double c_upZ = VAL_Float( v_upZ );
	gluLookAt(c_eyeX,c_eyeY,c_eyeZ,c_centerX,c_centerY,c_centerZ,c_upX,c_upY,c_upZ);
	return val_true;
}
DEFINE_PRIM(neko_gluLookAt,9);

value neko_gluNewNurbsRenderer( ) {
	struct GLUnurbs* c_result = gluNewNurbsRenderer();
	return ALLOC_KIND( c_result, k_struct_GLUnurbs_p );
}
DEFINE_PRIM(neko_gluNewNurbsRenderer,0);

value neko_gluNewQuadric( ) {
	struct GLUquadric* c_result = gluNewQuadric();
	return ALLOC_KIND( c_result, k_struct_GLUquadric_p );
}
DEFINE_PRIM(neko_gluNewQuadric,0);

value neko_gluNewTess( ) {
	struct GLUtesselator* c_result = gluNewTess();
	return ALLOC_KIND( c_result, k_struct_GLUtesselator_p );
}
DEFINE_PRIM(neko_gluNewTess,0);

value neko_gluNextContour( value v_tess, value v_type ) {
	CHECK_KIND( v_tess, k_struct_GLUtesselator_p );
	CHECK_Int( v_type );
	struct GLUtesselator* c_tess = VAL_KIND( v_tess, k_struct_GLUtesselator_p );
	unsigned int c_type = VAL_Int( v_type );
	gluNextContour(c_tess,c_type);
	return val_true;
}
DEFINE_PRIM(neko_gluNextContour,2);

value neko_gluNurbsCallback( value v_nurb, value v_which, value v_CallBackFunc ) {
	CHECK_KIND( v_nurb, k_struct_GLUnurbs_p );
	CHECK_Int( v_which );
	CHECK_Dynamic( v_CallBackFunc );
	struct GLUnurbs* c_nurb = VAL_KIND( v_nurb, k_struct_GLUnurbs_p );
	unsigned int c_which = VAL_Int( v_which );
	_GLUfuncptr c_CallBackFunc = VAL_Dynamic( v_CallBackFunc );
	gluNurbsCallback(c_nurb,c_which,c_CallBackFunc);
	return val_true;
}
DEFINE_PRIM(neko_gluNurbsCallback,3);

value neko_gluNurbsCallbackData( value v_nurb, value v_userData ) {
	CHECK_KIND( v_nurb, k_struct_GLUnurbs_p );
	CHECK_CPTR( v_userData );
	struct GLUnurbs* c_nurb = VAL_KIND( v_nurb, k_struct_GLUnurbs_p );
	void* c_userData = CPTR_PTR( v_userData, void );
	gluNurbsCallbackData(c_nurb,c_userData);
	return val_true;
}
DEFINE_PRIM(neko_gluNurbsCallbackData,2);

value neko_gluNurbsCallbackDataEXT( value v_nurb, value v_userData ) {
	CHECK_KIND( v_nurb, k_struct_GLUnurbs_p );
	CHECK_CPTR( v_userData );
	struct GLUnurbs* c_nurb = VAL_KIND( v_nurb, k_struct_GLUnurbs_p );
	void* c_userData = CPTR_PTR( v_userData, void );
	gluNurbsCallbackDataEXT(c_nurb,c_userData);
	return val_true;
}
DEFINE_PRIM(neko_gluNurbsCallbackDataEXT,2);

value neko_gluNurbsCurve( value v_nurb, value v_knotCount, value v_knots, value v_stride, value v_control, value v_order, value v_type ) {
	CHECK_KIND( v_nurb, k_struct_GLUnurbs_p );
	CHECK_Int( v_knotCount );
	CHECK_CPTR( v_knots );
	CHECK_Int( v_stride );
	CHECK_CPTR( v_control );
	CHECK_Int( v_order );
	CHECK_Int( v_type );
	struct GLUnurbs* c_nurb = VAL_KIND( v_nurb, k_struct_GLUnurbs_p );
	int c_knotCount = VAL_Int( v_knotCount );
	float* c_knots = CPTR_PTR( v_knots, float );
	int c_stride = VAL_Int( v_stride );
	float* c_control = CPTR_PTR( v_control, float );
	int c_order = VAL_Int( v_order );
	unsigned int c_type = VAL_Int( v_type );
	gluNurbsCurve(c_nurb,c_knotCount,c_knots,c_stride,c_control,c_order,c_type);
	return val_true;
}
DEFINE_PRIM(neko_gluNurbsCurve,7);

value neko_gluNurbsProperty( value v_nurb, value v_property, value v_value ) {
	CHECK_KIND( v_nurb, k_struct_GLUnurbs_p );
	CHECK_Int( v_property );
	CHECK_Float( v_value );
	struct GLUnurbs* c_nurb = VAL_KIND( v_nurb, k_struct_GLUnurbs_p );
	unsigned int c_property = VAL_Int( v_property );
	float c_value = VAL_Float( v_value );
	gluNurbsProperty(c_nurb,c_property,c_value);
	return val_true;
}
DEFINE_PRIM(neko_gluNurbsProperty,3);

value neko_gluNurbsSurface( value v_nurb, value v_sKnotCount, value v_sKnots, value v_tKnotCount, value v_tKnots, value v_sStride, value v_tStride, value v_control, value v_sOrder, value v_tOrder, value v_type ) {
	CHECK_KIND( v_nurb, k_struct_GLUnurbs_p );
	CHECK_Int( v_sKnotCount );
	CHECK_CPTR( v_sKnots );
	CHECK_Int( v_tKnotCount );
	CHECK_CPTR( v_tKnots );
	CHECK_Int( v_sStride );
	CHECK_Int( v_tStride );
	CHECK_CPTR( v_control );
	CHECK_Int( v_sOrder );
	CHECK_Int( v_tOrder );
	CHECK_Int( v_type );
	struct GLUnurbs* c_nurb = VAL_KIND( v_nurb, k_struct_GLUnurbs_p );
	int c_sKnotCount = VAL_Int( v_sKnotCount );
	float* c_sKnots = CPTR_PTR( v_sKnots, float );
	int c_tKnotCount = VAL_Int( v_tKnotCount );
	float* c_tKnots = CPTR_PTR( v_tKnots, float );
	int c_sStride = VAL_Int( v_sStride );
	int c_tStride = VAL_Int( v_tStride );
	float* c_control = CPTR_PTR( v_control, float );
	int c_sOrder = VAL_Int( v_sOrder );
	int c_tOrder = VAL_Int( v_tOrder );
	unsigned int c_type = VAL_Int( v_type );
	gluNurbsSurface(c_nurb,c_sKnotCount,c_sKnots,c_tKnotCount,c_tKnots,c_sStride,c_tStride,c_control,c_sOrder,c_tOrder,c_type);
	return val_true;
}
DEFINE_PRIM(neko_gluNurbsSurface,11);

value neko_gluOrtho2D( value v_left, value v_right, value v_bottom, value v_top ) {
	CHECK_Float( v_left );
	CHECK_Float( v_right );
	CHECK_Float( v_bottom );
	CHECK_Float( v_top );
	double c_left = VAL_Float( v_left );
	double c_right = VAL_Float( v_right );
	double c_bottom = VAL_Float( v_bottom );
	double c_top = VAL_Float( v_top );
	gluOrtho2D(c_left,c_right,c_bottom,c_top);
	return val_true;
}
DEFINE_PRIM(neko_gluOrtho2D,4);

value neko_gluPartialDisk( value v_quad, value v_inner, value v_outer, value v_slices, value v_loops, value v_start, value v_sweep ) {
	CHECK_KIND( v_quad, k_struct_GLUquadric_p );
	CHECK_Float( v_inner );
	CHECK_Float( v_outer );
	CHECK_Int( v_slices );
	CHECK_Int( v_loops );
	CHECK_Float( v_start );
	CHECK_Float( v_sweep );
	struct GLUquadric* c_quad = VAL_KIND( v_quad, k_struct_GLUquadric_p );
	double c_inner = VAL_Float( v_inner );
	double c_outer = VAL_Float( v_outer );
	int c_slices = VAL_Int( v_slices );
	int c_loops = VAL_Int( v_loops );
	double c_start = VAL_Float( v_start );
	double c_sweep = VAL_Float( v_sweep );
	gluPartialDisk(c_quad,c_inner,c_outer,c_slices,c_loops,c_start,c_sweep);
	return val_true;
}
DEFINE_PRIM(neko_gluPartialDisk,7);

value neko_gluPerspective( value v_fovy, value v_aspect, value v_zNear, value v_zFar ) {
	CHECK_Float( v_fovy );
	CHECK_Float( v_aspect );
	CHECK_Float( v_zNear );
	CHECK_Float( v_zFar );
	double c_fovy = VAL_Float( v_fovy );
	double c_aspect = VAL_Float( v_aspect );
	double c_zNear = VAL_Float( v_zNear );
	double c_zFar = VAL_Float( v_zFar );
	gluPerspective(c_fovy,c_aspect,c_zNear,c_zFar);
	return val_true;
}
DEFINE_PRIM(neko_gluPerspective,4);

value neko_gluPickMatrix( value v_x, value v_y, value v_delX, value v_delY, value v_viewport ) {
	CHECK_Float( v_x );
	CHECK_Float( v_y );
	CHECK_Float( v_delX );
	CHECK_Float( v_delY );
	CHECK_CPTR( v_viewport );
	double c_x = VAL_Float( v_x );
	double c_y = VAL_Float( v_y );
	double c_delX = VAL_Float( v_delX );
	double c_delY = VAL_Float( v_delY );
	int* c_viewport = CPTR_PTR( v_viewport, int );
	gluPickMatrix(c_x,c_y,c_delX,c_delY,c_viewport);
	return val_true;
}
DEFINE_PRIM(neko_gluPickMatrix,5);

value neko_gluProject( value v_objX, value v_objY, value v_objZ, value v_model, value v_proj, value v_view, value v_winX, value v_winY, value v_winZ ) {
	CHECK_Float( v_objX );
	CHECK_Float( v_objY );
	CHECK_Float( v_objZ );
	CHECK_CPTR( v_model );
	CHECK_CPTR( v_proj );
	CHECK_CPTR( v_view );
	CHECK_CPTR( v_winX );
	CHECK_CPTR( v_winY );
	CHECK_CPTR( v_winZ );
	double c_objX = VAL_Float( v_objX );
	double c_objY = VAL_Float( v_objY );
	double c_objZ = VAL_Float( v_objZ );
	double* c_model = CPTR_PTR( v_model, double );
	double* c_proj = CPTR_PTR( v_proj, double );
	int* c_view = CPTR_PTR( v_view, int );
	double* c_winX = CPTR_PTR( v_winX, double );
	double* c_winY = CPTR_PTR( v_winY, double );
	double* c_winZ = CPTR_PTR( v_winZ, double );
	int c_result = gluProject(c_objX,c_objY,c_objZ,c_model,c_proj,c_view,c_winX,c_winY,c_winZ);
	return ALLOC_Int( c_result );
}
DEFINE_PRIM(neko_gluProject,9);

value neko_gluPwlCurve( value v_nurb, value v_count, value v_data, value v_stride, value v_type ) {
	CHECK_KIND( v_nurb, k_struct_GLUnurbs_p );
	CHECK_Int( v_count );
	CHECK_CPTR( v_data );
	CHECK_Int( v_stride );
	CHECK_Int( v_type );
	struct GLUnurbs* c_nurb = VAL_KIND( v_nurb, k_struct_GLUnurbs_p );
	int c_count = VAL_Int( v_count );
	float* c_data = CPTR_PTR( v_data, float );
	int c_stride = VAL_Int( v_stride );
	unsigned int c_type = VAL_Int( v_type );
	gluPwlCurve(c_nurb,c_count,c_data,c_stride,c_type);
	return val_true;
}
DEFINE_PRIM(neko_gluPwlCurve,5);

value neko_gluQuadricCallback( value v_quad, value v_which, value v_CallBackFunc ) {
	CHECK_KIND( v_quad, k_struct_GLUquadric_p );
	CHECK_Int( v_which );
	CHECK_Dynamic( v_CallBackFunc );
	struct GLUquadric* c_quad = VAL_KIND( v_quad, k_struct_GLUquadric_p );
	unsigned int c_which = VAL_Int( v_which );
	_GLUfuncptr c_CallBackFunc = VAL_Dynamic( v_CallBackFunc );
	gluQuadricCallback(c_quad,c_which,c_CallBackFunc);
	return val_true;
}
DEFINE_PRIM(neko_gluQuadricCallback,3);

value neko_gluQuadricDrawStyle( value v_quad, value v_draw ) {
	CHECK_KIND( v_quad, k_struct_GLUquadric_p );
	CHECK_Int( v_draw );
	struct GLUquadric* c_quad = VAL_KIND( v_quad, k_struct_GLUquadric_p );
	unsigned int c_draw = VAL_Int( v_draw );
	gluQuadricDrawStyle(c_quad,c_draw);
	return val_true;
}
DEFINE_PRIM(neko_gluQuadricDrawStyle,2);

value neko_gluQuadricNormals( value v_quad, value v_normal ) {
	CHECK_KIND( v_quad, k_struct_GLUquadric_p );
	CHECK_Int( v_normal );
	struct GLUquadric* c_quad = VAL_KIND( v_quad, k_struct_GLUquadric_p );
	unsigned int c_normal = VAL_Int( v_normal );
	gluQuadricNormals(c_quad,c_normal);
	return val_true;
}
DEFINE_PRIM(neko_gluQuadricNormals,2);

value neko_gluQuadricOrientation( value v_quad, value v_orientation ) {
	CHECK_KIND( v_quad, k_struct_GLUquadric_p );
	CHECK_Int( v_orientation );
	struct GLUquadric* c_quad = VAL_KIND( v_quad, k_struct_GLUquadric_p );
	unsigned int c_orientation = VAL_Int( v_orientation );
	gluQuadricOrientation(c_quad,c_orientation);
	return val_true;
}
DEFINE_PRIM(neko_gluQuadricOrientation,2);

value neko_gluQuadricTexture( value v_quad, value v_texture ) {
	CHECK_KIND( v_quad, k_struct_GLUquadric_p );
	CHECK_Int( v_texture );
	struct GLUquadric* c_quad = VAL_KIND( v_quad, k_struct_GLUquadric_p );
	unsigned char c_texture = VAL_Int( v_texture );
	gluQuadricTexture(c_quad,c_texture);
	return val_true;
}
DEFINE_PRIM(neko_gluQuadricTexture,2);

value neko_gluScaleImage( value v_format, value v_wIn, value v_hIn, value v_typeIn, value v_dataIn, value v_wOut, value v_hOut, value v_typeOut, value v_dataOut ) {
	CHECK_Int( v_format );
	CHECK_Int( v_wIn );
	CHECK_Int( v_hIn );
	CHECK_Int( v_typeIn );
	CHECK_CPTR( v_dataIn );
	CHECK_Int( v_wOut );
	CHECK_Int( v_hOut );
	CHECK_Int( v_typeOut );
	CHECK_CPTR( v_dataOut );
	unsigned int c_format = VAL_Int( v_format );
	int c_wIn = VAL_Int( v_wIn );
	int c_hIn = VAL_Int( v_hIn );
	unsigned int c_typeIn = VAL_Int( v_typeIn );
	void* c_dataIn = CPTR_PTR( v_dataIn, void );
	int c_wOut = VAL_Int( v_wOut );
	int c_hOut = VAL_Int( v_hOut );
	unsigned int c_typeOut = VAL_Int( v_typeOut );
	void* c_dataOut = CPTR_PTR( v_dataOut, void );
	int c_result = gluScaleImage(c_format,c_wIn,c_hIn,c_typeIn,c_dataIn,c_wOut,c_hOut,c_typeOut,c_dataOut);
	return ALLOC_Int( c_result );
}
DEFINE_PRIM(neko_gluScaleImage,9);

value neko_gluSphere( value v_quad, value v_radius, value v_slices, value v_stacks ) {
	CHECK_KIND( v_quad, k_struct_GLUquadric_p );
	CHECK_Float( v_radius );
	CHECK_Int( v_slices );
	CHECK_Int( v_stacks );
	struct GLUquadric* c_quad = VAL_KIND( v_quad, k_struct_GLUquadric_p );
	double c_radius = VAL_Float( v_radius );
	int c_slices = VAL_Int( v_slices );
	int c_stacks = VAL_Int( v_stacks );
	gluSphere(c_quad,c_radius,c_slices,c_stacks);
	return val_true;
}
DEFINE_PRIM(neko_gluSphere,4);

value neko_gluTessBeginContour( value v_tess ) {
	CHECK_KIND( v_tess, k_struct_GLUtesselator_p );
	struct GLUtesselator* c_tess = VAL_KIND( v_tess, k_struct_GLUtesselator_p );
	gluTessBeginContour(c_tess);
	return val_true;
}
DEFINE_PRIM(neko_gluTessBeginContour,1);

value neko_gluTessBeginPolygon( value v_tess, value v_data ) {
	CHECK_KIND( v_tess, k_struct_GLUtesselator_p );
	CHECK_CPTR( v_data );
	struct GLUtesselator* c_tess = VAL_KIND( v_tess, k_struct_GLUtesselator_p );
	void* c_data = CPTR_PTR( v_data, void );
	gluTessBeginPolygon(c_tess,c_data);
	return val_true;
}
DEFINE_PRIM(neko_gluTessBeginPolygon,2);

value neko_gluTessCallback( value v_tess, value v_which, value v_CallBackFunc ) {
	CHECK_KIND( v_tess, k_struct_GLUtesselator_p );
	CHECK_Int( v_which );
	CHECK_Dynamic( v_CallBackFunc );
	struct GLUtesselator* c_tess = VAL_KIND( v_tess, k_struct_GLUtesselator_p );
	unsigned int c_which = VAL_Int( v_which );
	_GLUfuncptr c_CallBackFunc = VAL_Dynamic( v_CallBackFunc );
	gluTessCallback(c_tess,c_which,c_CallBackFunc);
	return val_true;
}
DEFINE_PRIM(neko_gluTessCallback,3);

value neko_gluTessEndContour( value v_tess ) {
	CHECK_KIND( v_tess, k_struct_GLUtesselator_p );
	struct GLUtesselator* c_tess = VAL_KIND( v_tess, k_struct_GLUtesselator_p );
	gluTessEndContour(c_tess);
	return val_true;
}
DEFINE_PRIM(neko_gluTessEndContour,1);

value neko_gluTessEndPolygon( value v_tess ) {
	CHECK_KIND( v_tess, k_struct_GLUtesselator_p );
	struct GLUtesselator* c_tess = VAL_KIND( v_tess, k_struct_GLUtesselator_p );
	gluTessEndPolygon(c_tess);
	return val_true;
}
DEFINE_PRIM(neko_gluTessEndPolygon,1);

value neko_gluTessNormal( value v_tess, value v_valueX, value v_valueY, value v_valueZ ) {
	CHECK_KIND( v_tess, k_struct_GLUtesselator_p );
	CHECK_Float( v_valueX );
	CHECK_Float( v_valueY );
	CHECK_Float( v_valueZ );
	struct GLUtesselator* c_tess = VAL_KIND( v_tess, k_struct_GLUtesselator_p );
	double c_valueX = VAL_Float( v_valueX );
	double c_valueY = VAL_Float( v_valueY );
	double c_valueZ = VAL_Float( v_valueZ );
	gluTessNormal(c_tess,c_valueX,c_valueY,c_valueZ);
	return val_true;
}
DEFINE_PRIM(neko_gluTessNormal,4);

value neko_gluTessProperty( value v_tess, value v_which, value v_data ) {
	CHECK_KIND( v_tess, k_struct_GLUtesselator_p );
	CHECK_Int( v_which );
	CHECK_Float( v_data );
	struct GLUtesselator* c_tess = VAL_KIND( v_tess, k_struct_GLUtesselator_p );
	unsigned int c_which = VAL_Int( v_which );
	double c_data = VAL_Float( v_data );
	gluTessProperty(c_tess,c_which,c_data);
	return val_true;
}
DEFINE_PRIM(neko_gluTessProperty,3);

value neko_gluTessVertex( value v_tess, value v_location, value v_data ) {
	CHECK_KIND( v_tess, k_struct_GLUtesselator_p );
	CHECK_CPTR( v_location );
	CHECK_CPTR( v_data );
	struct GLUtesselator* c_tess = VAL_KIND( v_tess, k_struct_GLUtesselator_p );
	double* c_location = CPTR_PTR( v_location, double );
	void* c_data = CPTR_PTR( v_data, void );
	gluTessVertex(c_tess,c_location,c_data);
	return val_true;
}
DEFINE_PRIM(neko_gluTessVertex,3);

value neko_gluUnProject( value v_winX, value v_winY, value v_winZ, value v_model, value v_proj, value v_view, value v_objX, value v_objY, value v_objZ ) {
	CHECK_Float( v_winX );
	CHECK_Float( v_winY );
	CHECK_Float( v_winZ );
	CHECK_CPTR( v_model );
	CHECK_CPTR( v_proj );
	CHECK_CPTR( v_view );
	CHECK_CPTR( v_objX );
	CHECK_CPTR( v_objY );
	CHECK_CPTR( v_objZ );
	double c_winX = VAL_Float( v_winX );
	double c_winY = VAL_Float( v_winY );
	double c_winZ = VAL_Float( v_winZ );
	double* c_model = CPTR_PTR( v_model, double );
	double* c_proj = CPTR_PTR( v_proj, double );
	int* c_view = CPTR_PTR( v_view, int );
	double* c_objX = CPTR_PTR( v_objX, double );
	double* c_objY = CPTR_PTR( v_objY, double );
	double* c_objZ = CPTR_PTR( v_objZ, double );
	int c_result = gluUnProject(c_winX,c_winY,c_winZ,c_model,c_proj,c_view,c_objX,c_objY,c_objZ);
	return ALLOC_Int( c_result );
}
DEFINE_PRIM(neko_gluUnProject,9);

value neko_gluUnProject4( value v_winX, value v_winY, value v_winZ, value v_clipW, value v_model, value v_proj, value v_view, value v_near, value v_far, value v_objX, value v_objY, value v_objZ, value v_objW ) {
	CHECK_Float( v_winX );
	CHECK_Float( v_winY );
	CHECK_Float( v_winZ );
	CHECK_Float( v_clipW );
	CHECK_CPTR( v_model );
	CHECK_CPTR( v_proj );
	CHECK_CPTR( v_view );
	CHECK_Float( v_near );
	CHECK_Float( v_far );
	CHECK_CPTR( v_objX );
	CHECK_CPTR( v_objY );
	CHECK_CPTR( v_objZ );
	CHECK_CPTR( v_objW );
	double c_winX = VAL_Float( v_winX );
	double c_winY = VAL_Float( v_winY );
	double c_winZ = VAL_Float( v_winZ );
	double c_clipW = VAL_Float( v_clipW );
	double* c_model = CPTR_PTR( v_model, double );
	double* c_proj = CPTR_PTR( v_proj, double );
	int* c_view = CPTR_PTR( v_view, int );
	double c_near = VAL_Float( v_near );
	double c_far = VAL_Float( v_far );
	double* c_objX = CPTR_PTR( v_objX, double );
	double* c_objY = CPTR_PTR( v_objY, double );
	double* c_objZ = CPTR_PTR( v_objZ, double );
	double* c_objW = CPTR_PTR( v_objW, double );
	int c_result = gluUnProject4(c_winX,c_winY,c_winZ,c_clipW,c_model,c_proj,c_view,c_near,c_far,c_objX,c_objY,c_objZ,c_objW);
	return ALLOC_Int( c_result );
}
DEFINE_PRIM(neko_gluUnProject4,13);

value neko_gluSimpleTesselator( ) {
	struct GLUtesselator* c_result = gluSimpleTesselator();
	return ALLOC_KIND( c_result, k_struct_GLUtesselator_p );
}
DEFINE_PRIM(neko_gluSimpleTesselator,0);

value neko_gluTessVertexSimple( value v_tess, value v_v ) {
	CHECK_KIND( v_tess, k_struct_GLUtesselator_p );
	CHECK_CPTR( v_v );
	struct GLUtesselator* c_tess = VAL_KIND( v_tess, k_struct_GLUtesselator_p );
	double* c_v = CPTR_PTR( v_v, double );
	gluTessVertexSimple(c_tess,c_v);
	return val_true;
}
DEFINE_PRIM(neko_gluTessVertexSimple,2);

value neko_gluTessVertexOffset( value v_tess, value v_v, value v_offset ) {
	CHECK_KIND( v_tess, k_struct_GLUtesselator_p );
	CHECK_CPTR( v_v );
	CHECK_Int( v_offset );
	struct GLUtesselator* c_tess = VAL_KIND( v_tess, k_struct_GLUtesselator_p );
	double* c_v = CPTR_PTR( v_v, double );
	int c_offset = VAL_Int( v_offset );
	gluTessVertexOffset(c_tess,c_v,c_offset);
	return val_true;
}
DEFINE_PRIM(neko_gluTessVertexOffset,3);

value neko_gluTessCubicCurve( value v_tess, value v_ctrl, value v_v, value v_n ) {
	CHECK_KIND( v_tess, k_struct_GLUtesselator_p );
	CHECK_CPTR( v_v );
	CHECK_Int( v_n );
	struct GLUtesselator* c_tess = VAL_KIND( v_tess, k_struct_GLUtesselator_p );
	value c_ctrl = v_ctrl;
	double* c_v = CPTR_PTR( v_v, double );
	int c_n = VAL_Int( v_n );
	gluTessCubicCurve(c_tess,c_ctrl,c_v,c_n);
	return val_true;
}
DEFINE_PRIM(neko_gluTessCubicCurve,4);

value neko_gluTessQuadraticCurve( value v_tess, value v__ctrl, value v_v, value v__n ) {
	CHECK_KIND( v_tess, k_struct_GLUtesselator_p );
	CHECK_CPTR( v_v );
	CHECK_Int( v__n );
	struct GLUtesselator* c_tess = VAL_KIND( v_tess, k_struct_GLUtesselator_p );
	value c__ctrl = v__ctrl;
	double* c_v = CPTR_PTR( v_v, double );
	int c__n = VAL_Int( v__n );
	gluTessQuadraticCurve(c_tess,c__ctrl,c_v,c__n);
	return val_true;
}
DEFINE_PRIM(neko_gluTessQuadraticCurve,4);

value neko_gluVerticesOffset( value v_v, value v_offset, value v_n ) {
	CHECK_CPTR( v_v );
	CHECK_Int( v_offset );
	CHECK_Int( v_n );
	double* c_v = CPTR_PTR( v_v, double );
	int c_offset = VAL_Int( v_offset );
	int c_n = VAL_Int( v_n );
	gluVerticesOffset(c_v,c_offset,c_n);
	return val_true;
}
DEFINE_PRIM(neko_gluVerticesOffset,3);

value neko_gluTesselatePath( value v_tess, value v__points ) {
	CHECK_KIND( v_tess, k_struct_GLUtesselator_p );
	struct GLUtesselator* c_tess = VAL_KIND( v_tess, k_struct_GLUtesselator_p );
	value c__points = v__points;
	gluTesselatePath(c_tess,c__points);
	return val_true;
}
DEFINE_PRIM(neko_gluTesselatePath,2);

value neko_gluEvaluateCubicToArray( value v__ctrl, value v__n ) {
	CHECK_Int( v__n );
	value c__ctrl = v__ctrl;
	int c__n = VAL_Int( v__n );
	value c_result = gluEvaluateCubicToArray(c__ctrl,c__n);
	return c_result;
}
DEFINE_PRIM(neko_gluEvaluateCubicToArray,2);

value neko_gluEvaluateQuadraticToArray( value v__ctrl, value v__n ) {
	CHECK_Int( v__n );
	value c__ctrl = v__ctrl;
	int c__n = VAL_Int( v__n );
	value c_result = gluEvaluateQuadraticToArray(c__ctrl,c__n);
	return c_result;
}
DEFINE_PRIM(neko_gluEvaluateQuadraticToArray,2);

value neko_gluEvaluateCubicBezier( value v__ctrl, value v__n, value v_callback ) {
	CHECK_Int( v__n );
	value c__ctrl = v__ctrl;
	int c__n = VAL_Int( v__n );
	value c_callback = v_callback;
	value c_result = gluEvaluateCubicBezier(c__ctrl,c__n,c_callback);
	return c_result;
}
DEFINE_PRIM(neko_gluEvaluateCubicBezier,3);

value neko_gluEvaluateQuadraticBezier( value v__ctrl, value v__n, value v_callback ) {
	CHECK_Int( v__n );
	value c__ctrl = v__ctrl;
	int c__n = VAL_Int( v__n );
	value c_callback = v_callback;
	value c_result = gluEvaluateQuadraticBezier(c__ctrl,c__n,c_callback);
	return c_result;
}
DEFINE_PRIM(neko_gluEvaluateQuadraticBezier,3);

