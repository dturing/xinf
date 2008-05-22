/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.anim.tools;

import xinf.geom.Types;

class Spline {
	var A:Float;
	var B:Float;
	var C:Float;
	var D:Float;
	var E:Float;
	var F:Float;
	var G:Float;
	var H:Float;
	
	public function new( p0:TPoint, p1:TPoint, p2:TPoint, p3:TPoint ) {
		A = p3.x-(3*p2.x)+(3*p1.x)-p0.x;
		B = (3*p2.x)-(6*p1.x)+(3*p0.x);
		C = (3*p1.x)-(3*p0.x);
		D = p0.x;
		E = p3.y-(3*p2.y)+(3*p1.y)-p0.y;
		F = (3*p2.y)-(6*p1.y)+(3*p0.y);
		G = (3*p1.y)-(3*p0.y);
		H = p0.y;
	}
	
	public function at( t:Float ) :TPoint {
		return({
			x: (((((A*t)+B)*t) + C)*t)+D,
			y: (((((E*t)+F)*t) + G)*t)+H
		});
	}
}
