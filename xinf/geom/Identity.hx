/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.geom;

import xinf.geom.Types;

class Identity implements Transform {

    public function new() {
    }
    
    public function getTranslation() {
        return { x:.0, y:.0 };
    }
    public function getScale() {
        return { x:.0, y:.0 };
    }
    public function getMatrix() {
        return { a:1., b:0., c:0., d:1., tx:0., ty:0. };
    }
    
    public function apply( p:TPoint ) :TPoint {
        return p;
    }
    public function applyInverse( p:TPoint ) :TPoint {
        return p;
    }

	public function interpolateWith( p:Transform, f:Float ) :Transform {
		if( Std.is(p,Identity) ) return this;
		return p.interpolateWith( this, 1-f );
	}

    public function toString() {
        return("identity");
    }
}
