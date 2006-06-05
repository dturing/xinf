/* 
   xinf is not flash.
   Copyright (c) 2006, Daniel Fischer.
 
   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.
																			
   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU		
   Lesser General Public License or the LICENSE file for more details.
*/

package org.xinf.inity;

import org.xinf.geom.Point;
import CPtr;

class CountourPart {
    public function render( tess:Dynamic ) {
    }
}

class LineTo extends CountourPart {
    private var _vertex:Dynamic;
    
    public function new( _x:Float, _y:Float ) {
        _vertex = CPtr.double_alloc(3);
        CPtr.double_set(_vertex,0,_x);
        CPtr.double_set(_vertex,1,_y);
        CPtr.double_set(_vertex,2,.0);
    }
    
    public function render( tess:Dynamic ) {
//    trace("render "+this);
        GLU.TessVertex( tess, _vertex, CPtr.void_cast(_vertex) );
    }

    public function toString() {
        return( "LineTo("+CPtr.double_get(_vertex,0) +","+CPtr.double_get(_vertex,1)+")" );
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
    
    public function render( tess:Dynamic ) {
        GLU.TessCubicCurve( tess, untyped ctrl.__a, v, n );
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
        n = 5; // FIXME: subdivision size dependant on viewport distance (use gluProject?)
        v = CPtr.double_alloc(n*3);
    }
    
    public function render( tess:Dynamic ) {
        GLU.TessQuadraticCurve( tess, untyped ctrl.__a, v, n );
    }
    
    public function toString() {
        return( "QuadraticTo("+ctrl+")" );
    }
}


class Contour {
    private var parts:Array<CountourPart>;
    private var offset:Point;
    private var current:Point;
    
    public var length( get_length, null ):Float;
    public function get_length() : Float {
        return parts.length;
    }

    public function new( x:Float, y:Float ) {
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

    public function render( tess:Dynamic ) :Void {
        GLU.TessBeginContour( tess );
        GL.PushMatrix();
        GL.Translatef( offset.x, offset.y, .0 );
        
        for( p in parts ) {
            p.render(tess);
        }
        
        GL.PopMatrix();
        GLU.TessEndContour( tess );
    }
}
