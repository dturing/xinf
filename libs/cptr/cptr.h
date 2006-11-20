#include <neko.h>

#ifndef __CPTR_H
#define __CPTR_H

#ifdef __cplusplus
extern "C" {
#endif

extern vkind k_cptr;

typedef struct _cptr {
    int size;
    void *ptr;
} cptr;
#define CHECK_CPTR(cp) if( !val_is_abstract(cp) || !val_is_kind(cp,k_cptr) ) { val_throw(alloc_string("invalid cptr")); }
#define CPTR_SIZE(cp) (((cptr*)val_data(cp))->size)
#define CPTR_PTR(cp,type) ((type*)(((cptr*)val_data(cp))->ptr))

/* wrapping */

#define CPTR_LOCAL_HELPERS \
void cptr_finalize( value cp ) { \
    CHECK_CPTR(cp); \
	cptr *p = val_data( cp ); \
    if( p->ptr ) free(p->ptr); \
    if( p ) free(p); \
} \
value cptr_wrap( void *ptr, int size ) { \
    cptr *p = (cptr*)malloc( sizeof(cptr) ); \
    p->size = size; \
    p->ptr = ptr; \
    value r = alloc_abstract( k_cptr, p ); \
    val_gc( r, cptr_finalize ); \
    return(r); \
} \
value cptr_wrap_foreign( void *ptr, int size ) { \
    cptr *p = (cptr*)malloc( sizeof(cptr) ); \
    p->size = size; \
    p->ptr = ptr; \
    value r = alloc_abstract( k_cptr, p ); \
    return(r); \
}

/* convenience macros */

#define VAL_Int(v) ((int)val_number(v))
#define VAL_Float(v) ((float)val_number(v))
#define VAL_Bool(v) ((float)val_bool(v))
#define VAL_String(v) val_string(v)    // TODO HaXe strings direct?
#define VAL_Dynamic(v) 0

#define ALLOC_Int(v) (value)alloc_int(v)
#define ALLOC_Float(v) (value)alloc_float(v)
#define ALLOC_String(v) (value)alloc_string(v)
#define ALLOC_Bool(v) (value)alloc_bool(v)
#define ALLOC_Dynamic(v) val_null
#define ALLOC_Void(v) val_null

#define CHECK(v,type) if( !val_is_ ## type (v) ) { check_failed(__FUNCTION__,__FILE__,__LINE__,v); return NULL; }
#define CHECK_NUMBER(v,type) if( !(val_is_int(v) || val_is_float(v)) ) { check_failed(__FUNCTION__,__FILE__,__LINE__,v); return NULL; }
#define CHECK_Int(v) CHECK_NUMBER(v,int)
#define CHECK_Float(v) CHECK_NUMBER(v,float)
#define CHECK_String(v) CHECK(v,string)
#define CHECK_Bool(v) CHECK(v,bool)
#define CHECK_Array(v) CHECK(v,array)
#define CHECK_Dynamic(v) check_failed(__FUNCTION__,__FILE__,__LINE__,v)

void check_failed( const char *function, const char *file, int line, value given );
value cptr_wrap( void *ptr, int size );
value cptr_wrap_foreign( void *ptr, int size );

/* handle kinds - convenience only, not needed for cptr */
#define CHECK_KIND(v,kind) if( !val_is_abstract(v) || !val_is_kind(v,kind) ) { \
                                    kind_check_failed(__FUNCTION__,__FILE__,__LINE__,v,#kind); }
#define VAL_KIND(v,kind) val_data(v)
#define ALLOC_KIND(v,kind) (alloc_abstract(kind,(void*)v))
void kind_check_failed( const char *function, const char *file, int line, value given, const char *kind );

#ifdef __cplusplus
}
#endif

#endif
