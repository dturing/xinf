#ifndef _DTOR_LOCK
#define _DTOR_LOCK

#import <neko.h>
#import <vg/openvg.h>

extern mt_lock *VGPath_dtorLock;
extern mt_lock *VGPaint_dtorLock;

value vgGetPathBounds( VGPath path );

#endif
