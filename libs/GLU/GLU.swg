%module GLU

typedef unsigned int	GLenum;
typedef unsigned char	GLboolean;
typedef unsigned int	GLbitfield;
typedef void		GLvoid;
typedef signed char	GLbyte;		/* 1-byte signed */
typedef short		GLshort;	/* 2-byte signed */
typedef int		GLint;		/* 4-byte signed */
typedef unsigned char	GLubyte;	/* 1-byte unsigned */
typedef unsigned short	GLushort;	/* 2-byte unsigned */
typedef unsigned int	GLuint;		/* 4-byte unsigned */
typedef int		GLsizei;	/* 4-byte signed */
typedef float		GLfloat;	/* single precision float */
typedef float		GLclampf;	/* single precision float in [0,1] */
typedef double		GLdouble;	/* double precision float */
typedef double		GLclampd;	/* double precision float in [0,1] */

%include <GL/glu.h>

GLUtesselator *gluSimpleTesselator( void );
void gluTessVertexSimple( GLUtesselator *tess, double *v );
void gluTessVertexOffset( GLUtesselator *tess, double *v, int offset );
void gluTessCubicCurve( GLUtesselator *tess, value ctrl, double *v, int n );
void gluTessQuadraticCurve( GLUtesselator *tess, value _ctrl, double *v, int _n );

void gluVerticesOffset( double *v, int offset, int n );

void gluTesselatePath( GLUtesselator *tess, value _points );
value gluEvaluateCubicToArray( value _ctrl, int _n );
value gluEvaluateQuadraticToArray( value _ctrl, int _n );
value gluEvaluateCubicBezier( value _ctrl, int _n, value callback );
value gluEvaluateQuadraticBezier( value _ctrl, int _n, value callback );
