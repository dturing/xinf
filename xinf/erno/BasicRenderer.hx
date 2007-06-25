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

/**
    BasicRenderer implements all functions
    of the <a href="Renderer.html">Renderer</a> interface to throw exceptions.
    It is used as a base class for other renderers (some, like JSRenderer,
    throw exceptions for functions that they cannot satisfy, like startShape()).
**/
class BasicRenderer implements Renderer {
    
    public function new() :Void {
    }
    
    private function unimplemented( ?func:String ) :Void {
        trace("unimplemented: "+func );
    }

    // erno Instruction protocol
    
    public function startNative( o:NativeContainer ) :Void {
        unimplemented("startNative");
    }
    
    public function endNative() :Void {
        unimplemented("endNative");
    }
    
    public function startObject( id:Int ) {
        unimplemented("startObject");
    }
    
    public function endObject() {
        unimplemented("endObject");
    }
    
    public function showObject( id:Int ) {
        unimplemented("showObject");
    }

    public function setTransform( id:Int, x:Float, y:Float, a:Float, b:Float, c:Float, d:Float ) :Void {
        unimplemented("setTransform");
    }
    
    public function setTranslation( id:Int, x:Float, y:Float ) :Void {
        unimplemented("setTranslation");
    }
    
    public function clipRect( w:Float, h:Float ) {
        unimplemented("clipRect");
    }

    public function setFill( r:Float, g:Float, b:Float, a:Float ) {
        unimplemented("setFill");
    }
    
    public function setStroke( r:Float, g:Float, b:Float, a:Float, width:Float ) {
        unimplemented("setStroke");
    }
    
    public function setFont( face:String, italic:Bool, bold:Bool, size:Float ) {
        unimplemented("setFont");
    }

    public function startShape() {
        unimplemented("startShape");
    }
    
    public function endShape() {
        unimplemented("endShape");
    }
    
    public function startPath( x:Float, y:Float) {
        unimplemented("startPath");
    }
    
    public function endPath() {
        unimplemented("endPath");
    }
    
    public function close() {
        unimplemented("close");
    }
    
    public function lineTo( x:Float, y:Float ) {
        unimplemented("lineTo");
    }
    
    public function quadraticTo( x1:Float, y1:Float, x:Float, y:Float ) {
        unimplemented("quadraticTo");
    }
    
    public function cubicTo( x1:Float, y1:Float, x2:Float, y2:Float, x:Float, y:Float ) {
        unimplemented("cubicTo");
    }

    public function arcTo( rx:Float, ry:Float, rotation:Float, largeArc:Bool, sweep:Bool, x:Float, y:Float ) {
        unimplemented("arcTo");
    }

    public function rect( x:Float, y:Float, w:Float, h:Float ) {
        unimplemented("rect");
    }

    public function roundedRect( x:Float, y:Float, w:Float, h:Float, rx:Float, ry:Float ) {
        unimplemented("roundedRect");
    }

    public function ellipse( x:Float, y:Float, rx:Float, ry:Float ) {
        unimplemented("ellipse");
    }
    
    public function text( x:Float, y:Float, text:String, format:TextFormat ) {
        unimplemented("text");
    }  
    
    public function image( img:ImageData, inRegion:{ x:Float, y:Float, w:Float, h:Float }, outRegion:{ x:Float, y:Float, w:Float, h:Float } ) {
        unimplemented("image");
    }
    
    public function native( o:NativeObject ) {
        unimplemented("native");
    }
    
}
