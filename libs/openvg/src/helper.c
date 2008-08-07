#include "helper.h"
#include <neko.h>
#include <vg/openvg.h>

mt_lock *VGPath_dtorLock;
mt_lock *VGPaint_dtorLock;

field f_l;
field f_t;
field f_r;
field f_b;

DEFINE_ENTRY_POINT(OpenVGNDLL_Init);
void OpenVGNDLL_Init() {
	VGPath_dtorLock = alloc_lock();
	VGPaint_dtorLock = alloc_lock();
	
	f_l = val_id("l");
	f_t = val_id("t");
	f_r = val_id("r");
	f_b = val_id("b");
}

value vgGetPathBounds( VGPath path ) {
	VGfloat x,y,width,height;
	vgPathBounds( path,&x,&y,&width,&height );
	
	value r = alloc_object(NULL);
	alloc_field( r, f_l, alloc_float(x) );
	alloc_field( r, f_t, alloc_float(y) );
	alloc_field( r, f_r, alloc_float(x+width) );
	alloc_field( r, f_b, alloc_float(y+height) );
	return r;
}

