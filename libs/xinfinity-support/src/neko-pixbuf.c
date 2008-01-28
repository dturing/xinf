#include <gdk-pixbuf/gdk-pixbuf.h>
#include <gdk-pixbuf/gdk-pixbuf-loader.h>
#include "neko-pixbuf.h"
#include <neko.h>

#include <stdlib.h>
#include <string.h>

GdkPixbuf* gdk_pixbuf_new_from_rgb( value _data, int width, int height, int hasAlpha ) {
	int bytesPerSample = hasAlpha ? 4 : 3;
	val_check(_data,string);
    if( val_strlen(_data)<sizeof(unsigned char)*width*height*bytesPerSample ) 
		val_throw(alloc_string("data to small to fit image"));
    return gdk_pixbuf_new_from_data( (const guchar*)val_string(_data), GDK_COLORSPACE_RGB,
        hasAlpha, 8, width, height, width, NULL, NULL );
}

GdkPixbuf* gdk_pixbuf_new_from_compressed_data( value _data ) {
	g_type_init();
	
	if( !val_is_string(_data) ) val_throw( alloc_string("data argument is not a string") );
	const guchar *data = (const guchar*)val_string(_data);
	int length = val_strlen(_data);
	if( length==0 ) val_throw( alloc_string("data length is zero") );
		
	printf("load pixmap from data len %i\n", length );
	GdkPixbufLoader *loader = gdk_pixbuf_loader_new();
    
	GError *err = NULL;
	
	while( length>0 ) {
		int l = 1024;
		if( length<l ) l=length;
		gdk_pixbuf_loader_write( loader, data, l, &err );
		if( err!=NULL ) {
			val_throw( alloc_string(err->message) );
		}
		length-=l;
		data+=l;
	}

	gdk_pixbuf_loader_close( loader, &err );
	if( err!=NULL ) {
		val_throw( alloc_string(err->message) );
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
	int stride = gdk_pixbuf_get_rowstride(pixbuf);
    
    unsigned char *src = gdk_pixbuf_get_pixels(pixbuf);
	return( copy_string( src, h*stride ) );
}
