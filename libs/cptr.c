#include "cptr.h"
#include <memory.h>

void check_failed( const char *function, const char *file, int line, value given ) {
    buffer b = alloc_buffer("");
    val_buffer(b,given);
    buffer_append(b," is of invalid type for ");
    buffer_append(b, function );
   
    _neko_failure(buffer_to_string(b), file, line );
}

void kind_check_failed( const char *function, const char *file, int line, value given, const char *kind ) {
    buffer b = alloc_buffer("");
    val_buffer(b,given);
    buffer_append(b," is of invalid kind for ");
    buffer_append(b,function );
    buffer_append(b,", expected: ");
    buffer_append(b,kind);
   
    _neko_failure(buffer_to_string(b), file, line );
}


void cptr_finalize( value v ) {
    free( val_data(v) );
}

#define ALLOC(ctype,hxtype) \
value cptr_## ctype ##_alloc( value n ) { \
    CHECK_Int( n ); \
    ctype *ptr = ( ctype *)malloc( sizeof( ctype ) * (int)val_number(n) ); \
    value r = ALLOC_KIND( ptr, k_## ctype ##_p ); \
    val_gc( r, cptr_finalize ); \
    printf("alloc " #ctype " of size %i\n", (int)val_number(n) ); \
    return r; \
} \
DEFINE_PRIM(cptr_## ctype ##_alloc,1);



#define GET(ctype,hxtype) \
value cptr_## ctype ##_get( value p, value n ) { \
    CHECK_KIND( p, k_## ctype ##_p ); \
    CHECK_Int( n ); \
    ctype *ptr = ( ctype *)val_data(p); \
    if( ptr == NULL ) { \
        val_throw( alloc_string( "null pointer" ) ); \
        return val_null; \
    } \
    return( ALLOC_## hxtype ( ptr[ (int)val_number(n) ] ) ); \
} \
DEFINE_PRIM(cptr_## ctype ##_get,2);

#define SET(ctype,hxtype) \
value cptr_## ctype ##_set( value p, value n, value v ) { \
    CHECK_KIND( p, k_## ctype ##_p ); \
    CHECK_Int( n ); \
    CHECK_## hxtype ( v ); \
    ctype *ptr = (ctype*)val_data(p); \
    if( ptr == NULL ) { \
        val_throw( alloc_string( "null pointer" ) ); \
        return val_null; \
    } \
    ptr[ (int)val_number(n) ] = (ctype)VAL_## hxtype(v);\
    return( v ); \
} \
DEFINE_PRIM(cptr_## ctype ##_set,3);

#define CPTR(ctype,hxtype) \
    DEFINE_KIND( k_## ctype ##_p ); \
    ALLOC(ctype,hxtype) \
    GET(ctype,hxtype) \
    SET(ctype,hxtype) 
    
    
typedef unsigned int unsigned_int;
typedef unsigned char unsigned_char;
typedef unsigned short unsigned_short;

DEFINE_KIND(k_void_p)
DEFINE_KIND(k_void_p_p)
    
CPTR( float, Float );
CPTR( double, Float );
CPTR( int, Int );
CPTR( unsigned_int, Int );
CPTR( char, Int );
CPTR( unsigned_char, Int );
CPTR( short, Int );
CPTR( unsigned_short, Int );
