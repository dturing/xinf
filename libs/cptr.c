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
    int sz = (int)val_number(n); \
    ctype *ptr = ( ctype *)malloc( sizeof( ctype ) * sz ); \
    value r = ALLOC_KIND( ptr, k_## ctype ##_p ); \
    val_gc( r, cptr_finalize ); \
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

#define TO_ARRAY(ctype,hxtype) \
value cptr_## ctype ##_to_array( value p, value f, value t ) { \
    int i; \
    CHECK_KIND( p, k_## ctype ##_p );  \
    CHECK_Int( f ); \
    CHECK_Int( t ); \
    int from = (int)val_number(f); \
    int to = (int)val_number(t); \
    ctype* ptr = (ctype*)val_data(p); \
    value result = alloc_array( to-from ); \
    value *a = val_array_ptr( result ); \
    for( i=from; i<to; i++ ) { \
        a[i-from] = ALLOC_## hxtype ( ptr[i] ); \
    } \
    return( result ); \
} \
DEFINE_PRIM(cptr_## ctype ##_to_array,3);

#define FROM_ARRAY(ctype,hxtype) \
value cptr_## ctype ##_from_array( value p, value f, value values ) { \
    int i; \
    CHECK_KIND( p, k_## ctype ##_p );  \
    CHECK_Int( f ); \
    CHECK_Array( values ); \
    int from = (int)val_number(f); \
    int to = from + val_array_size(values); \
    ctype* ptr = (ctype*)val_data(p); \
    value *a = val_array_ptr( values ); \
    for( i=from; i<to; i++ ) { \
        ptr[i] = VAL_## hxtype ( a[i-from] ); \
    } \
    return( val_true ); \
} \
DEFINE_PRIM(cptr_## ctype ##_from_array,3);

#define CPTR(ctype,hxtype) \
    DEFINE_KIND( k_## ctype ##_p ); \
    ALLOC(ctype,hxtype) \
    GET(ctype,hxtype) \
    SET(ctype,hxtype) \
    TO_ARRAY(ctype,hxtype ) \
    FROM_ARRAY(ctype,hxtype )
    
    
typedef unsigned int unsigned_int;
typedef unsigned char unsigned_char;
typedef unsigned short unsigned_short;

CPTR( float, Float );
CPTR( double, Float );
CPTR( int, Int );
CPTR( unsigned_int, Int );
CPTR( char, Int );
CPTR( unsigned_char, Int );
CPTR( short, Int );
CPTR( unsigned_short, Int );


// FIXME: do cast/null for other types also (maybe)
DEFINE_KIND(k_void_p)
DEFINE_KIND(k_void_p_p)
value cptr_void_cast( value p ) {
    if( !val_is_abstract( p ) ) {
        failure("will only cast #abstract values to void*.");
        return NULL;
    }
    void *ptr = (void*)val_data(p);
    return( ALLOC_KIND( ptr, k_void_p ) );
}
DEFINE_PRIM(cptr_void_cast,1);

value cptr_void_null() {
    return( ALLOC_KIND( NULL, k_void_p ) );
}
DEFINE_PRIM(cptr_void_null,0);
