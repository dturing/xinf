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

#ifdef __cplusplus
}
#endif

#endif
