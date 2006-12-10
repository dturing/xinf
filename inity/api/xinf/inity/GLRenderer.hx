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

import xinf.erno.Renderer;
import xinf.erno.DrawingInstruction;
import xinf.erno.PenStackRenderer;
import xinf.erno.Matrix;

import opengl.GL;
import opengl.GLU;
import cptr.CPtr;

class GLRenderer extends PenStackRenderer {
	private var shape:GLPolygon;
	public var font(default,null):xinf.inity.font.Font;
	private var root:Int;
	
	private var circle_fill:Int;
	private var circle_stroke:Int;

	public function new() :Void {
		super();
		root = getNextId();
		
		var fy = 4./3.;
		
		circle_fill = GL.genLists(1);
		GL.newList( circle_fill, GL.COMPILE );
		GL.begin( GL.POLYGON );
			var n = 50;
			var f = (Math.PI*2)/n;
			for( i in 0...(n+1) ) {
				GL.vertex3( Math.sin(f*i), Math.cos(f*i)*fy, 0. );
			}
		GL.end();
		GL.endList();

		circle_stroke = GL.genLists(1);
		GL.newList( circle_stroke, GL.COMPILE );
		GL.begin( GL.LINE_STRIP );
			var n = 50;
			var f = (Math.PI*2)/n;
			for( i in 0...(n+1) ) {
				GL.vertex3( Math.sin(f*i), Math.cos(f*i)*fy, 0. );
			}
		GL.end();
		GL.endList();

	}
	
	public function getNextId() :Int {
		return GL.genLists(1);
	}
	public function getRootId() :Int {
		return root;
	}
	
