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

package xinf.erno;

import xinf.erno.Renderer;
import xinf.geom.Matrix;
import xinf.erno.FontStyle;

class BasicRenderer implements Renderer {
	public function new() :Void {
	}

	// erno Instruction protocol
	
	public function startNative( o:NativeContainer ) :Void {
		throw("unimplemented");
	}
	public function endNative() :Void {
		throw("unimplemented");
	}
	
	public function startObject( id:Int ) {
		throw("unimplemented");
	}
	public function endObject() {
		throw("unimplemented");
	}
	public function showObject( id:Int ) {
		throw("unimplemented");
	}

	public function setTransform( id:Int, transform:Matrix ) {
		throw("unimplemented");
	}
	public function clipRect( w:Float, h:Float ) {
		throw("unimplemented");
	}

	public function setFill( c:Color ) {
		throw("unimplemented");
	}
	public function setStroke( c:Color, width:Float ) {
		throw("unimplemented");
	}
	public function setFont( face:String, slant:FontSlant, weight:FontWeight, size:Float ) {
		throw("unimplemented");
	}

	public function startShape() {
		throw("unimplemented");
	}
	public function endShape() {
		throw("unimplemented");
	}
	public function startPath( x:Float, y:Float) {
		throw("unimplemented");
	}
	public function endPath() {
		throw("unimplemented");
	}
	public function close() {
		throw("unimplemented");
	}
	public function lineTo( x:Float, y:Float ) {
		throw("unimplemented");
	}
	public function quadraticTo( x1:Float, y1:Float, x:Float, y:Float ) {
		throw("unimplemented");
	}
	public function cubicTo( x1:Float, y1:Float, x2:Float, y2:Float, x:Float, y:Float ) {
		throw("unimplemented");
	}

	public function rect( x:Float, y:Float, w:Float, h:Float ) {
		throw("unimplemented");
	}
	public function circle( x:Float, y:Float, r:Float ) {
		throw("unimplemented");
	}
	public function text( x:Float, y:Float, text:String, ?style:FontStyle ) {
		throw("unimplemented");
	}
	public function image( img:ImageData, inRegion:{ x:Float, y:Float, w:Float, h:Float }, outRegion:{ x:Float, y:Float, w:Float, h:Float } ) {
		throw("unimplemented");
	}
	
	public function native( o:NativeObject ) {
		throw("unimplemented");
	}
}
