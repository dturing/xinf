/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.anim.type;

class KeySpline extends xinf.anim.tools.Spline {

	public function new( x1:Float, y1:Float, x2:Float, y2:Float ) {
		super( {x:0.,y:0.}, {x:x1, y:y1}, {x:x2, y:y2}, {x:1.,y:1.} );
	}

}