	public function draw( i:DrawingInstruction ) :Void {
//		trace(i);
		
		if( shape != null ) {
			switch( i ) {
				case EndShape:
					shape.draw( pen.fillColor, pen.strokeColor, pen.strokeWidth );
					shape = null;
				default:
					shape.append(i);
			}
			
			return;
		}
		
		switch( i ) {
			case StartObject(id):
				pushPen();
				GL.newList( id, GL.COMPILE );
	            GL.pushName(id);
				GL.pushMatrix();
				GL.pushAttrib(GL.TRANSFORM_BIT); // for the clipping planes
				
			case EndObject:
				GL.popAttrib();
				GL.popMatrix();
	            GL.popName();
				GL.endList();
				popPen();
				
			case ShowObject(id):
				GL.callList( id );
				
			case Translate(x,y):
				GL.translate( x, y, 0. );
				
			case Transform(m):
				GL.multMatrixf( matrixForGL(m) );

			case Scale(x,y):
				GL.scale( x, y, 1. );

			case Rotate(a):
				GL.rotate( a, 0., 0., 1. );

			case ClipRect(w,h):
				var eq:Dynamic = CPtr.double_alloc(4);
				CPtr.double_set(eq,0,1.);
				CPtr.double_set(eq,1,0.);
				CPtr.double_set(eq,2,0.);
				CPtr.double_set(eq,3,0.);
				GL.clipPlane( GL.CLIP_PLANE0, eq );
				GL.enable( GL.CLIP_PLANE0 );
				CPtr.double_set(eq,0,0.);
				CPtr.double_set(eq,1,1.);
				GL.clipPlane( GL.CLIP_PLANE1, eq );
				GL.enable( GL.CLIP_PLANE1 );
				CPtr.double_set(eq,0,-1.);
				CPtr.double_set(eq,1,0.);
				CPtr.double_set(eq,3,w);
				GL.clipPlane( GL.CLIP_PLANE2, eq );
				GL.enable( GL.CLIP_PLANE2 );
				CPtr.double_set(eq,0,0.);
				CPtr.double_set(eq,1,-1.);
				CPtr.double_set(eq,3,h);
				GL.clipPlane( GL.CLIP_PLANE3, eq );
				GL.enable( GL.CLIP_PLANE3 );

			case StartShape:
				if( shape != null ) throw("Can only define one path at a time");
				shape = new GLPolygon();
				
			case Rect(x,y,w,h):
				if( pen.fillColor != null ) {
					GL.color4( pen.fillColor.r, pen.fillColor.g, pen.fillColor.b, pen.fillColor.a );
					GL.begin( GL.QUADS );
						GL.vertex3( x, y, 0. );
						GL.vertex3( x+w, y, 0. );
						GL.vertex3( x+w, y+h, 0. );
						GL.vertex3( x, y+h, 0. );
						GL.vertex3( x, y, 0. );
					GL.end();
				}
				if( pen.strokeColor != null && pen.strokeWidth > 0 ) {
					GL.color4( pen.strokeColor.r, pen.strokeColor.g, pen.strokeColor.b, pen.strokeColor.a );
					GL.lineWidth( pen.strokeWidth );
					GL.begin( GL.LINE_STRIP );
						GL.vertex3( x, y, 0. );
						GL.vertex3( x+w, y, 0. );
						GL.vertex3( x+w, y+h, 0. );
						GL.vertex3( x, y+h, 0. );
						GL.vertex3( x, y, 0. );
					GL.end();
					GL.pointSize( pen.strokeWidth );
					GL.begin( GL.POINTS );
						GL.vertex3( x, y, 0. );
						GL.vertex3( x+w, y, 0. );
						GL.vertex3( x+w, y+h, 0. );
						GL.vertex3( x, y+h, 0. );
						GL.vertex3( x, y, 0. );
					GL.end();
				}
				
			case Circle(x,y,r):
				GL.pushMatrix();
				GL.translate( x, y, 0. );
				GL.scale( r, r, 1.);
				
				if( pen.fillColor != null ) {
					GL.color4( pen.fillColor.r, pen.fillColor.g, pen.fillColor.b, pen.fillColor.a );
					GL.callList(circle_fill);
				}
				if( pen.strokeColor != null && pen.strokeWidth > 0 ) {
					GL.color4( pen.strokeColor.r, pen.strokeColor.g, pen.strokeColor.b, pen.strokeColor.a );
					GL.lineWidth( pen.strokeWidth );
					GL.callList(circle_stroke);
				}
				GL.popMatrix();
				
								
			case Text(text,style):
				font = xinf.inity.font.Font.getFont( pen.fontFace ); //+" "+slant+" "+weight );
				if( pen.fillColor != null && font != null ) {
					GL.color4( pen.fillColor.r, pen.fillColor.g, pen.fillColor.b, pen.fillColor.a );
					font.renderText( text, pen.fontSize, style );
				}
				
			case Image( img, inRegion, outRegion ):
				var tx1:Float = (inRegion.x/img.twidth);
				var ty1:Float = (inRegion.y/img.theight);
				var tx2:Float = tx1 + (inRegion.w/img.twidth);
				var ty2:Float = ty1 + (inRegion.h/img.theight);
				var x:Float = outRegion.x;
				var y:Float = outRegion.y;
				var x2:Float = outRegion.w+x;
				var y2:Float = outRegion.h+y;

				GL.color4( 1., 1., 1., 1. );

				GL.pushAttrib( GL.ENABLE_BIT );
					GL.enable( GL.TEXTURE_2D );
					GL.bindTexture( GL.TEXTURE_2D, img.texture );

					GL.begin( GL.QUADS );
						GL.texCoord2( tx1, ty1 );
						GL.vertex2  (   x,   y ); 
						GL.texCoord2( tx2, ty1 );
						GL.vertex2  (  x2,   y ); 
						GL.texCoord2( tx2, ty2 );
						GL.vertex2  (  x2,  y2 ); 
						GL.texCoord2( tx1, ty2 );
						GL.vertex2  (   x,  y2 ); 
					GL.end();
					
				GL.popAttrib();
				
			default:
				super.draw(i);
		}
	}
	
	public static function matrixForGL( m:Matrix ) :Dynamic {
		var v = CPtr.float_alloc(16);
		
		CPtr.float_set(v,0,m.m00);
		CPtr.float_set(v,1,m.m10);
		CPtr.float_set(v,2,m.m20);
		CPtr.float_set(v,3,.0);

		CPtr.float_set(v,4,m.m01);
		CPtr.float_set(v,5,m.m11);
		CPtr.float_set(v,6,m.m21);
		CPtr.float_set(v,7,.0);

		CPtr.float_set(v,8,m.m02);
		CPtr.float_set(v,9,m.m12);
		CPtr.float_set(v,10,m.m22);
		CPtr.float_set(v,11,.0);

		CPtr.float_set(v,12,.0);
		CPtr.float_set(v,13,.0);
		CPtr.float_set(v,14,.0);
		CPtr.float_set(v,15,1.);
		
		return v;
	}
}
