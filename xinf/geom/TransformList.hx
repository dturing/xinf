/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.geom;

import xinf.geom.Types;

class TransformList implements Transform {
	var l:List<Transform>;
	var m:Matrix;

	public function new( ?list:Iterable<Transform> ) {
		l = new List<Transform>();
		if( list!=null )
			for( item in list ) l.add(item);
		cache();
	}
	
	function cache() {
		m = new Matrix();
		for( item in l ) {
			m = m.multiply( item.getMatrix() );
		}
	}
	
	public function getTranslation() :TPoint {
		return m.getTranslation();
	}
	public function getScale() :TPoint {
		return m.getScale();
	}
	public function getMatrix() :TMatrix {
		return m;
	}
	
	public function apply( p:TPoint ) :TPoint {
		return m.apply(p);
	}
	public function applyInverse( p:TPoint ) :TPoint {
		return m.applyInverse(p);
	}

	public function interpolateWith( p:Transform, f:Float ) :Transform {
		return this;
	}

	public function distanceTo( p:Transform ) :Float {
		return 1.;
	}

	public function isIdentity() :Bool {
		for( item in l ) {
			if( !item.isIdentity() ) return false;
		}
		return true;
	}
	
	public function add( t:Transform ) :Transform {
		if( t.isIdentity() ) return this;
		var l2 = Lambda.list(l);
		l2.add(t);
		return new TransformList( l2 );
	}

	public function toString() {
		var r = "(*";
		for( item in l ) {
			r+=","+item;
		}
		r+=")";
		return r;
	}
}
