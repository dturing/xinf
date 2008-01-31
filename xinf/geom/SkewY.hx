/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.geom;

import xinf.geom.Types;

class SkewY implements Transform {
    var a:Float;
    
    public function new( a:Float ) {
        this.a = a;
    }
    
    public function getTranslation() {
        return { x:.0, y:.0 };
    }
    public function getScale() {
        return { x:.0, y:.0 };
    }
    public function getMatrix() {
        return { a:1., b:Math.tan(a), c:0., d:1., tx:0., ty:0. };
    }
    
    public function apply( p:TPoint ) :TPoint {
        return new Matrix( getMatrix() ).apply(p);
    }
    public function applyInverse( p:TPoint ) :TPoint {
        return new Matrix( getMatrix() ).applyInverse(p);
    }

	public function interpolateWith( p:Transform, f:Float ) :Transform {
		if( Std.is(p,Identity) ) return new SkewY(a*(1-f));
		if( !Std.is(p,SkewY) ) return this;
		var q:SkewY = cast(p);
		return( new SkewY( a + ((q.a-a)*f) ) );
	}

    public function toString() {
        return("skewY("+(a*TransformParser.R2D)+")");
    }
}
