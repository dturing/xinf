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
import GL;

class GLRenderer extends PenStackRenderer {
	private var shape:GLPolygon;
	public var font(default,null):xinf.inity.font.Font;
	private var root:Int;

	public function new() :Void {
		super();
		root = getNextId();
	}
	
	public function getNextId() :Int {
		return GL.GenLists(1);
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
				GL.NewList( id, GL.COMPILE );
	            GL.PushName(id);
				GL.PushMatrix();
				GL.PushAttrib(GL.TRANSFORM_BIT); // for the clipping planes
				
			case EndObject:
				GL.PopAttrib();
				GL.PopMatrix();
	            GL.PopName();
				GL.EndList();
				popPen();
				
			case ShowObject(id):
				GL.CallList( id );
				
			case Translate(x,y):
				GL.Translatef( x, y, 0. );
				
			case Transform(m):
				GL.MultMatrixf( m.asGLMatrix() );

			case Scale(x,y):
				GL.Scalef( x, y, 0. );

			case Rotate(a):
				GL.Rotatef( a, 0., 0., 1. );

			case ClipRect(w,h):
				var eq:Dynamic = CPtr.double_alloc(4);
				CPtr.double_set(eq,0,1.);
				CPtr.double_set(eq,1,0.);
				CPtr.double_set(eq,2,0.);
				CPtr.double_set(eq,3,0.);
				GL.ClipPlane( GL.CLIP_PLANE0, eq );
				GL.Enable( GL.CLIP_PLANE0 );
				CPtr.double_set(eq,0,0.);
				CPtr.double_set(eq,1,1.);
				GL.ClipPlane( GL.CLIP_PLANE1, eq );
				GL.Enable( GL.CLIP_PLANE1 );
				CPtr.double_set(eq,0,-1.);
				CPtr.double_set(eq,1,0.);
				CPtr.double_set(eq,3,w);
				GL.ClipPlane( GL.CLIP_PLANE2, eq );
				GL.Enable( GL.CLIP_PLANE2 );
				CPtr.double_set(eq,0,0.);
				CPtr.double_set(eq,1,-1.);
				CPtr.double_set(eq,3,h);
				GL.ClipPlane( GL.CLIP_PLANE3, eq );
				GL.Enable( GL.CLIP_PLANE3 );

			case StartShape:
				if( shape != null ) throw("Can only define one path at a time");
				shape = new GLPolygon();
				
			case Rect(x,y,w,h):
				if( pen.fillColor != null ) {
					GL.Color4f( pen.fillColor.r, pen.fillColor.g, pen.fillColor.b, pen.fillColor.a );
					GL.Begin( GL.QUADS );
						GL.Vertex3f( x-.5, y-.5, 0. );
						GL.Vertex3f( x+w-.5, y-.5, 0. );
						GL.Vertex3f( x+w-.5, y+h-.5, 0. );
						GL.Vertex3f( x-.5, y+h-.5, 0. );
						GL.Vertex3f( x-.5, y-.5, 0. );
					GL.End();
				}
				if( pen.strokeColor != null && pen.strokeWidth > 0 ) {
					GL.Color4f( pen.strokeColor.r, pen.strokeColor.g, pen.strokeColor.b, pen.strokeColor.a );
					GL.LineWidth( pen.strokeWidth );
					GL.Begin( GL.LINE_STRIP );
						GL.Vertex3f( x-.5, y-.5, 0. );
						GL.Vertex3f( x+w-.5, y-.5, 0. );
						GL.Vertex3f( x+w-.5, y+h-.5, 0. );
						GL.Vertex3f( x-.5, y+h-.5, 0. );
						GL.Vertex3f( x-.5, y-.5, 0. );
					GL.End();
					GL.PointSize( pen.strokeWidth );
					GL.Begin( GL.POINTS );
						GL.Vertex3f( x-.5, y-.5, 0. );
						GL.Vertex3f( x+w-.5, y-.5, 0. );
						GL.Vertex3f( x+w-.5, y+h-.5, 0. );
						GL.Vertex3f( x-.5, y+h-.5, 0. );
					GL.End();
				}
								
			case Text(text,style):
				font = xinf.inity.font.Font.getFont( pen.fontFace ); //+" "+slant+" "+weight );
				if( pen.fillColor != null && font != null ) {
					GL.Color4f( pen.fillColor.r, pen.fillColor.g, pen.fillColor.b, pen.fillColor.a );
					font.renderText( text, pen.fontSize, style );
				}
				
			case Image( img, inRegion, outRegion ):
				var tx1:Float = (inRegion.x/img.twidth);
				var ty1:Float = (inRegion.y/img.theight);
				var tx2:Float = tx1 + (inRegion.w/img.twidth);
				var ty2:Float = ty1 + (inRegion.h/img.theight);
				var x:Float = outRegion.x-.25;
				var y:Float = outRegion.y-.25;
				var x2:Float = outRegion.w+x;
				var y2:Float = outRegion.h+y;

				GL.Color4f( 1., 1., 1., 1. );

				GL.PushAttrib( GL.ENABLE_BIT );
					GL.Enable( GL.TEXTURE_2D );
					GL.BindTexture( GL.TEXTURE_2D, img.texture );

					GL.Begin( GL.QUADS );
						GL.TexCoord2f( tx1, ty1 );
						GL.Vertex2f  (   x,   y ); 
						GL.TexCoord2f( tx2, ty1 );
						GL.Vertex2f  (  x2,   y ); 
						GL.TexCoord2f( tx2, ty2 );
						GL.Vertex2f  (  x2,  y2 ); 
						GL.TexCoord2f( tx1, ty2 );
						GL.Vertex2f  (   x,  y2 ); 
					GL.End();
					
				GL.PopAttrib();
				
			default:
				super.draw(i);
		}
	}
}
