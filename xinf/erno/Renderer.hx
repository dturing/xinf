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

///////////////////////////////////////////////////////////////////
// font style

enum FontWeight {
	Normal;
	Bold;
}
enum FontSlant {
	Roman;
	Italic;
}


/**
	minimal support for changing text color (in the middle of a string).
	currently only supported by inity.
**/
typedef FontStyleChange = {
	var pos:Int;
	var color:Color;
}
typedef FontStyle = Array<FontStyleChange>



#if flash
	typedef NativeObject = flash.display.DisplayObject
	typedef NativeContainer = flash.display.DisplayObjectContainer
#else js
	import js.Dom;
	typedef NativeObject = js.HtmlDom
	typedef NativeContainer = js.HtmlDom
#else true
	typedef NativeObject = Int
	typedef NativeContainer = Int
#end



interface Renderer {
	// erno Instruction protocol
	function startNative( o:NativeContainer ) :Void;
	function endNative() :Void;

	function startObject( id:Int ) :Void;
	function endObject() :Void;
	function showObject( id:Int ) :Void;

	function translate( x:Float, y:Float ) :Void;
	function scale( x:Float, y:Float ) :Void;
	function rotate( angle:Float ) :Void;
	function transform( matrix:Matrix ) :Void;
	function clipRect( w:Float, h:Float ) :Void;

	function setFill( c:Color ) :Void;
	function setStroke( c:Color, width:Float ) :Void;
	function setFont( face:String, slant:FontSlant, weight:FontWeight, size:Float ) :Void;

	function startShape() :Void;
	function endShape() :Void;
	function startPath( x:Float, y:Float) :Void;
	function endPath() :Void;
	function close() :Void;
	function lineTo( x:Float, y:Float ) :Void;
	function quadraticTo( x1:Float, y1:Float, x:Float, y:Float ) :Void;
	function cubicTo( x1:Float, y1:Float, x2:Float, y2:Float, x:Float, y:Float ) :Void;
	
	function rect( x:Float, y:Float, w:Float, h:Float ) :Void;
	function circle( x:Float, y:Float, r:Float ) :Void;
	function text( x:Float, y:Float, text:String, ?style:FontStyle ) :Void;
	function image( img:ImageData, inRegion:{ x:Float, y:Float, w:Float, h:Float }, outRegion:{ x:Float, y:Float, w:Float, h:Float } ) :Void;
	
	function native( o:NativeObject ) :Void;
	
	
/* old enum-based interface (just for reference)
	public function draw( i:DrawingInstruction ) :Void {
	//	trace("unimplemented drawing instruction "+i);
	}
	
	public function drawList( instructions:Iterator<DrawingInstruction> ) :Void {
		for( i in instructions ) {
			draw( i );
		}
	}
*/
}