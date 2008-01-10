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

    public function toString() {
        return("scale("+x+","+y+")");
    }
}
