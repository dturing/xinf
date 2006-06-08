#include "cptr.h"
#include <memory.h>

DEFINE_KIND(k_cptr);

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
    if( !val_is_abstract(v) || !val_is_kind(v,k_cptr) ) {
        val_throw( alloc_string("value is of invalid kind.") );
        return;
    }
    
    void *ptr = VAL_CPTR(v)->ptr;
    if( ptr != NULL ) {
        free( ptr );
    }
    free( VAL_CPTR(v) );
}

value alloc_cptr( void *ptr, unsigned char kind, int length ) {
    cptr *cp = (cptr*)malloc( sizeof(cptr) );
    cp->kind = kind;
    cp->length = length;
    cp->ptr = ptr;
    value r = alloc_abstract( k_cptr, cp );
    val_gc( r, cptr_finalize );
    return r;
}

#define ALLOC(ctype,hxtype) \
value cptr_## ctype ##_alloc( value n ) { \
    CHECK_Int( n ); \
    int sz = (int)val_number(n); \
    ctype *ptr = ( ctype *)malloc( sizeof( ctype ) * sz ); \
    return( alloc_cptr( (void *)ptr, CPTR_## ctype, sz ) ); \
} \
DEFINE_PRIM(cptr_## ctype ##_alloc,1);

#define GET(ctype,hxtype) \
value cptr_## ctype ##_get( value p, value n ) { \
    CHECK_CPTR_KIND( p, CPTR_## ctype ); \
    CHECK_Int( n ); \
    unsigned int _n = val_number(n); \
    cptr *cp = (cptr*)val_data(p); \
    if( _n >= cp->length ) val_throw( alloc_string( "index out of range" ) ); \
    ctype *ptr = ( ctype *)cp->ptr; \
    if( ptr == NULL ) { \
        val_throw( alloc_string( "null pointer" ) ); \
        return val_null; \
    } \
    return( ALLOC_## hxtype ( ptr[ _n ] ) ); \
} \
DEFINE_PRIM(cptr_## ctype ##_get,2);

#define SET(ctype,hxtype) \
value cptr_## ctype ##_set( value p, value n, value v ) { \
    CHECK_CPTR_KIND( p, CPTR_## ctype ); \
    CHECK_## hxtype ( v ); \
    CHECK_Int( n ); \
    unsigned int _n = val_number(n); \
    cptr *cp = (cptr*)val_data(p); \
    if( _n >= cp->length ) val_throw( alloc_string( "index out of range" ) ); \
    ctype *ptr = ( ctype *)cp->ptr; \
    if( ptr == NULL ) { \
        val_throw( alloc_string( "null pointer" ) ); \
        return val_null; \
    } \
    ptr[ (int)val_number(n) ] = (ctype)VAL_## hxtype(v);\
    return( v ); \
} \
DEFINE_PRIM(cptr_## ctype ##_set,3);

/*
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
*/

#define CPTR(ctype,hxtype) \
    ALLOC(ctype,hxtype) \
    GET(ctype,hxtype) \
    SET(ctype,hxtype) 
    /*\
    DEFINE_KIND( k_## ctype ##_p ); \
    FREE(ctype,hxtype) \
    TO_ARRAY(ctype,hxtype ) \
    FROM_ARRAY(ctype,hxtype )
    */
    
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
value cptr_void_null() {
    return( alloc_cptr( NULL, CPTR_void, 0 ) );
}
DEFINE_PRIM(cptr_void_null,0);

DEFINE_KIND(k_void_p_p)
/*
//DEFINE_KIND(k_void_p)
value cptr_void_cast( value p ) {
    if( !val_is_abstract( p ) ) {
        failure("will only cast #abstract values to void*.");
        return NULL;
    }
    void *ptr = (void*)val_data(p);
    return( ALLOC_KIND( ptr, k_void_p ) );
}
DEFINE_PRIM(cptr_void_cast,1);

value cptr_is_valid( value ptr ) {
    if( ptr == val_null || !val_is_abstract(ptr) ) return val_false;
    if( val_data(ptr) == NULL ) return val_false;
    return val_true;
}
DEFINE_PRIM(cptr_is_valid,1);
*/

// FIXME: this is not really CPtr stuff, but "util"
#include <sys/time.h>
value util_msec() {
    // FIXME: Linux only, and it really should work with the std library (neko std.sys_time, if not new Date())
    // but all i get there is the seconds. i need milliseconds for profiling, tho.
    struct timeval tv;
    if( gettimeofday(&tv,NULL) != 0 )
        neko_error();
    return alloc_int( (int)((tv.tv_sec*1000)+(tv.tv_usec/1000)) );
}
DEFINE_PRIM(util_msec,0);

