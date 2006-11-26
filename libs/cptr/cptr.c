#include "cptr.h"
#include <memory.h>

CPTR_LOCAL_HELPERS
vkind k_cptr;

DEFINE_ENTRY_POINT(cptr_main);

void cptr_main() {
	k_cptr = kind_import("cptr");
	if( !k_cptr ) {
		DEFINE_KIND(_k_cptr);
		kind_export(_k_cptr,"cptr");
		k_cptr = kind_import("cptr");
	}
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

/*
void cptr_finalize( value cp ) {
    CHECK_CPTR(cp);
	cptr *p = val_data( cp );
    if( p->ptr ) free(p->ptr);
    if( p ) free(p);
}
value cptr_wrap( void *ptr, int size ) {
    cptr *p = (cptr*)malloc( sizeof(cptr) );
    p->size = size;
    p->ptr = ptr;
    value r = alloc_abstract( k_cptr, p );
    val_gc( r, cptr_finalize );
    return(r);
}

value cptr_wrap_foreign( void *ptr, int size ) {
    cptr *p = (cptr*)malloc( sizeof(cptr) );
    p->size = size;
    p->ptr = ptr;
    value r = alloc_abstract( k_cptr, p );
    return(r);
}
*/
value cptr_alloc( int size ) {
    void *ptr = (void*)malloc( size );
    if( !ptr ) val_throw( alloc_string("out of memory"));
    return( cptr_wrap( ptr, size ) );
}

value cptr_void_null() {
    return cptr_wrap( NULL, 0 );
}
DEFINE_PRIM(cptr_void_null,0);

value cptr_as_string( value cp ) {
    CHECK_CPTR(cp);
    return copy_string( CPTR_PTR(cp,void), CPTR_SIZE(cp) );
}
DEFINE_PRIM( cptr_as_string, 1 );

value cptr_from_string( value s ) {
    CHECK_String(s);
    unsigned char *str = VAL_String(s);
    int n = val_strlen(s);
    value r = cptr_alloc( n );
    memcpy( CPTR_PTR(r,void), str, n );
    return r;
}
DEFINE_PRIM( cptr_from_string, 1 );

value cptr_info( value cp ) {
    if( !val_is_abstract(cp) )
        return alloc_string("[not abstract]");
    if( !val_is_kind(cp,k_cptr) )
        return alloc_string("[no cptr]");
    
    value r = alloc_object(NULL);
    alloc_field(r,val_id("address"),alloc_float( (float)((int)CPTR_PTR(cp,void)) ) );
    alloc_field(r,val_id("size"),alloc_int( CPTR_SIZE(cp) ) );

    return r;
}
DEFINE_PRIM( cptr_info, 1 );


#define CPTR_ALLOC(ctype,hxtype) \
value cptr_## ctype ##_alloc( value n ) { \
    CHECK_NUMBER(n,int); \
    int size = val_number(n); \
    return cptr_alloc( size*sizeof( ctype ) ); \
} \
DEFINE_PRIM(cptr_## ctype ##_alloc,1);

#define CPTR_GET(ctype,hxtype) \
value cptr_## ctype ##_get( value cp, value _i ) { \
    CHECK_CPTR( cp ); \
    CHECK_NUMBER( _i, int ); \
    int n=CPTR_SIZE(cp)/sizeof(ctype); \
    int i=val_number(_i); \
    if( i<0 || i>=n ) val_throw(alloc_string("cptr index out of bounds")); \
    return ALLOC_## hxtype ( CPTR_PTR(cp,ctype)[i] ); \
} \
DEFINE_PRIM(cptr_## ctype ##_get,2);

#define CPTR_SET(ctype,hxtype) \
value cptr_## ctype ##_set( value cp, value _i, value _v ) { \
    CHECK_CPTR( cp ); \
    CHECK_NUMBER( _i, int ); \
    CHECK_## hxtype ( _v ); \
    int n=CPTR_SIZE(cp)/sizeof(ctype ); \
    int i=val_number(_i); \
    if( i<0 || i>=n ) val_throw(alloc_string("cptr index out of bounds")); \
    CPTR_PTR(cp,ctype)[i] = val_number(_v); \
    return _v; \
} \
DEFINE_PRIM(cptr_## ctype ##_set,3);


#define CPTR_TO_ARRAY(ctype,hxtype) \
value cptr_## ctype ##_to_array( value cp, value f, value t ) { \
    int i; \
    CHECK_CPTR( cp ); \
    CHECK_Int( f ); \
    CHECK_Int( t ); \
    int from = (int)val_number(f); \
    int to = (int)val_number(t); \
    \
    int n = CPTR_SIZE(cp)/sizeof(ctype); \
    ctype *ptr = CPTR_PTR(cp,ctype); \
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
        a[i-from] = ALLOC_## hxtype ( ptr[i] ); \
    } \
    return( result ); \
} \
DEFINE_PRIM(cptr_## ctype ##_to_array,3);

#define CPTR_FROM_ARRAY(ctype,hxtype) \
value cptr_## ctype ##_from_array( value cp, value f, value values ) { \
    int i; \
    CHECK_CPTR( cp ); \
    CHECK_Int( f ); \
    CHECK_Array( values ); \
    int from = (int)val_number(f); \
    int to = from + val_array_size( values ); \
    \
    int n = CPTR_SIZE(cp)/sizeof(ctype); \
    ctype *ptr = CPTR_PTR(cp,ctype); \
    if( from >= n ) val_throw( alloc_string( "from index out of range" ) ); \
    if( from >= to ) val_throw( alloc_string( "no values after from" ) ); \
    if( ptr == NULL ) { \
        val_throw( alloc_string( "null pointer" ) ); \
        return val_null; \
    } \
    \
    value *a = val_array_ptr( values ); \
    for( i=from; i<to; i++ ) { \
        ptr[i] = VAL_## hxtype ( a[i-from] ); \
    } \
    return( val_true ); \
} \
DEFINE_PRIM(cptr_## ctype ##_from_array,3);

#define CPTR(ctype,hxtype) \
    CPTR_ALLOC(ctype,hxtype) \
    CPTR_GET(ctype,hxtype) \
    CPTR_SET(ctype,hxtype) \
    CPTR_TO_ARRAY(ctype,hxtype ) \
    CPTR_FROM_ARRAY(ctype,hxtype )


typedef unsigned int uint;
typedef unsigned char uchar;
typedef unsigned short ushort;

CPTR(float,Float);
CPTR(double,Float);
CPTR(int,Float);
CPTR(uint,Float);
CPTR(char,Float);
CPTR(uchar,Float);
CPTR(short,Float);
CPTR(ushort,Float);
