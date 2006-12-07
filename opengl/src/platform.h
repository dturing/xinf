#ifndef __PLATFORM_H
#define __PLATFORM_H

#include <neko/neko.h>

typedef struct _GLDisplay GLDisplay;

GLDisplay* opengl_display_open( int x, int y, int width, int height );
void opengl_display_make_current( GLDisplay* dpy );
void opengl_display_swap( GLDisplay* dpy );
void opengl_display_close( GLDisplay* dpy );

void opengl_display_init();
int opengl_display_has_next_event( GLDisplay* dpy );
value opengl_display_get_next_event( GLDisplay* dpy );

#endif
