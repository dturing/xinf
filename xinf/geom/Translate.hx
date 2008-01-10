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
    
    public function toString() {
        return("translate("+x+","+y+")");
    }
}
