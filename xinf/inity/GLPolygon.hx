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

package xinf.inity;

import opengl.GL;
import opengl.GLU;
import opengl.Tesselator;
import opengl.Helper;
import cptr.CPtr;

import xinf.geom.Types;
import xinf.erno.Color;

class GLContour {
    
    private var last:TPoint;
    private var pixelSize:Float;
    public var path:Array<TPoint>;
    
    public function new( x:Float, y:Float, pixelSize:Float ) :Void {
        path = new Array<TPoint>();
        path.push( last = { x:x, y:y } );
        if( pixelSize==null ) pixelSize=1.;
        this.pixelSize=pixelSize;
    }
        
    public function lineTo( x:Float, y:Float ) :Void {
        path.push( last = { x:x, y:y } );
    }

    public function close() :Void {
        path.push( path[0] );
    }

    public function quadraticTo( x1:Float, y1:Float, x:Float, y:Float ) :Void {
        var d=Math.round(Math.max(2,(Math.abs(last.y-y)+Math.abs(last.x-x)) * pixelSize));
        Helper.evaluateQuadraticBezier( [ last.x, last.y, x1, y1, x, y ], d, this.lineTo );
    //    last = { x:x, y:y };
    }
    
    public function cubicTo( x1:Float, y1:Float, x2:Float, y2:Float, x:Float, y:Float ) {
        var d=Math.round(Math.max(2,(Math.abs(last.y-y)+Math.abs(last.x-x)) * pixelSize));
        var a = [ last.x, last.y, x1, y1, x2, y2, x, y ];
        //trace("D: "+d+", "+(Math.abs(last.y-y)+Math.abs(last.x-x))+", "+last+", "+x+","+y+", pixelSize "+pixelSize );
        Helper.evaluateCubicBezier( a, d, this.lineTo );
        //  last = { x:x, y:y };
    }

    public function appendArray( a:Array<Float> ) :Void {
        for( i in 0...Math.floor(a.length/2) ) {
            path.push( { x:a[i*2], y:a[(i*2)+1] } );
        }
    }
    
}

// Fixme: maybe this implements some ShapeRenderer interface?
class GLPolygon {
    
    static private var tess:Tesselator;

    private var shape:Array<GLContour>;
    private var contour:GLContour;
    private var pixelSize:Float;
    
    public function new( ?pixelSize:Float ) :Void {
        shape = new Array<GLContour>();
        contour = null;
        if( pixelSize==null ) pixelSize=5.;
        this.pixelSize=pixelSize;
    }
    
    /* FIXME */
    public function setPixelSize( s:Float ) :Void {
        pixelSize = s;
    }

    /* these would construct/end myself!
    public function startShape() {
        throw("unimplemented");
    }
    public function endShape() {
        throw("unimplemented");
    }
    */
    
    public function startPath( x:Float, y:Float) {
        contour = new GLContour(x,y,pixelSize);
    }
    
    public function endPath() {
        shape.push(contour);
        contour=null;
    }
    
    public function close() {
        contour.close();
    }
    
    public function lineTo( x:Float, y:Float ) {
        contour.lineTo(x,y);
    }
    
    public function quadraticTo( x1:Float, y1:Float, x:Float, y:Float ) {
        contour.quadraticTo(x1,y1,x,y);
    }
    
    public function cubicTo( x1:Float, y1:Float, x2:Float, y2:Float, x:Float, y:Float ) {
        contour.cubicTo(x1,y1,x2,y2,x,y);
    }
    
    /* end of Renderer-like instructions */
    
    private function makeCPtr() :Dynamic {
        var n:Int = 0;
        for( contour in shape ) {
            n+=contour.path.length;
        }

        var coords = CPtr.double_alloc(n*3);
        var i = 0;
        for( contour in shape ) {
            for( c in contour.path ) {
                CPtr.double_set( coords, i++, c.x );
                CPtr.double_set( coords, i++, c.y );
                CPtr.double_set( coords, i++, 0. );
            }
        }
        return coords;
    }

    private function drawTesselated( coords:Dynamic ) :Void {
        if( tess == null ) {
            tess=Tesselator.create();
        }

        tess.normal( 0., 0., 1. );
        tess.beginPolygon( null );
        
        var i=0;
        for( contour in shape ) {
            tess.beginContour();
            for( c in contour.path ) {
                tess.vertexOffset( i, coords );
                i+=3;
            }
            tess.endContour();
        }
        tess.endPolygon();
    }
    
    private function drawOutline( coords:Dynamic ) :Void {
        var i=0;
        for( contour in shape ) {
            GL.begin( GL.LINE_STRIP );
                GLU.verticesOffset( i, contour.path.length, coords );
            GL.end();
            /*
            GL.begin( GL.POINTS );
            GLU.verticesOffset( coords, i, contour.path.length );
            GL.end();
            */
            i+=contour.path.length*3;
        }
    }
    
    public function draw( fill:Color, stroke:Color, width:Float ) :Void {
        var coords = makeCPtr();

        if( fill != null ) {
            GL.color4( fill.r, fill.g, fill.b, fill.a );

            drawTesselated( coords );
            
            #if gldebug
                var e:Int = GL.getError();
                if( e > 0 ) {
                    throw( "OpenGL Error: "+GLU.errorString(e) );
                }
            #end
        }
        
        if( width>0 && stroke != null ) {
            GL.color4( stroke.r, stroke.g, stroke.b, stroke.a );
            GL.lineWidth( width );
            GL.pointSize( width );

            drawOutline( coords );
            
            #if gldebug
                var e:Int = GL.getError();
                if( e > 0 ) {
                    throw( "OpenGL Error: "+GLU.errorString(e) );
                }
            #end
        }
    }

    public function drawFilled() :Void {
        var coords = makeCPtr();
        drawTesselated( coords );
    }
    
}