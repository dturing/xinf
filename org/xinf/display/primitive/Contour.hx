package org.xinf.display.primitive;

import org.xinf.geom.Point;
import org.xinf.util.CPtr;

class CountourPart {
    public function _render( r:org.xinf.render.IRenderer ) {
    }
}

class LineTo extends CountourPart {
    private var x:Float;
    private var y:Float;
    
    public function new( _x:Float, _y:Float ) {
        x = _x;
        y = _y;
    }
    
    public function _render( r:org.xinf.render.IRenderer ) {
        r.tessVertex( x, y );
    }

    public function toString() {
        return( "LineTo("+x+","+y+")" );
    }
}

class CubicTo extends CountourPart {
    private var ctrl:Array<Float>;
    private var v:Dynamic;
    private var n:Int;
    
    public function new( p0:Point, c1:Point, c2:Point, p1:Point ) {
        ctrl = [ p0.x, p0.y, c1.x, c1.y, c2.x, c2.y, p1.x, p1.y ];
        n = 5; // FIXME: subdivision size dependant on viewport distance (use gluProject?)
        v = CPtr.double_alloc(n*3);
    }
    
    public function _render( r:org.xinf.render.IRenderer ) {
        r.tessCubicCurve( ctrl, v, n );
    }

    public function toString() {
        return( "CubicTo("+ctrl+")" );
    }
}

class QuadraticTo extends CountourPart {
    private var ctrl:Array<Float>;
    private var v:Dynamic;
    private var n:Int;
    
    public function new( p0:Point, c:Point, p1:Point ) {
        ctrl = [ p0.x, p0.y, c.x, c.y, p1.x, p1.y ];
        n = 2; // FIXME: subdivision size dependant on viewport distance (use gluProject?)
        v = CPtr.double_alloc(n*3);
    }
    
    public function _render( r:org.xinf.render.IRenderer ) {
        r.tessQuadraticCurve( ctrl, v, n );
    }
    
    public function toString() {
        return( "QuadraticTo("+ctrl+")" );
    }
}


class Contour extends Primitive {
    private var parts:Array<CountourPart>;
    private var offset:Point;
    private var current:Point;
    
    public property length( get_length, null ):Float;
    public function get_length() : Float {
        return parts.length;
    }

    public function new( x:Float, y:Float ) {
        super();
        offset = new Point(x,y);
        parts = new Array<CountourPart>();
        current = new Point(offset.x,offset.y);
    }
    
    public function addPoint( p:Point ) {
        parts.push( new LineTo( p.x, p.y ) );
        current.x = p.x; current.y = p.y;
    }

    public function addCoordinates( x:Float, y:Float ) {
        parts.push( new LineTo( x, y ) );
        current.x = x; current.y = y;
    }
    
    public function addCubic( c1:Point, c2:Point, p1:Point ) {
        parts.push( new CubicTo( new Point(current.x,current.y), c1, c2, p1 ) );
        current.x = p1.x; current.y = p1.y;
    }

    public function addQuadratic( c:Point, p1:Point ) {
        parts.push( new QuadraticTo( new Point(current.x,current.y), c, p1 ) );
        current.x = p1.x; current.y = p1.y;
    }

    public function _render( r:org.xinf.render.IRenderer ) {
        r.tessBeginContour();
        r.pushMatrix();
        r.translate( offset.x, offset.y );
        
        for( p in parts ) {
            p._render( r );
        }

        r.popMatrix();
        r.tessEndContour();
    }
}
