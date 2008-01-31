/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.geom;

import xinf.geom.Types;

class Scale implements Transform {
    var x:Float;
    var y:Float;
    
    public function new( x:Float, y:Float ) {
        this.x = x;
        this.y = y;
    }
    
    public function getTranslation() {
        return { x:.0, y:.0 };
    }
    public function getScale() {
        return { x:x, y:y };
    }
    public function getMatrix() {
        return { a:x, b:0., c:0., d:y, tx:0., ty:0. };
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
						   y + ((q.y-y)*f) ) );
	}

    public function toString() {
        return("scale("+x+","+y+")");
    }
}
