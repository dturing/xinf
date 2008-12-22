/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.geom;

import xinf.geom.Types;

class Rotate implements Transform {
	var a:Float;
	var cx:Float;
	var cy:Float;
	
	public function new( a:Float, ?cx:Float=0., ?cy:Float=0. ) {
		this.a = a;
		this.cx = cx;
		this.cy = cy;
	}
	
	public function getTranslation() {
		return { x:.0, y:.0 };
	}
	public function getScale() {
		return { x:.0, y:.0 };
	}
	public function getMatrix() {
		return untyped new Matrix().translate(-cx,-cy).rotate(a).translate(cx,cy);
		/*
		var co = Math.cos(a);
		var si = Math.sin(a);
		return { a:co, b:si, c:-si, d:co, tx:0., ty:0. };
		*/
	}
	
	public function apply( p:TPoint ) :TPoint {
		return new Matrix( getMatrix() ).apply(p);
	}
	public function applyInverse( p:TPoint ) :TPoint {
		return new Matrix( getMatrix() ).applyInverse(p);
	}

	public function interpolateWith( p:Transform, f:Float ) :Transform {
		if( Std.is(p,Identity) ) return new Rotate(a*(1-f),cx,cy);
		if( !Std.is(p,Rotate) ) return this;
		var q:Rotate = cast(p);
		return( new Rotate( a + ((q.a-a)*f), 	
						   cx + ((q.cx-cx)*f),
						   cy + ((q.cy-cy)*f)
							) );
	}

	public function distanceTo( p:Transform ) :Float {
		if( Std.is(p,Identity) || !Std.is(p,Rotate) ) 
			return Math.abs(a);
		var q:Rotate = cast(p);
		return( Math.abs(q.a-a) );
	}

	public function isIdentity() :Bool {
		return( a==0 || a%(2*Math.PI)==0 );
	}
	
	public function add( t:Transform ) :Transform {
		if( t.isIdentity() ) return this;
		if( Std.is(t,Rotate) ) {
			return new Rotate( a+untyped t.a );
		}
		return new Concatenate(this,t);
	}

	public function toString() {
		return("rotate("+(a*TransformParser.R2D)+")");
	}
}
