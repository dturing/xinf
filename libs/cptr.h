#include <neko.h>

#ifndef __CPTR_H
#define __CPTR_H

#ifdef __cplusplus
extern "C" {
#endif

extern vkind k_cptr;

/* convenience macros */

#define VAL_Int(v) ((int)val_number(v))
#define VAL_Float(v) ((float)val_number(v))
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
#define CHECK_Array(v) CHECK(v,array)
#define CHECK_Dynamic(v) check_failed(__FUNCTION__,__FILE__,__LINE__,v)

void check_failed( const char *function, const char *file, int line, value given );
value cptr_wrap( void *ptr, int size );

#ifdef __cplusplus
}
#endif

#endif
