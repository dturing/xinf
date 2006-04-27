#include <neko.h>

/* TODO: 
    finalize (memleak!)
    int, double,
    to_array, from_array
*/

#define VAL_CHECK( var, type ) \
    if( !val_is_ ## type(var) ) failure("illegal argument type");


DEFINE_KIND( k_cptr_float );
value cptr_float_alloc( value n ) {
    VAL_CHECK( n, int )
    int _n = val_number(n);
    float *cptr = (float*)malloc( sizeof(float) * _n);
    if( !cptr ) failure("out of memory");
    memset( cptr, 0, sizeof(float)*_n );
    return alloc_abstract( k_cptr_float, cptr );
}
DEFINE_PRIM( cptr_float_alloc, 1 );

value cptr_float_set( value ptr, value i, value v ) {
    val_check_kind( ptr, k_cptr_float );
    VAL_CHECK( i, int );
    VAL_CHECK( v, float );
    float *cptr = (float*)val_data( ptr );
    cptr[(int)val_number(i)] = val_float( v );
    return v;
}
DEFINE_PRIM( cptr_float_set, 3 );

value cptr_float_get( value ptr, value i ) {
    val_check_kind( ptr, k_cptr_float );
    VAL_CHECK( i, int );
    float *cptr = (float*)val_data( ptr );
    return alloc_float( cptr[(int)val_number(i)] );
}
DEFINE_PRIM( cptr_float_get, 2 );


#define CPTR_ALLOC(type) \
    value cptr_ ## type ## _alloc( value n ) {                  \
        VAL_CHECK( n, int )                                     \
        int _n = val_number(n);                                 \
        float *cptr = (float*)malloc( sizeof( type ) * _n);     \
        if( !cptr ) failure("out of memory");                   \
        memset( cptr, 0, sizeof( type )*_n );                   \
        return alloc_abstract( k_cptr_ ## type , cptr );        \
    }                                                           \
    DEFINE_PRIM( cptr_ ## type ##_alloc, 1 );
    
#define CPTR_SETTER(type,nekotype)                                   \
value cptr_ ## type ##_set( value ptr, value i, value v ) {     \
    val_check_kind( ptr, k_cptr_ ## type );                     \
    VAL_CHECK( i, int );                                        \
    VAL_CHECK( v, nekotype );                                   \
    type *cptr = (type*)val_data( ptr );                        \
    cptr[(int)val_number(i)] = val_ ## nekotype ( v );          \
    return v;                                                   \
}                                                               \
DEFINE_PRIM( cptr_ ## type ##_set, 3 );

#define CPTR_GETTER(type,nekotype) \
value cptr_ ## type ##_get( value ptr, value i ) {              \
    val_check_kind( ptr, k_cptr_ ## type );                     \
    VAL_CHECK( i, int );                                        \
    type *cptr = (type*)val_data( ptr );                        \
    return alloc_ ## nekotype ( cptr[(int)val_number(i)] );   \
}                                                               \
DEFINE_PRIM( cptr_ ## type ##_get, 2 );

#define CPTR(type,nekotype) \
    DEFINE_KIND( k_cptr_ ## type ); \
    CPTR_ALLOC(type) \
    CPTR_SETTER(type,nekotype) \
    CPTR_GETTER(type,nekotype) \
    
CPTR(int,int);

