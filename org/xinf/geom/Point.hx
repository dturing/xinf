package org.xinf.geom;

class Point {
    public var x:Float;
    public var y:Float;

    public property length(get_length,null):Float;
    private function get_length() : Float {
        return( Math.sqrt( Math.pow(x,2) + Math.pow(y,2) ) );
    }
    
    public function new( _x:Float, _y:Float ) {
        x = _x;
        y = _y;
    }
    
    public function add( p:Point ) : Point {
        return new Point( x+p.x, y+p.x );
    }
    
    public function subtract( p:Point ) : Point {
        return new Point( x-p.x, y-p.x );
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
        return("(x="+x+", y="+y+")");
    }
    
    static function distance( pt1:Point, pt2:Point ) : Float {
        var d:Point = pt2;
        d.subtract(pt1);
        return d.length;
    }
    
    static function interpolate( pt1:Point, pt2:Point, f:Float ) : Point {
        var d:Point = new Point( (pt2.x-pt1.x)*f, (pt2.y-pt1.y)*f );
        d.add(pt1);
        return d;
    }
    
    static function polar( len:Float, angle:Float ) : Point {
        throw("NYI");
        return new Point(0,0);
    }
}
