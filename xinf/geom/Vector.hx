/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.geom;

import xinf.geom.Types;
import xinf.geom.Matrix;

class Vector {
	public var p1 : TPoint;
	public var p2 : TPoint;
	public var length(getLength,null) : Float;
	public var width(getWidth,null) : Float;
	public var height(getHeight,null) : Float;
	public var middle(getMiddle,null) : TPoint;

	public function new( sp : TPoint, ep : TPoint) {
		p1 = sp;
		p2 = ep;
	}

	/**
		Return the radians of a circle of the vector in
		screen coordinates mapped to a circle with 0 rad
		horizontal to the right.
		Range is 0..2*Math.PI
	*/
	public function displayRadians() : Float {
		var a = Math.atan2(p2.y-p1.y, p2.x-p1.x);
		if(a >= 0)
			return a;
		return (2*Math.PI) + a;
	}

	function getWidth() : Float {
		return Math.abs(p1.x - p2.x);
	}
	function getHeight() : Float {
		return Math.abs(p1.y - p2.y);
	}
	function getLength() : Float {
		return( Math.sqrt( Math.pow(width,2) + Math.pow(height,2) ) );
	}
	public function getMiddle() : TPoint {
		return {x: ((p1.x + p2.x) / 2), y: ((p1.y + p2.y) / 2)};
	}
	/**
		Returns the point along the vector where the distance from the starting
		point is a ratio of the vector length. The ratio is 0..1 for 0% to 100%,
		but can	also extend outside the vector. getPoint(2.0) of a vector defined
		as {0,0}->{10,0} will return {20,0}
	**/
	public function getRatioPoint(ratio:Float) : TPoint
	{
		return {
			x:(p1.x + ((p2.x - p1.x) * ratio)),
			y:(p1.y + ((p2.y - p1.y) * ratio))
		};
	}

	/**
		Return a new vector where the starting (p1) and ending (p2) points are reversed.
	**/
	public function reverse() : Vector {
		return new Vector(p2,p1);
	}

	/**
		Checks if one vector's start and end points equal another.
	**/
	public function equal(v : Vector) : Bool {
		if(p1.x == v.p1.x && p2.x == v.p2.x &&
			p1.y == v.p1.y && p2.y == v.p2.y)
			return true;
		return false;
	}

	/**
		Transform vector by given matrix
	**/
	public function transform(m : Matrix) :Void {
		p1 = m.apply(p1);
		p2 = m.apply(p2);
	}

	public function toString() : String {
		return "("+Std.string(p1)+", "+Std.string(p2)+")";
	}

}