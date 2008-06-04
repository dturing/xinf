#include "dtorlock.h"
#include <neko.h>

_clock *VGPath_dtorLock;
_clock *VGPaint_dtorLock;

void VGPath_dtorLock_init() {
	VGPath_dtorLock = context_lock_new();
	VGPaint_dtorLock = context_lock_new();
}
DEFINE_ENTRY_POINT(VGPath_dtorLock_init);
