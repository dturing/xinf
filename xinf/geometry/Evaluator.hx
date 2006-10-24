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

class Evaluator {
	public static function evaluateQuadratic( p0:Coord2d, c:Coord2d, p1:Coord2d, 
			steps:Int, vertexCallback:Coord2d->Void ) {
			
		var stepsize:Float = 1.0/steps;
		
		for( i in 0...steps ) {
			var t:Float = i * stepsize;
			vertexCallback( evaluateQuadraticStep( p0, c, p1, i*stepsize ) );
		}
	}
	
	public static function evaluateQuadraticStep( p0:Coord2d, c:Coord2d, p1:Coord2d, t:Float ) :Coord2d {
		return( 
			evaluateLinearStep( 
			evaluateLinearStep(p0,c,t),
			evaluateLinearStep(c,p1,t),
			t
			) );
	}
	
	public static function evaluateLinearStep( p0:Coord2d, p1:Coord2d, t:Float ) :Coord2d {
		var t1:Float = 1.0-t;
		return {
			x : t1*p0.x + t*p1.x,
			y : t1*p0.y + t*p1.y,
			};
	}
}
