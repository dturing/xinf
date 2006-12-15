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

import xinf.erno.Renderer;
import xinf.erno.ObjectModelRenderer;
import xinf.erno.Color;
import xinf.erno.ImageData;
import xinf.erno.FontStyle;
import xinf.geom.Matrix;

import js.Dom;
typedef Primitive = js.HtmlDom

class JSRenderer extends ObjectModelRenderer<Primitive> {
	public static var defaultRoot:Primitive;
	
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
	
	public function transform( matrix:Matrix ) {
		// FIXME (maybe): regards only translation
		current.style.left = ""+Math.round(matrix.m02);
		current.style.top = ""+Math.round(matrix.m12);
	}
	public function translate( x:Float, y:Float ) {
//		if( current.style.left != null ) throw("JS cannot translate more than once in an Object.");
		current.style.left = ""+Math.round(x);
		current.style.top = ""+Math.round(y);
	}
	public function clipRect( w:Float, h:Float ) {
		current.style.overflow = "hidden";
		current.style.width = ""+Math.max(0,Math.round(w));
		current.style.height = ""+Math.max(0,Math.round(h));
	}
		

	public function rect( x:Float, y:Float, w:Float, h:Float ) {
		var r = js.Lib.document.createElement("div");
		r.style.position="absolute";
		r.style.left = ""+Math.floor(x - (pen.strokeWidth/2));
		r.style.top = ""+Math.floor(y - (pen.strokeWidth/2));
		r.style.width = ""+Math.floor(w - (pen.strokeWidth/2));
		r.style.height = ""+Math.floor(h - (pen.strokeWidth/2));
		if( pen.fillColor != null ) {
			r.style.background = pen.fillColor.toRGBString();
		}
		if( pen.strokeWidth > 0 && pen.strokeColor != null ) {
			r.style.border = ""+pen.strokeWidth+"px solid "+pen.strokeColor.toRGBString();
		}
		current.appendChild( r );
	}
	
	public function text( x:Float, y:Float, text:String, ?style:FontStyle ) {
		// FIXME: textStyles
		var r = js.Lib.document.createElement("div");
		r.style.position="absolute";
		r.style.whiteSpace="nowrap";
		r.style.cursor="default";
		if( x!=null ) r.style.left = ""+Math.round(x);
		if( y!=null ) r.style.top = ""+Math.round(y);
		if( pen.fillColor != null )	r.style.color = pen.fillColor.toRGBString();
		if( pen.fontFace != null ) r.style.fontFamily = if( pen.fontFace=="_sans" ) "Bitstream Vera Sans, Arial, sans-serif" else pen.fontFace;pen.fontFace;
		if( pen.fontSlant == Italic ) r.style.fontStyle = "italic";
		if( pen.fontWeight == Bold ) r.style.fontWeight = "bold";
		if( pen.fontSize != null ) r.style.fontSize = ""+pen.fontSize+"px";
		r.innerHTML=text;
		current.appendChild(r);
	}
	
	public function image( img:ImageData, inRegion:{ x:Float, y:Float, w:Float, h:Float }, outRegion:{ x:Float, y:Float, w:Float, h:Float } ) {
		throw("unimplemented");
	}
	
	public function native( o:NativeObject ) {
		current.appendChild(o);
	}
}
