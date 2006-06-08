#include <neko.h>

#ifndef __CPTR_H
#define __CPTR_H

#ifdef __cplusplus
extern "C" {
#endif

extern vkind k_void_p_p;

/*
extern vkind k_void_p;
extern vkind k_float_p;
extern vkind k_double_p;
extern vkind k_int_p;
extern vkind k_unsigned_int_p;
extern vkind k_short_p;
extern vkind k_unsigned_short_p;
extern vkind k_char_p;
extern vkind k_unsigned_char_p;
*/

#define VAL_Int(v) ((int)val_number(v))
#define VAL_Float(v) ((float)val_number(v))
#define VAL_String(v) val_string(v)    // HaXe strings direct?
#define VAL_Dynamic(v) 0

#define ALLOC_Int(v) (value)alloc_int(v)
#define ALLOC_Float(v) (value)alloc_float(v)
#define ALLOC_String(v) (value)alloc_string(v)
#define ALLOC_Bool(v) (value)alloc_bool(v)
#define ALLOC_Dynamic(v) val_null
#define ALLOC_Void(v) val_null

void check_failed( const char *function, const char *file, int line, value given );
void kind_check_failed( const char *function, const char *file, int line, value given, const char *kind );

#define CHECK(v,type) if( !val_is_ ## type (v) ) { check_failed(__FUNCTION__,__FILE__,__LINE__,v); return NULL; }
#define CHECK_NUMBER(v,type) if( !(val_is_int(v) || val_is_float(v)) ) { check_failed(__FUNCTION__,__FILE__,__LINE__,v); return NULL; }
#define CHECK_Int(v) CHECK_NUMBER(v,int)
#define CHECK_Float(v) CHECK_NUMBER(v,float)
#define CHECK_String(v) CHECK(v,string)
#define CHECK_Array(v) CHECK(v,array)
#define CHECK_Dynamic(v) check_failed(__FUNCTION__,__FILE__,__LINE__,v)


/* handle kinds */
#define CHECK_KIND(v,kind) if( !val_is_abstract(v) || !val_is_kind(v,kind) ) { \
                                    kind_check_failed(__FUNCTION__,__FILE__,__LINE__,v,#kind); }
#define VAL_KIND(v,kind) val_data(v)
#define ALLOC_KIND(v,kind) (alloc_abstract(kind,(void*)v))


/* nu-style cptr */
extern vkind k_cptr;

#define CTPR_UNDEFINED      0
#define CPTR_void           1
#define CPTR_void_p         2
#define CPTR_float          3
#define CPTR_double         4
#define CPTR_int            5
#define CPTR_unsigned_int   6
#define CPTR_short          7
#define CPTR_unsigned_short 8
#define CPTR_char           9
#define CPTR_unsigned_char  10
#define CPTR_signed_char    11
#define CPTR_const_char     12

struct _cptr {
    unsigned char kind;
    unsigned int length;
    void *ptr;
};
typedef struct _cptr cptr;

#define VAL_CPTR(v) ((cptr*)val_data(v))
#define CHECK_CPTR_KIND( v, k ) \
    if( !val_is_abstract(v) || !val_is_kind(v,k_cptr) || val_data(v) == NULL || VAL_CPTR(v)->kind != k ) { \
        kind_check_failed( __FUNCTION__,__FILE__,__LINE__,v,#k); }

value alloc_cptr( void *ptr, unsigned char kind, int length );

#ifdef __cplusplus
}
#endif

#endif
