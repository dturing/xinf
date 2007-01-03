#ifndef NEKO_PIXBUF_H
#define NEKO_PIXBUF_H

#include <gdk-pixbuf/gdk-pixbuf.h>
#include <neko/neko.h>

GdkPixbuf* gdk_pixbuf_new_from_compressed_data( value _data );
value gdk_pixbuf_copy_pixels( GdkPixbuf *pixbuf );

#endif