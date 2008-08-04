/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.anim.type;

import xinf.geom.Types;

private class SimpleRoot {
	inline static var TOL = 0.0000001;
 	inline static var MAX_ITER = 50;
 	
 	var __iter:Int;
 	
 	public function new() {
 		__iter=0;
 	}
 	
	public function findRoot( _x0:Float, _x2:Float, x:Float, _f:Float->Float->Float ) :Float {
		var _eps = TOL;
		var _imax = MAX_ITER;
		
		var x0:Float;
		var x1:Float = 0.;
		var x2:Float;
		var y0:Float;
		var y1:Float;
		var y2:Float;
		var b:Float;
		var c:Float;
		var y10:Float;
		var y20:Float;
		var y21:Float;
		var xm:Float;
		var ym:Float;
		var temp:Float;

		var xmlast:Float = _x0;
		y0 = _f(_x0,x);

		if( y0 == 0.0 ) return _x0;

		y2 = _f(_x2,x);
		if( y2 == 0.0 ) return _x2;

		if( y2*y0 > 0.0 ) {
			trace("Invalid interval - no sign change - no root");
			return _x0;
		}

		__iter = 0;
		x0     = _x0;
		x2     = _x2;
		for( i in 0..._imax ) {
			__iter++;

			x1 = 0.5 * (x2 + x0);
			y1 = _f(x1,x);
			if( y1 == 0.0 ) return x1;
			  
			if( Math.abs(x1 - x0) < _eps) return x1;
			  
			if( y1*y0 > 0.0 ) {
				temp = x0;
				x0   = x2;
				x2   = temp;
				temp = y0;
				y0   = y2;
				y2   = temp;
			}

			y10 = y1 - y0;
			y21 = y2 - y1;
			y20 = y2 - y0;
			if( y2*y20 < 2.0*y1*y10 ) {
				x2 = x1;
				y2 = y1;
			} else {
				b  = (x1  - x0 ) / y10;   
				c  = (y10 - y21) / (y21 * y20); 
				xm = x0 - b*y0*(1.0 - c*y1);
				ym = _f(xm,x);
				if( ym == 0.0 ) return xm;

				if( Math.abs(xm - xmlast) < _eps ) return xm;

				xmlast = xm;
				if( ym*y0 < 0.0 ) {
					x2 = xm;
					y2 = ym;
				} else {
					x0 = xm;
					y0 = ym;
					x2 = x1;
					y2 = y1;
				}
			}
		}

		trace( "Failed to converge after maximum iterations ("+__iter+")" );
		return x1;
	}
}

class KeySpline {

	// p0 is (0,0); p3 is (1,1)
	var p1:TPoint;
	var p2:TPoint;
	
	var c1x:Float;
	var c2x:Float;
	var c3x:Float;
	var c1y:Float;
	var c2y:Float;
	var c3y:Float;
	
	public function new( x1:Float, y1:Float, x2:Float, y2:Float ) {
		p1 = { x:x1, y:y1 };
		p2 = { x:x2, y:y2 };
		
		c1x = 3.*p1.x;
		c2x = 3.*(p2.x-p1.x)-c1x;
		c3x = 1-c1x-c2x;
		
		c1y = 3.*p1.y;
		c2y = 3.*(p2.y-p1.y)-c1y;
		c3y = 1-c1y-c2y;
	}
	
	function f( t:Float, x:Float ) :Float {
		return( t*(c1x + t*(c2x + t*c3x))-x );
	}
	
	public function yAtX( x:Float ) :Float {
		var r = tAtX(x);
		if( r.length==0 ) return -1;
		return yAtT(r[0]);
	}
	
	public function yAtT( t:Float ) :Float {
		return( t*(c1y + t*(c2y + t*c3y)) );
	}
	
	public function tAtX( x:Float ) :Array<Float> {
		if( Math.isNaN(x) || x<0. || x>1. ) return [];
		
		var __root = new SimpleRoot();
		var t0 = __root.findRoot( 0, 1, x, f );
		var eval = Math.abs(f(t0,x));
		if( eval>0.0000001 ) return [];
		
		var result = new Array<Float>();
		if( t0<=1 ) result.push(t0);
		
		var a = c3x;
		var b = t0*a + c2x;
		var c = t0*b + c1x;
		
		var d = b*b + 4*a*c;
		if( d<0 ) return result;
		
		d = Math.sqrt(d);
		a = 1/(a+a);
		var t1 = (d-b)*a;
		var t2 = (-b-d)*a;
		
		if( t1>=0 && t1<=1 ) result.push(t1);
		if( t2>=0 && t2<=1 ) result.push(t2);	
		
		return result;
	}
}

