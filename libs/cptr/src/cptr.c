#include <string.h>
#include <neko.h>

void check_cptr( value cp, int size ) {
	if( !val_is_string( cp ) ) val_throw( alloc_string("not a string - cannot access as cptr") );
	if( size>0 && val_strlen(cp) < size ) val_throw( alloc_string("cptr overflow") );
}

#define CPTR_ALLOC(ctype,hxtype) \
value cptr_## ctype ##_alloc( value n ) { \
    val_check(n,int); \
    int size = val_number(n); \
	return alloc_empty_string(size*sizeof( ctype )); \
} \
DEFINE_PRIM(cptr_## ctype ##_alloc,1);

#define CPTR_GET(ctype,hxtype) \
value cptr_## ctype ##_get( value cp, value _i ) { \
    val_check( _i, number ); \
    int i=val_number(_i); \
    check_cptr( cp, i*sizeof( ctype ) ); \
    return alloc_## hxtype ( (( ctype* )val_string(cp))[i] ); \
} \
DEFINE_PRIM(cptr_## ctype ##_get,2);

#define CPTR_SET(ctype,hxtype) \
value cptr_## ctype ##_set( value cp, value _i, value _v ) { \
    val_check( _i, int ); \
    val_check( _v, number ); \
    int i=val_number(_i); \
	check_cptr( cp, i*sizeof( ctype ) ); \
    (( ctype* )val_string(cp))[i] = val_number(_v); \
    return _v; \
} \
DEFINE_PRIM(cptr_## ctype ##_set,3);


#define CPTR_TO_ARRAY(ctype,hxtype) \
value cptr_## ctype ##_to_array( value cp, value f, value t ) { \
    int i; \
    check_cptr( cp, 0 ); \
    val_check( f, int ); \
    val_check( t, int ); \
    int from = (int)val_number(f); \
    int to = (int)val_number(t); \
    \
    int n = val_strlen(cp)/sizeof(ctype); \
    ctype *ptr = (ctype *)val_string(cp); \
    if( from >= n ) val_throw( alloc_string( "from index out of range" ) ); \
    if( to > n ) val_throw( alloc_string( "to index out of range" ) ); \
    if( from >= to ) val_throw( alloc_string( "from must be lower than to" ) ); \
    if( ptr == NULL ) { \
        val_throw( alloc_string( "null pointer" ) ); \
        return val_null; \
    } \
    \
    value result = alloc_array( to-from ); \
    value *a = val_array_ptr( result ); \
    for( i=from; i<to; i++ ) { \
        a[i-from] = alloc_## hxtype ( ptr[i] ); \
    } \
    return( result ); \
} \
DEFINE_PRIM(cptr_## ctype ##_to_array,3);

#define CPTR_FROM_ARRAY(ctype,hxtype) \
value cptr_## ctype ##_from_array( value cp, value values ) { \
    int i; \
    check_cptr( cp, 0 ); \
    if( !val_is_array( values ) ) val_throw(alloc_string("argument is not an array")); \
    int to = val_array_size( values ); \
    \
    int n = val_strlen(cp)/sizeof(ctype); \
    if( to > n ) val_throw( alloc_string( "cptr overflow" ) ); \
	ctype *ptr = (ctype *)val_string(cp); \
    if( ptr == NULL ) { \
        val_throw( alloc_string( "null pointer" ) ); \
        return val_null; \
    } \
    \
    value *a = val_array_ptr( values ); \
    for( i=0; i<to; i++ ) { \
		if( !val_is_number( a[i] ) ) { \
			buffer buf = alloc_buffer("not a number at index "); \
			val_buffer( buf, alloc_int(i) ); \
			buffer_append( buf, ", instead: " ); \
			val_buffer( buf, a[i] ); \
			val_throw( buffer_to_string(buf) ); \
		} \
        ptr[i] = val_number( a[i] ); \
    } \
    return( val_true ); \
} \
DEFINE_PRIM(cptr_## ctype ##_from_array,2);

#define CPTR(ctype,hxtype) \
    CPTR_ALLOC(ctype,hxtype) \
    CPTR_GET(ctype,hxtype) \
    CPTR_SET(ctype,hxtype) \
    CPTR_TO_ARRAY(ctype,hxtype ) \
    CPTR_FROM_ARRAY(ctype,hxtype )

typedef unsigned int uint;
typedef unsigned short ushort;
typedef unsigned char uchar;

CPTR(float,float);
CPTR(double,float);
CPTR(int,float);
CPTR(uint,float);
CPTR(char,float);
CPTR(uchar,float);
CPTR(short,float);
CPTR(ushort,float);
