/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.geom;

import xinf.geom.Types;

class Concatenate implements Transform {
	var a:Transform;
	var b:Transform;

	public function new( a:Transform, b:Transform ) {
		this.a = a;
		this.b = b;
	}
	
	public function getTranslation() :TPoint {
		return new Matrix( getMatrix() ).getTranslation();
	}
	public function getScale() :TPoint {
		return new Matrix( getMatrix() ).getScale();
	}
	public function getMatrix() :TMatrix {
		var m = new Matrix( a.getMatrix() ).multiply( b.getMatrix() );
		return m;
	}
	
	public function apply( p:TPoint ) :TPoint {
		return new Matrix( getMatrix() ).apply(p);
	}
	public function applyInverse( p:TPoint ) :TPoint {
		return new Matrix( getMatrix() ).applyInverse(p);
	}

	public function interpolateWith( p:Transform, f:Float ) :Transform {
		return this;
	}

	public function distanceTo( p:Transform ) :Float {
		return 1.;
	}

	public function isIdentity() :Bool {
		return( a.isIdentity() && b.isIdentity() );
	}
	
	public function add( t:Transform ) :Transform {
		if( t.isIdentity() ) return this;
		else return( new TransformList([ a, b, t ]) );
	}

	public function toString() {
		return("concat( "+a+", "+b+" )");
	}
}
