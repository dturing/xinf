/* 
   xinf is not flash.
   Copyright (c) 2006, Daniel Fischer.
 
   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.
																			
   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU		
   Lesser General Public License or the LICENSE file for more details.
*/

package xinf.geometry;

import xinf.erno.Coord2d;

// y = a + bx
typedef Line = {
	a:Float,
	b:Float
}

typedef Segment = {
	a:Coord2d,
	b:Coord2d
}

enum IntersectionResult {
	None;
	Coincident;
	Parallel;
	Intersection( x:Float, y:Float );
	TheoreticalIntersection( x:Float, y:Float );
}

class Geometry {
	public static function pointDistance( a:Coord2d, b:Coord2d ) :Float {
		var x = b.x-a.x;
		var y = b.y-a.y;
		return Math.sqrt( (x*x)+(y*y) );
	}
	
	public static function distance2d( a:Coord2d, b:Coord2d ) :Coord2d {
		return { x:b.x-a.x,
				 y:b.y-a.y };
	}

	public static function center2d( a:Coord2d, b:Coord2d ) :Coord2d {
		return { x:a.x + ((b.x-a.x)/2),
				 y:a.y + ((b.y-a.y)/2) };
	}
	
	public static function degreeFromRadians( rad:Float ) :Float {
		var deg = 180*(rad/Math.PI);
		while( deg>360. ) deg-=360.;
		while( deg<0. ) deg+=360.;
		if( deg>180 ) deg=360-deg;
		return deg;
	}
	
	public static function radiansFromDegree( deg:Float ) :Float {
		while( deg>360. ) deg-=360.;
		while( deg<0. ) deg+=360.;
		return( (deg/180)*Math.PI );
	}
	
	public static function lineFromSegment( s:Segment ) :Line {
		if( s.b.x == s.a.x ) return { b:null, a:s.a.x };
		var b = (s.b.y-s.a.y)/(s.b.x-s.a.x);
		return {
			b:b,
			a:s.a.y-(b*s.a.x)
			}
	}

	public static function lineFromPointAngle( p:Coord2d, angle:Float ) :Line {
		return lineFromSegment( { a:p, b:{ 
			x:p.x+(Math.cos(angle)*10), 
			y:p.y+(Math.sin(angle)*10) } } );
	}
	
	public static function intersectLines( l1:Line, l2:Line ) :IntersectionResult {
		if( l1.b == l2.b ) return Parallel;
		if( l1.b == null ) {
			return TheoreticalIntersection( l1.a, l2.a + (l2.b*l1.a) );
		} else if( l2.b == null ) {
			return TheoreticalIntersection( l2.a, l1.a + (l1.b*l2.a) );
		}
		var x = -(l1.a-l2.a)/(l1.b-l2.b);
		var y = l1.a+(l1.b*x);
		return TheoreticalIntersection( x, y );
	}
	
	public static function intersectSegments( l1:Segment, l2:Segment ) :IntersectionResult {
		var i = intersectLines( lineFromSegment(l1), lineFromSegment(l2) );
		trace("Intersect: "+i );
		switch( i ) {
			case TheoreticalIntersection(x,y):
				if( ((l1.a.x-x)*(x-l1.b.x)) >= 0 
				 && ((l2.a.x-x)*(x-l2.b.x)) >= 0
				 && ((l1.a.y-y)*(y-l1.b.y)) >= 0
				 && ((l2.a.y-y)*(y-l2.b.y)) >= 0 )
					return Intersection(x,y);
			default:
		}
		return i;
	}

	public static function getLineAngle( l:Line ) :Float {
		return( Math.atan( 1/l.b ) );
	}
	
	public static function getParallel( l0:Line, distance:Float ) :Line {
		var y = Math.cos( getLineAngle(l0) ) * distance;
		return { a:l0.a+y, b:l0.b }
	}
	
	public static function reflect( beam:Line, mirror:Line ) :{ line:Line, point:Coord2d } {
		var i = intersectLines( beam, mirror );
		var a:Coord2d;
		switch( i ) {
			case TheoreticalIntersection(x,y):
				a = { x:x, y:y };
			default:
				return null;
		}
		
		var beam_angle = if( beam.b==null ) Math.PI/2 else Math.atan( beam.b );
		var mirror_angle = if( mirror.b==null ) Math.PI/2 else Math.atan( mirror.b );
		
		var angle = beam_angle + (2*(mirror_angle-beam_angle));
		var r:Line = Geometry.lineFromPointAngle( a, angle );
		return { line:r, point:a };
	}
}

