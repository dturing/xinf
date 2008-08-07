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


#include "sh/shPath.h"

/* freeware point-in-poly algorithm
   Copyright (c) 1995-1996 Galacticomm, Inc.
   http://www.visibone.com/inpoly/inpoly.c */
   
VGboolean vgPathHit(VGPath path, double xt, double yt)
{
	SHPath *p = (SHPath*)path;
	int npoints = p->vertices.size;
	
	SHVertex *v; 
	double xnew,ynew;
	double xold,yold;
	double x1,y1;
	double x2,y2;
	int i;
	int inside=0;

	if (npoints < 3) {
		return(0);
	}
	xold=p->vertices.items[npoints-1].point.x;
	yold=p->vertices.items[npoints-1].point.y;
	for (i=0 ; i < npoints ; i++) {
		xnew=p->vertices.items[i].point.x;
		ynew=p->vertices.items[i].point.y;
		
		if (xnew > xold) {
			x1=xold;
			x2=xnew;
			y1=yold;
			y2=ynew;
		}
		else {
			x1=xnew;
			x2=xold;
			y1=ynew;
			y2=yold;
		}
		if ((xnew < xt) == (xt <= xold)         /* edge "open" at left end */
			&& (yt-y1)*(x2-x1)
			< ((y2-y1)*(xt-x1)) ) {
			   inside=!inside;
		}
		xold=xnew;
		yold=ynew;
	}
	return(inside);
}

