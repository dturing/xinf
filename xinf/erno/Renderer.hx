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

import xinf.geom.Types;
import xinf.geom.Transform;
import xinf.erno.FontStyle;

#if flash
    typedef NativeObject = flash.display.DisplayObject
    typedef NativeContainer = flash.display.DisplayObjectContainer
#else js
    import js.Dom;
    typedef NativeObject = js.HtmlDom
    typedef NativeContainer = js.HtmlDom
#else true
    typedef NativeObject = xinf.inity.GLObject
    typedef NativeContainer = xinf.inity.GLObject
#end


/**
    A xinferno Renderer describes the drawing protocol used within all of xinf.
    <p>
        You will likely be confronted with it mostly when overriding [xinf.ony.Object.drawContents()],
        where you will be given a Renderer to use for drawing your stuff. In that case, the 
        Renderer will already be set to the right context, and you shouldn't use the [*Object()] or 
        [setTransform()] methods. Instead, you can start right away with setting color and font,
        defining shapes, or drawing primitives.
    </p>
**/
interface Renderer {
    
    function startObject( id:Int ) :Void;
    function endObject() :Void;
    function showObject( id:Int ) :Void;

    function setTransform( id:Int, transform:Transform ) :Void;
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
    
    function startNative( o:NativeContainer ) :Void;
    function endNative() :Void;
    
    function native( o:NativeObject ) :Void;

}