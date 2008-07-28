#include "dtorlock.h"
#include <neko.h>

mt_lock *VGPath_dtorLock;
mt_lock *VGPaint_dtorLock;

void VGPath_dtorLock_init() {
	VGPath_dtorLock = alloc_lock();
	VGPaint_dtorLock = alloc_lock();
}
DEFINE_ENTRY_POINT(VGPath_dtorLock_init);
