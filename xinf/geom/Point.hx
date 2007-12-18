/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.geom;

import xinf.geom.Types;

class Point {
    public var x:Float;
    public var y:Float;

    public var length(get_length,null):Float;
    private function get_length() : Float {
        return( Math.sqrt( Math.pow(x,2) + Math.pow(y,2) ) );
    }
    
    public function new( _x:Float, _y:Float ) {
        x = _x;
        y = _y;
    }
    
    public function add( p:TPoint ) : Point {
        return new Point( x+p.x, y+p.x );
    }
    
    public function subtract( p:TPoint ) : Point {
        return new Point( x-p.x, y-p.y );
    }
    
    public function clone() : Point {
        return new Point( x, y );
    }
    
    public function normalize( thickness:Float ) : Void {
        throw("NYI");
    }
    
    public function offset( dx:Float, dy:Float ) : Void {
        x+=dx;
        y+=dy;
    }
    
    public function toString() : String {
        return("("+x+","+y+")");
    }
    
    static public function distance( pt1:TPoint, pt2:TPoint ) : Float {
        var d:Point = new Point(pt2.x,pt2.y);
        d.subtract(pt1);
        return d.length;
    }
    
    static public function interpolate( pt1:TPoint, pt2:TPoint, f:Float ) : Point {
        var d:Point = new Point( (pt2.x-pt1.x)*f, (pt2.y-pt1.y)*f );
        d.add(pt1);
        return d;
    }
    
    static public function polar( len:Float, angle:Float ) : Point {
        return new Point( len * Math.cos(angle), len * Math.sin(angle) );
    }
}
