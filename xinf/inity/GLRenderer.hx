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
import xinf.erno.PenStackRenderer;
import xinf.erno.Matrix;
import xinf.erno.ImageData;

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

		// FIXME: somewhat stupid initialization of "circle primitive"
		var fy = 1; //3./4.;
		
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
	

	public function startObject( id:Int ) {
		pushPen();
		GL.newList( id, GL.COMPILE );
		GL.pushName(id);
		GL.pushMatrix();
		GL.pushAttrib(GL.TRANSFORM_BIT); // for the clipping planes
	}
	public function endObject() {
		GL.popAttrib();
		GL.popMatrix();
		GL.popName();
		GL.endList();
		popPen();
	}
	public function showObject( id:Int ) {
		GL.callList( id );
	}


	public function translate( x:Float, y:Float ) {
		GL.translate( x, y, 0. );
	}
	public function scale( x:Float, y:Float ) {
		GL.scale( x, y, 1. );
	}
	public function rotate( angle:Float ) {
		GL.rotate( angle, 0., 0., 1. );
	}
	public function transform( matrix:Matrix ) {
		GL.multMatrixf( matrixForGL(matrix) );
	}
	public function clipRect( w:Float, h:Float ) {
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
	}

	
	public function startShape() {
		if( shape != null ) throw("Can only define one path at a time");
		shape = new GLPolygon();
	}
	public function endShape() {
		if( shape==null ) throw("no current Polygon");
		shape.draw( pen.fillColor, pen.strokeColor, pen.strokeWidth );
		shape = null;
	}
	public function startPath( x:Float, y:Float) {
		if( shape==null ) throw("no current Polygon");
		shape.startPath( x, y );
	}
	public function endPath() {
		shape.endPath();
	}
	public function close() {
		shape.close();
	}
	public function lineTo( x:Float, y:Float ) {
		shape.lineTo(x,y);
	}
	public function quadraticTo( x1:Float, y1:Float, x:Float, y:Float ) {
		shape.quadraticTo(x1,y1,x,y);
	}
	public function cubicTo( x1:Float, y1:Float, x2:Float, y2:Float, x:Float, y:Float ) {
		shape.cubicTo(x1,y1,x2,y2,x,y);
	}
	
	public function rect( x:Float, y:Float, w:Float, h:Float ) {
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
	}
	public function circle( x:Float, y:Float, r:Float ) {
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
	}
	public function text( x:Float, y:Float, text:String, ?style:FontStyle ) {
		font = xinf.inity.font.Font.getFont( pen.fontFace ); //+" "+slant+" "+weight );
		if( pen.fillColor != null && font != null ) {
			GL.pushMatrix();
				GL.translate( x, y, 0 );
				GL.color4( pen.fillColor.r, pen.fillColor.g, pen.fillColor.b, pen.fillColor.a );
				font.renderText( text, pen.fontSize, style );
			GL.popMatrix();
		}
	}
	public function image( img:ImageData, inRegion:{ x:Float, y:Float, w:Float, h:Float }, outRegion:{ x:Float, y:Float, w:Float, h:Float } ) {
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
	}
	
	/* helper functions */
		
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
