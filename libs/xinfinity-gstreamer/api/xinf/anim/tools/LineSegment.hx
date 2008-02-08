/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.anim.tools;

import xinf.geom.Types;

class LineSegment {
	public var a:TPoint;
	public var b:TPoint;
	
	public function new( a:TPoint, b:TPoint ) {
		this.a=a; this.b=b;
	}
	public function length() {
		return Math.sqrt( Math.pow(b.x-a.x,2)+Math.pow(b.y-a.y,2) );
	}
	public function at( f:Float ) {
		return { x: a.x+((b.x-a.x)*f), 
				 y: a.y+((b.y-a.y)*f) };
	}
}
