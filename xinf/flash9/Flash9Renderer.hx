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

package xinf.flash9;

import xinf.erno.ObjectModelRenderer;
import xinf.erno.DrawingInstruction;
import xinf.erno.Color;

import flash.display.Sprite;
import flash.display.Graphics;

typedef Primitive = XinfSprite

class Flash9Renderer extends ObjectModelRenderer<Primitive> {
	var root:Primitive;

	public function getRootPrimitive() :Primitive {
		if( root==null ) {
			root = new Primitive();
			flash.Lib.current.stage.addChild(root);
		}
		return root;
	}

	override public function createPrimitive(id:Int) :Primitive {
		// create new object
		var o = new Primitive();
		o.xinfId = id;
		return o;
	}
	
	override public function clearPrimitive( p:Primitive ) {
		current.graphics.clear();
	}
	
	override public function attachPrimitive( parent:Primitive, child:Primitive ) :Void {
		parent.addChild( child );
	}
	
	public function draw( i:DrawingInstruction ) :Void {
		var g:Graphics = current.graphics;
		
		try {
		switch( i ) {
			case Translate(x,y):
				current.x = x;
				current.y = y;
								
			case Rect(x,y,w,h):
				if( pen.fillColor != null ) {
					g.beginFill( pen.fillColor.toRGBInt() );
					g.drawRect( x,y,w,h );
					g.endFill();
				}
				
			case Text(text):
				if( pen.fillColor != null ) {
					var tf = new flash.text.TextField();
					tf.text = text;
					tf.autoSize = flash.text.TextFieldAutoSize.LEFT;
					
					var format:flash.text.TextFormat = tf.getTextFormat();
					format.font = "vera";
					format.color = pen.fillColor.toRGBInt();
					tf.setTextFormat(format);
					
					current.addChild(tf);
				}
				
			case StartShape:
				if( pen.fillColor != null ) {
					g.beginFill( pen.fillColor.toRGBInt() );
				} else {
					g.beginFill( 0 );
				}
				if( pen.strokeColor!=null && pen.strokeWidth>0 ) {
					g.lineStyle( pen.strokeWidth, pen.strokeColor.toRGBInt(), pen.strokeColor.a );
				}
				
			case EndShape:
				g.endFill();
				
			case StartPath(x,y):
				// FIXME: dunno whats the deal with the *2, but its all too small else...
				g.moveTo(x*2,y*2);
			
			case EndPath:
				// FIXME
			
			case Close:
				// FIXME
				
			case LineTo(x,y):
				g.lineTo(x*2,y*2);
			
			case QuadraticTo(x1,y1,x2,y2):
				g.curveTo( x1*2,y1*2,x2*2,y2*2 );
			
			case CubicTo(p):
				// FIXME
				
			default:
				super.draw(i);
		}
		} catch( e:Dynamic ) {
			trace("exc rendering "+i+": "+e );
		}
	}
}
