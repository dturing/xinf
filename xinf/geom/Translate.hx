/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.geom;

import xinf.geom.Types;

class Translate implements Transform {
	var x:Float;
	var y:Float;
	
	public function new( x:Float, y:Float ) {
		this.x = x;
		this.y = y;
	}
	
	public function getTranslation() {
		return { x:x, y:y };
	}
	public function getScale() {
		return { x:.0, y:.0 };
	}
	public function getMatrix() {
		return { a:1., b:0., c:0., d:1., tx:x, ty:y };
	}
	
	public function apply( p:TPoint ) :TPoint {
		return { x:p.x+x, y:p.y+y };
	}
	public function applyInverse( p:TPoint ) :TPoint {
		return { x:p.x-x, y:p.y-y };
	}

	public function interpolateWith( p:Transform, f:Float ) :Transform {
		if( Std.is(p,Identity) ) return new Translate(x*(1-f),y*(1-f));
		if( !Std.is(p,Translate) ) return this;
		var q:Translate = cast(p);
		return( new Translate( x + ((q.x-x)*f),
							   y + ((q.y-y)*f) ) );
	}

	public function distanceTo( p:Transform ) :Float {
		if( Std.is(p,Identity) || !Std.is(p,Translate) ) 
			return Math.sqrt( (x*x)+(y*y) );
		var q:Translate = cast(p);
		return( Math.sqrt( Math.pow(q.x-x,2)+Math.pow(q.y-y,2) ) );
	}

	public function isIdentity() :Bool {
		return( x==0. && y==0. );
	}
	
	public function add( t:Transform ) :Transform {
		if( t.isIdentity() ) return this;
		if( Std.is(t,Translate) ) {
			return new Translate( x+untyped t.x, y+untyped t.y );
		}
		return new Concatenate(this,t);
	}

	public function toString() {
		return("translate("+x+","+y+")");
	}
}
