/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.geom;

import xinf.geom.Types;

class Rotate implements Transform {
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
        var co = Math.cos(a);
        var si = Math.sin(a);
        return { a:co, b:si, c:-si, d:co, tx:0., ty:0. };
    }
    
    public function apply( p:TPoint ) :TPoint {
        return new Matrix( getMatrix() ).apply(p);
    }
    public function applyInverse( p:TPoint ) :TPoint {
        return new Matrix( getMatrix() ).applyInverse(p);
    }

	public function interpolateWith( p:Transform, f:Float ) :Transform {
		if( Std.is(p,Identity) ) return new Rotate(a*(1-f));
		if( !Std.is(p,Rotate) ) return this;
		var q:Rotate = cast(p);
		return( new Rotate( a + ((q.a-a)*f) ) );
	}

    public function toString() {
        return("rotate("+(a*TransformParser.R2D)+")");
    }
}
