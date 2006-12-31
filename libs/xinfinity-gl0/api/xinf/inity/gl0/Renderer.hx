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

package xinf.inity.gl0;

import xinf.erno.Renderer;

/**
    'gl0' Xinferno renderer. 
    
    <nekobind 
        translator="Capitalize"
        prefix="gl0"
        nekoAbstract="__r"
        cStruct="gl0Renderer"
        dtor="destroy"
        module="xinfinity-gl0"
        />
    <nekobind:cHeader>
        #include &lt;xinfinity-gl0.h&gt;
    </nekobind:cHeader>
**/
extern class Renderer extends xinf.erno.BasicRenderer {
    /** <nekobind ctor="true"/> **/
    public static function createRenderer( width:Int, height:Int ) :Renderer;
    
    function startObject( id:Int ) :Void;
    function endObject() :Void;
    function showObject( id:Int ) :Void;

    function setTransform( id:Int, x:Float, y:Float, a:Float, b:Float, c:Float, d:Float ) :Void;
    function setTranslation( id:Int, x:Float, y:Float ) :Void;

    function clipRect( w:Float, h:Float ) :Void;

    function setFill( r:Float, g:Float, b:Float, a:Float ) :Void;
    function setStroke( r:Float, g:Float, b:Float, a:Float, width:Float ) :Void;
    function setFont( face:String, italic:Bool, bold:Bool, size:Float ) :Void;
    
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
    function text( x:Float, y:Float, text:String ) :Void;
//    function image( img:ImageData, inRegion:{ x:Float, y:Float, w:Float, h:Float }, outRegion:{ x:Float, y:Float, w:Float, h:Float } ) :Void;
    function startNative( o:Dynamic ) :Void;
    function endNative() :Void;

//    function native( o:NativeObject ) :Void;
}
