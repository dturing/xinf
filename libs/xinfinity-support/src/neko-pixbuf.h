#ifndef NEKO_PIXBUF_H
#define NEKO_PIXBUF_H

#include <gdk-pixbuf/gdk-pixbuf.h>
#include <neko.h>

GdkPixbuf* gdk_pixbuf_new_from_compressed_data( value _data );
GdkPixbuf* gdk_pixbuf_new_from_rgb( value _data, int width, int height, int hasAlpha );
value gdk_pixbuf_copy_pixels( GdkPixbuf *pixbuf );
value gdk_pixbuf_encode( GdkPixbuf *pixbuf, const char *format );

#endif
