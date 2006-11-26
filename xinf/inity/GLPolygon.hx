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

import xinf.erno.DrawingInstruction;
import xinf.erno.Coord2d;
import xinf.erno.Color;

class GLContour {
	private var last:Coord2d;
	private var pixelSize:Float;
	public var path:Array<Coord2d>;
	
	public function new( x:Float, y:Float, pixelSize:Float ) :Void {
		path = new Array<Coord2d>();
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
	//	if( pixelSize>1. ) trace("D: "+d+", "+(Math.abs(last.y-y)+Math.abs(last.x-x)) );
		GLU.EvaluateQuadraticBezier( untyped [ last.x, last.y, x1, y1, x, y ].__a, d, 
			this.lineTo );
	}
	public function cubicTo( a:Array<Float> ) :Void {
		var d=Math.round(Math.max(2,Math.abs((last.y-a[4])+(last.x-a[5])) * pixelSize));
		a.unshift(last.y); a.unshift(last.x);
		GLU.EvaluateCubicBezier( untyped a.__a, d,
			this.lineTo );
	}

	public function appendArray( a:Array<Float> ) :Void {
		for( i in 0...Math.floor(a.length/2) ) {
			path.push( { x:a[i*2], y:a[(i*2)+1] } );
		}
	}
}


class GLPolygon {
	static private var tess;

	private var shape:Array<GLContour>;
	private var contour:GLContour;
	private var pixelSize:Float;
	
	public function new( ?pixelSize:Float ) :Void {
		shape = new Array<GLContour>();
		contour = null;
		if( pixelSize==null ) pixelSize=1.;
		this.pixelSize=pixelSize;
	}
	
	public function setPixelSize( s:Float ) :Void {
		pixelSize = s;
	}
	
	public function append( i:DrawingInstruction ) :Void {
		switch( i ) {
			case StartPath(x,y):
				contour = new GLContour(x,y,pixelSize);
			case EndPath:
				shape.push(contour);
				contour=null;
				
			case LineTo(x,y):
				contour.lineTo(x,y);
			case Close:
				contour.close();
			case QuadraticTo(x1,y1,x,y):
				contour.quadraticTo(x1,y1,x,y);
			case CubicTo(a):
				contour.cubicTo(a);
				
			default:
				throw( "not a shape instruction: "+i );
		}
	}
	
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
			tess=GLU.SimpleTesselator();
		}

		GLU.TessNormal( tess, 0., 0., 1. );
		GLU.TessBeginPolygon( tess, CPtr.void_null );
		
		var i=0;
		for( contour in shape ) {
			GLU.TessBeginContour( tess );
			for( c in contour.path ) {
				GLU.TessVertexOffset( tess, coords, i );
				i+=3;
			}
			GLU.TessEndContour( tess );
		}
		GLU.TessEndPolygon( tess );
	}
	
	private function drawOutline( coords:Dynamic ) :Void {
		var i=0;
		for( contour in shape ) {
			GL.Begin( GL.LINE_STRIP );
			GLU.VerticesOffset( coords, i, contour.path.length );
			GL.End();
			/*
			GL.Begin( GL.POINTS );
			GLU.VerticesOffset( coords, i, contour.path.length );
			GL.End();
			*/
			i+=contour.path.length*3;
		}
	}
	
	public function draw( fill:Color, stroke:Color, width:Float ) :Void {
		var coords = makeCPtr();

		if( fill != null ) {
			GL.Color4f( fill.r, fill.g, fill.b, fill.a );

			drawTesselated( coords );
		}
		
		if( width>0 && stroke != null ) {
			GL.Color4f( stroke.r, stroke.g, stroke.b, stroke.a );
			GL.LineWidth( width );
			GL.PointSize( width );

			drawOutline( coords );
		}
	}

	public function drawFilled() :Void {
		var coords = makeCPtr();
		drawTesselated( coords );
	}
}