package org.xinf.geom;

class Rectangle {
    public var x:Float;
    public var y:Float;
    public var w:Float;
    public var h:Float;
    
    public function new( _x:Float, _y:Float, _w:Float, _h:Float ) {
        x = _x;
        y = _y;
        w = _w;
        h = _h;
    }
    
    public function clone() : Rectangle {
        return new Rectangle( x, y, w, h );
    }
    
    public function offset( dx:Float, dy:Float ) : Void {
        x+=dx;
        y+=dy;
    }
    
    public function toString() : String {
        return("("+x+","+y+"-"+w+"x"+h+")");
    }
}
