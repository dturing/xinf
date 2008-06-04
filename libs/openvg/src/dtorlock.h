#ifndef _DTOR_LOCK
#define _DTOR_LOCK

typedef struct _clock _clock;

_clock *context_lock_new();
void context_lock( _clock *l );
void context_release( _clock *l );
void context_lock_delete( _clock *l );

extern _clock *VGPath_dtorLock;
extern _clock *VGPaint_dtorLock;

#endif
