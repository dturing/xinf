/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.geom;

import xinf.geom.Types;

class Scale implements Transform {
	var x:Float;
	var y:Float;
	var cx:Float;
	var cy:Float;
	
	public function new( x:Float, y:Float, ?cx:Float=0., ?cy:Float=0. ) {
		this.x = x;
		this.y = y;
		this.cx = cx;
		this.cy = cy;
	}
	
	// FIXME: these are sh*t, needed at all? if not, remove! (js?)
	public function getTranslation() :TPoint {
		return { x:0., y:0. };
	}
	public function getScale() :TPoint {
		return { x:x, y:y };
	}
	
	public function getMatrix() {
		// FIXME. do that more efficient. tx=-cx*x? sth like it?
		return untyped new Matrix().translate(-cx,-cy).scale(x,y).translate(cx,cy);
//		return { a:x, b:0., c:0., d:y, tx:0., ty:0. };
	}
	
	public function apply( p:TPoint ) :TPoint {
		return new Matrix( getMatrix() ).apply(p);
	}
	public function applyInverse( p:TPoint ) :TPoint {
		return new Matrix( getMatrix() ).applyInverse(p);
	}

	public function interpolateWith( p:Transform, f:Float ) :Transform {
		if( Std.is(p,Identity) ) return new Scale(x*(1-f),y*(1-f));
		if( !Std.is(p,Scale) ) return this;
		var q:Scale = cast(p);
		return( new Scale( x + ((q.x-x)*f),
						   y + ((q.y-y)*f),
						   cx + ((q.cx-cx)*f),
						   cy + ((q.cy-cy)*f)
						    ) );
	}

	public function distanceTo( p:Transform ) :Float {
		if( Std.is(p,Identity) || !Std.is(p,Scale) ) return Math.abs(x)+Math.abs(y);
		var q:Scale = cast(p);
		return( Math.abs(q.x-x)+Math.abs(q.y-y) );
	}

	public function isIdentity() :Bool {
		return( x==1. && y==1. );
	}
	
	public function add( t:Transform ) :Transform {
		if( t.isIdentity() ) return this;
		if( Std.is(t,Scale) ) {
			return new Scale( x*untyped t.x, y*untyped t.y, (cx+untyped t.cx)/2, (cy+untyped t.cy)/2 );
		}
		return new Concatenate(this,t);
	}

	public function toString() {
		return("scale("+x+","+y+")");
	}
}
