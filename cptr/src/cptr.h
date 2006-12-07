#ifndef __CPTR_H
#define __CPTR_H

#include <neko/neko.h>
#include <stdlib.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct _cptr {
    int size;
    void *ptr;
	void (*free)(void*);
} cptr;

#define val_cptr_size(cp) (((cptr*)val_data(cp))->size)
#define val_cptr(cp,type) ((type*)(((cptr*)val_data(cp))->ptr))

#define CPTR_LOCAL_HELPERS \
\
value check_cptr( value cp, int size ) { \
	vkind k_cptr = kind_import("cptr"); \
	val_check_kind( cp, k_cptr ); \
	if( size>0 && val_cptr_size(cp) < size ) val_throw( alloc_string("cptr overflow") ); \
	return cp; \
}
\
void cptr_finalize( value cp ) { \
    check_cptr(cp,0); \
	cptr *p = val_data( cp ); \
    if( p->ptr && p->free ) p->free(p->ptr); \
    if( p ) free(p); \
} \
\
value alloc_cptr( void *ptr, int size, void (*free_f)(void*) ) { \
	vkind k_cptr = kind_import("cptr"); \
	cptr *cp = (cptr*)malloc( sizeof(cptr) ); \
	cp->ptr=ptr; cp->size=size; cp->free=free_f; \
	if( cp->free==NULL ) cp->free = free; \
	value r = alloc_abstract( k_cptr, cp ); \
	val_gc( r, cptr_finalize ); \
	return r; \
} \


#ifdef __cplusplus
}
#endif

#endif
