#include "cptr.h"

CPTR_LOCAL_HELPERS;

DEFINE_KIND(k_cptr);
DEFINE_ENTRY_POINT(cptr_main);

void cptr_main() {
	kind_export(k_cptr,"cptr");
}

value cptr_void_null() {
    return alloc_cptr( NULL, 0, NULL );
}
DEFINE_PRIM(cptr_void_null,0);

value cptr_as_string( value cp ) {
    check_cptr(cp,0);
    return copy_string( val_cptr(cp,void), val_cptr_size(cp) );
}
DEFINE_PRIM( cptr_as_string, 1 );

value cptr_from_string( value s ) {
    val_check(s,string);
    unsigned char *str = val_string(s); // FIXME: strdup?
    int n = val_strlen(s);
    value r = alloc_cptr( str, n, free );
    return r;
}
DEFINE_PRIM( cptr_from_string, 1 );

value cptr_info( value cp ) {
    if( !val_is_abstract(cp) )
        return alloc_string("[not abstract]");
    if( !val_is_kind(cp,k_cptr) )
        return alloc_string("[no cptr]");
    
	check_cptr(cp,0);
	
    value r = alloc_object(NULL);
    alloc_field(r,val_id("address"),alloc_float( (float)((int)val_cptr(cp,void)) ) );
    alloc_field(r,val_id("size"),alloc_int( val_cptr_size(cp) ) );

    return r;
}
DEFINE_PRIM( cptr_info, 1 );


#define CPTR_ALLOC(ctype,hxtype) \
value cptr_## ctype ##_alloc( value n ) { \
    val_check(n,int); \
    int size = val_number(n); \
	void *ptr = malloc(size*sizeof( ctype )); \
    return alloc_cptr( ptr, size*sizeof( ctype ), free ); \
} \
DEFINE_PRIM(cptr_## ctype ##_alloc,1);

#define CPTR_GET(ctype,hxtype) \
value cptr_## ctype ##_get( value cp, value _i ) { \
    check_cptr( cp, 0 ); \
    val_check( _i, int ); \
    int n=val_cptr_size(cp)/sizeof(ctype); \
    int i=val_number(_i); \
    if( i<0 || i>=n ) val_throw(alloc_string("cptr index out of bounds")); \
    return alloc_## hxtype ( val_cptr(cp,ctype)[i] ); \
} \
DEFINE_PRIM(cptr_## ctype ##_get,2);

#define CPTR_SET(ctype,hxtype) \
value cptr_## ctype ##_set( value cp, value _i, value _v ) { \
    check_cptr( cp, 0 ); \
    val_check( _i, int ); \
    val_check( _v, number ); \
    int n=val_cptr_size(cp)/sizeof(ctype ); \
    int i=val_number(_i); \
    if( i<0 || i>=n ) val_throw(alloc_string("cptr index out of bounds")); \
    val_cptr(cp,ctype)[i] = val_number(_v); \
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
    int n = val_cptr_size(cp)/sizeof(ctype); \
    ctype *ptr = val_cptr(cp,ctype); \
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
    int n = val_cptr_size(cp)/sizeof(ctype); \
    if( to > n ) val_throw( alloc_string( "cptr overflow" ) ); \
	ctype *ptr = val_cptr(cp,ctype); \
    if( ptr == NULL ) { \
        val_throw( alloc_string( "null pointer" ) ); \
        return val_null; \
    } \
    \
    value *a = val_array_ptr( values ); \
    for( i=0; i<to; i++ ) { \
		val_check( a[i], number ); \
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

/*
typedef unsigned int uint;
typedef unsigned short ushort;
*/

typedef unsigned char uchar;

CPTR(float,float);
CPTR(double,float);
CPTR(int,float);
CPTR(uint,float);
CPTR(char,float);
CPTR(uchar,float);
CPTR(short,float);
CPTR(ushort,float);
