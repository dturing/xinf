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
    
    public function getTranslation() {
        return new Matrix( getMatrix() ).getTranslation();
    }
    public function getScale() {
        return new Matrix( getMatrix() ).getScale();
    }
    public function getMatrix() {
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

    public function toString() {
        return("concat( "+a+", "+b+" )");
    }
}
