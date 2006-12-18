#include <gdk-pixbuf/gdk-pixbuf.h>
#include "neko-pixbuf.h"
#include <neko/neko.h>

#include <stdlib.h>

typedef struct _cptr {
    int size;
    void *ptr;
	void (*free)(void*);
} cptr;

#define val_cptr_size(cp) (((cptr*)val_data(cp))->size)
#define val_cptr(cp,type) ((type*)(((cptr*)val_data(cp))->ptr))
#define val_cptr_check_size(cp,type,s) if( val_cptr_size(cp)<s*sizeof(type) ) failure("cptr " #cp " is not large enough to hold " #s " " #type "s" );

void cptr_finalize( value cp ) {
    if( !val_is_abstract(cp) || !val_is_kind(cp,kind_import("cptr")) ) return;
	cptr *p = val_data( cp );
    if( p->ptr && p->free ) p->free(p->ptr);
    if( p ) free(p);
}

value alloc_cptr( void *ptr, int size, void (*free_f)(void*) ) {
	vkind k_cptr = kind_import("cptr");
	cptr *cp = (cptr*)malloc( sizeof(cptr) );
	cp->ptr=ptr; cp->size=size; cp->free=free_f;
	if( cp->free==NULL ) cp->free = free;
	value r = alloc_abstract( k_cptr, cp );
	val_gc( r, cptr_finalize );
	return r;
} 

GdkPixbuf* gdk_pixbuf_new_from_compressed_data( value _data ) {
	g_type_init();
	
	if( val_is_object(_data) ) _data = val_field( _data, val_id("__s") );
	val_check(_data,string);
	const guchar *data = val_string(_data);
	int length = val_strlen(_data);
	if( length==0 ) val_throw( alloc_string("data length is zero") );
		
	GdkPixbufLoader *loader = gdk_pixbuf_loader_new();
	GError *err = NULL;
	gdk_pixbuf_loader_write( loader, data, length, &err );
	gdk_pixbuf_loader_close( loader, &err );
	if( err!=NULL ) {
		val_throw( alloc_string("unable to decompress image") );
	}
	
	GdkPixbuf *pixbuf = gdk_pixbuf_loader_get_pixbuf(loader);
	if( pixbuf==NULL ) {
		val_throw( alloc_string("unable to decompress image") );
	}

    g_object_ref( pixbuf );
	g_object_unref( loader );
	return pixbuf;
}

value gdk_pixbuf_copy_pixels( GdkPixbuf *pixbuf ) {
	int w = gdk_pixbuf_get_width(pixbuf);
	int h = gdk_pixbuf_get_height(pixbuf);
	int bpp = gdk_pixbuf_get_has_alpha(pixbuf)?4:3;
	
	unsigned char *data = malloc(w*h*bpp);
	memset( data, 0xff, w*h*bpp );
	memcpy( data, gdk_pixbuf_get_pixels(pixbuf), w*h*bpp );
    
	return alloc_cptr( data, w*h*bpp, free );
}
