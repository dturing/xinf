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

import xinf.erno.DrawingInstruction;
import xinf.erno.Color;

import js.Dom;
typedef Primitive = js.HtmlDom

class JSRenderer extends ObjectModelRenderer<Primitive> {
	public function getRootPrimitive() :Primitive {
		return js.Lib.document.body;
	}

	override public function createPrimitive() :Primitive {
		// create new object
		var o = js.Lib.document.createElement("div");
		o.style.position="absolute";
		return o;
	}
	
	override public function clearPrimitive( p:Primitive ) {
		p.innerHTML="";
	}
	
	override public function attachPrimitive( parent:Primitive, child:Primitive ) :Void {
		if( child.parentNode!=null ) throw("Object "+child+" is already attached.");
		parent.appendChild( child );
	}
	
	public function draw( i:DrawingInstruction ) :Void {
		switch( i ) {
				
			case Translate(x,y):
				current.style.left = ""+Math.round(x);
				current.style.top = ""+Math.round(y);
				
			case ClipRect(w,h):
				current.style.overflow = "hidden";
				current.style.width = ""+Math.round(w);
				current.style.height = ""+Math.round(h);
		
			case Rect(x,y,w,h):
				var r = js.Lib.document.createElement("div");
				r.style.position="absolute";
				r.style.left = ""+Math.round(x);
				r.style.top = ""+Math.round(y);
				r.style.width = ""+Math.round(w);
				r.style.height = ""+Math.round(h);
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
	}
}
