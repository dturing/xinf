package org.xinf.display.primitive;

import org.xinf.geom.Point;

class Polygon extends Primitive {
    private var points:Array<Point>;
    private var offset:Point;
    
    public property length( get_length, null ):Float;
    public function get_length() : Float {
        return points.length;
    }

    public function new( x:Float, y:Float ) {
        super();
        offset = new Point(x,y);
        points = new Array<Point>();
    }
    
    public function addPoint( p:Point ) {
        points.push(p);
    }

    public function addCoordinates( x:Float, y:Float ) {
        points.push( new Point(x,y) );
    }

    public function _render( r:org.xinf.render.IRenderer ) {
        r.pushMatrix();
        r.translate( offset.x, offset.y );
        r.polygon( points );
        r.popMatrix();
    }
}
