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
import flash.display.LineScaleMode;
import flash.display.CapsStyle;
import flash.display.JointStyle;

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
		p.graphics.clear();
		for( i in 0...p.numChildren ) {
			p.removeChildAt(0);
		}
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

			case Scale(x,y):
				current.scaleX = x;
				current.scaleY = y;

			case ClipRect(w,h):
				var crop = new Sprite();
				var g = crop.graphics;
				g.beginFill( 0xff0000, 1 );
				g.drawRect(1,1,w,h);
				g.endFill();
				current.addChild(crop);
				current.mask = crop;
								
			case Rect(x,y,w,h):
				if( pen.strokeColor!=null && pen.strokeWidth>0 ) {
					g.lineStyle( pen.strokeWidth, pen.strokeColor.toRGBInt(), pen.strokeColor.a,
						false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.MITER );
				} else {
					g.lineStyle( 0, 0, 0 );
				}
				if( pen.fillColor != null ) {
					g.beginFill( pen.fillColor.toRGBInt(), pen.fillColor.a );
				} else {
					g.beginFill( 0, 0 );
				}
				g.drawRect( x,y,w,h );
				g.endFill();
				
			case Text(text,style):
				// FIXME: textStyles
				if( pen.fillColor != null ) {
					var tf = new flash.text.TextField();
					tf.text = text;
					tf.selectable = false;
					tf.y=-1;
					tf.x=-1;
					
					var format:flash.text.TextFormat = tf.getTextFormat();
					format.font = pen.fontFace; //"Kassiopeia09T_09_sp60_cyr30";
					format.size = pen.fontSize;
					format.color = pen.fillColor.toRGBInt();
					format.leftMargin = 0;
					tf.setTextFormat(format);
					
					current.addChild(tf);
				}
				
			case StartShape:
				if( pen.fillColor != null ) {
					g.beginFill( pen.fillColor.toRGBInt() );
//				} else {
//					g.beginFill( 0, 0 );
				}
				if( pen.strokeColor!=null && pen.strokeWidth>0 ) {
					g.lineStyle( pen.strokeWidth, pen.strokeColor.toRGBInt(), pen.strokeColor.a );
				}
				
			case EndShape:
				if( pen.fillColor != null ) {
					g.endFill();
				}
				
			case StartPath(x,y):
				// FIXME: dunno whats the deal with the *2, but its all too small else...
				g.moveTo(x,y);
			
			case EndPath:
				g.moveTo(0,0);
			
			case Close:
				// FIXME
				
			case LineTo(x,y):
				g.lineTo(x,y);
			
			case QuadraticTo(x1,y1,x2,y2):
				g.curveTo( x1,y1,x2,y2 );
			
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
