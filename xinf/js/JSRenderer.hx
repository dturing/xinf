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

package xinf.js;

import xinf.erno.ObjectModelRenderer;
import xinf.erno.DrawingInstruction;
import xinf.erno.Color;

import js.Dom;
typedef Primitive = js.HtmlDom

class JSRenderer extends ObjectModelRenderer<Primitive> {
	public function getRootPrimitive() :Primitive {
		//return js.Lib.document.body;
		return js.Lib.document.getElementById("xinf:root");
	}

	override public function createPrimitive(id:Int) :Primitive {
		// create new object
		var o = js.Lib.document.createElement("div");
		o.style.position="absolute";
		untyped o.xinfId = id;
		return o;
	}
	
	override public function clearPrimitive( p:Primitive ) {
		p.innerHTML="";
	}
	
	override public function attachPrimitive( parent:Primitive, child:Primitive ) :Void {
		if( child.parentNode!=null ) {
			// FIXME: alternatively to just doing nothing, remove from old parent
			// (although- 
			// throw("Object "+child+" is already attached.");
		} else {
			parent.appendChild( child );
		}
	}
	
	public function draw( i:DrawingInstruction ) :Void {
	try {
		switch( i ) {
				
			case Translate(x,y):
				current.style.left = ""+Math.round(x);
				current.style.top = ""+Math.round(y);
				
			case ClipRect(w,h):
				current.style.overflow = "hidden";
				current.style.width = ""+Math.max(0,Math.round(w));
				current.style.height = ""+Math.max(0,Math.round(h));
				
			case Rect(x,y,w,h):
				var r = js.Lib.document.createElement("div");
				r.style.position="absolute";
				r.style.left = ""+Math.round(x - (pen.strokeWidth/2));
				r.style.top = ""+Math.round(y - (pen.strokeWidth/2));
				r.style.width = ""+Math.round(w - pen.strokeWidth);
				r.style.height = ""+Math.round(h - pen.strokeWidth);
				if( pen.fillColor != null ) {
					r.style.background = pen.fillColor.toRGBString();
				}
				if( pen.strokeWidth > 0 && pen.strokeColor != null ) {
					r.style.border = ""+pen.strokeWidth+"px solid "+pen.strokeColor.toRGBString();
				}
				current.appendChild( r );
				
			case Text(text):
				var r = js.Lib.document.createElement("div");
				r.style.position="absolute";
				r.style.whiteSpace="nowrap";
				r.style.cursor="default";
				if( pen.fillColor != null )	r.style.color = pen.fillColor.toRGBString();
				if( pen.fontFace != null ) r.style.fontFamily = pen.fontFace;
				if( pen.fontSlant == Italic ) r.style.fontStyle = "italic";
				if( pen.fontWeight == Bold ) r.style.fontWeight = "bold";
				if( pen.fontSize != null ) r.style.fontSize = ""+pen.fontSize+"px";
				r.innerHTML=text;
				current.appendChild(r);
				
			default:
				super.draw(i);
		}
		} catch( e:Dynamic ) {
			trace("JS Render exception: "+e );
		}
	}
}
