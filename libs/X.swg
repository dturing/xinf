%module X

%include <X11/Xdefs.h>

/*
%include <X11/Xlib.h>
%include <X11/Xutil.h>
%include <X11/extensions/Xdamage.h>
%include <X11/extensions/Xfixes.h>
*/

// XLib ///////////////////////////////////////////////////////////////

#define _Xconst
#define CurrentTime 0

typedef XID Window;
typedef XID Drawable;
typedef XID XserverRegion;

typedef struct _XDisplay Display;
typedef struct _XImage XImage;

typedef struct {
    short x, y;
    unsigned short width, height;
} XRectangle;

typedef struct {
	XExtData *ext_data;	/* hook for extension to hang data */
	struct _XDisplay *display;/* back pointer to display structure */
	Window root;		/* Root window id. */
	int width, height;	/* width and height of screen */
	int mwidth, mheight;	/* width and height of  in millimeters */
	int ndepths;		/* number of depths possible */
	Depth *depths;		/* list of allowable depths on the screen */
	int root_depth;		/* bits per pixel */
	Visual *root_visual;	/* root visual */
	GC default_gc;		/* GC for the root root visual */
	Colormap cmap;		/* default color map */
	unsigned long white_pixel;
	unsigned long black_pixel;	/* White and Black pixel values */
	int max_maps, min_maps;	/* max and min color maps */
	int backing_store;	/* Never, WhenMapped, Always */
	Bool save_unders;	
	long root_input_mask;	/* initial root input mask */
} Screen;

typedef struct _XEvent {
        int type;
} XEvent;

extern Display *XOpenDisplay (_Xconst char* display_name );
extern Screen *XDefaultScreenOfDisplay( Display* display );
extern int XDefaultScreen( Display*	display );
extern Screen *XScreenOfDisplay( Display* display, int screen_number );

extern int XFlush( Display *display );
extern int XSync( Display *display, Bool discard );
extern int XPending( Display *display );
extern int XNextEvent( Display *display, XEvent *event );

extern int XGrabServer( Display *display );
extern int XUnrabServer( Display *display );
extern XImage *XGetImage( Display *display, Drawable d, int x, int y, unsigned int width, unsigned int height, unsigned long plane_mask, int format );


// XDamage ///////////////////////////////////////////////////////////////

typedef XID Damage;
Bool XDamageQueryExtension (Display *dpy, int *event_basep, int *error_basep);
typedef struct {
    int type;			/* event base */
    unsigned long serial;
    Bool send_event;
    Display *display;
    Drawable drawable;
    Damage damage;
    int level;
    Bool more;			/* more events will be delivered immediately */
    Time timestamp;
    XRectangle area;
    XRectangle geometry;
} XDamageNotifyEvent;
#define XDamageReportRawRectangles	0
#define XDamageReportDeltaRectangles	1
#define XDamageReportBoundingBox	2
#define XDamageReportNonEmpty		3

Damage XDamageCreate (Display *dpy, Drawable drawable, int level);
void XDamageDestroy (Display *dpy, Damage damage);
void XDamageSubtract (Display *dpy, Damage damage, XserverRegion repair, XserverRegion parts);

// XTest ///////////////////////////////////////////////////////////////

extern int XTestFakeButtonEvent( Display *display, unsigned int button, Bool is_press, unsigned long delay );
extern int XTestFakeMotionEvent( Display *display, int screen_number, int x, int y, unsigned long delay );

%include "X.runtime"
