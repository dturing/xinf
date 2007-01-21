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

#if flash
    typedef NativeObject = flash.display.DisplayObject
    typedef NativeContainer = flash.display.DisplayObjectContainer
#else js
    import js.Dom;
    typedef NativeObject = js.HtmlDom
    typedef NativeContainer = js.HtmlDom
#else true
    /**
        NativeObject is a typedef that is defined depending on the runtime you compile for.
        <ul>
            <li>for Xinfinity, it is = <a href="../inity/GLObject.html">xinf.inity.GLObject</a></li>
            <li>for Flash, it is = <a href="../../flash/display/DisplayObject.html">flash.display.DisplayObject</a></li>
            <li>for JavaScript, it is = <a href="../../js/HtmlDom.html">js.HtmlDom</a></li>
        </ul>
        
        It is used to embed native objects into xinf content, 
        similar to <a href="NativeContainer.html">NativeContainer</a>
        
        <br/><br/>
        
        (ignore the following, I haven't figured how to patch haxedoc to accept this construct).
    **/
    typedef NativeObject = Dynamic
    
    /**
        NativeContainer is a typedef that is defined depending on the runtime you compile for.
        <ul>
            <li>for Xinfinity, it is = <a href="../inity/GLObject.html">xinf.inity.GLObject</a></li>
            <li>for Flash, it is = <a href="../../flash/display/DisplayObjectContainer.html">flash.display.DisplayObjectContainer</a></li>
            <li>for JavaScript, it is = <a href="../../js/HtmlDom.html">js.HtmlDom</a></li>
        </ul>
        
        It is used to embed xinf content into native objects, 
        similar to <a href="NativeObject.html">NativeObject</a>
        
        <br/><br/>
        
        (ignore the following, I haven't figured how to patch haxedoc to accept this construct).
    **/
    typedef NativeContainer = Dynamic
#end


/**
    The xinferno Renderer interface describes the drawing protocol used within all of xinf.
    <p>
        You will likely be confronted with it mostly when overriding [xinf.ony.Object.drawContents()],
        where you will be given a Renderer to use for drawing your stuff. In that case, the 
        Renderer will already be set to the right context, and you shouldn't use the [*Object()] or 
        [setTransform()] methods. Instead, you can start right away with setting color and font,
        defining shapes, or drawing primitives.
    </p>
    <p>
        <b>Warning:</b>
        This documentation describes how the renderers <i>should</i> behave, it currently cannot
        be guaranteed that everything works as specified on every renderer. Also, at least the
        <a href="../js/JSRenderer.html">JavaScript renderer</a> will ignore shape instructions
        and transformations other than translation (movement).
    </p>
**/
interface Renderer {
    
    /**
        Start an object definition. Must be matched with a corresponding endObject().
        You can define only one object at a time. The ID must be globally unique, and
        should be acquired with <a href="Runtime.html">Runtime</a>.getNextId().
        If no object with the ID exists, it will be created. If it does exist,
        it will be cleared. Until a matching endObject() is called, the object
        is the "current object".
    **/
    function startObject( id:Int ) :Void;
    
    /**
        End an object definition.
    **/
    function endObject() :Void;
    
    /**
        Show the object with the specified ID inside the current object.
        (For Object-model renderers, this does something like addChild/appendChild.)
    **/
    function showObject( id:Int ) :Void;

    /**
        (Re-)Set the transformation of the object with the specified ID.
    **/
    function setTransform( id:Int, x:Float, y:Float, a:Float, b:Float, c:Float, d:Float ) :Void;

    /**
        (Re-)Set the translation of the object with the specified ID.
    **/
    function setTranslation( id:Int, x:Float, y:Float ) :Void;

    /**
        Set the clipping rectangle (mask) of the current object. If this
        is never called within an object definition, contents will not be
        clipped.
    **/
    function clipRect( w:Float, h:Float ) :Void;

    /**
        Set the fill color for following drawing operations. If you specify [null],
        or leave away the argument, shapes won't be filled.
    **/
    function setFill( r:Float, g:Float, b:Float, a:Float ) :Void;
    
    /**
        Set the stroke (line) color and width (thickness) for following drawing operations. 
        If you specify [null] for c,
        [0] or [null] for width or leave away the arguments, shapes' contours won't be stroked.
    **/
    function setStroke( r:Float, g:Float, b:Float, a:Float, width:Float ) :Void;
    
    /**
        Start a shape definition. A shape can consist of multiple polygons (paths) that are potentially
        overlapping.
        Every [startShape] must be matched with a [endShape], within a shape definition only calls
        to [startPath] and [endPath] may be used (and those allowed within them).
    **/
    function startShape() :Void;
    
    /**
        End the current shape definition. Can be thought to fill/stroke the defined shape
        with the currently set styles.
    **/
    function endShape() :Void;
    
    /**
        Start a path definition. Must only be called in between calls to [startShape]/[endShape], and
        be matched with an [endPath]. A path is a single polygon within a shape. The path
        will start at the specified coordinates ([x],[y]). Within a path definition the only
        allowed calls are [lineTo], [quadraticTo], [cubicTo] and [close].
    **/
    function startPath( x:Float, y:Float) :Void;
    
    /**
        End the current path definition.
    **/
    function endPath() :Void;

    /**
        Close the currently defined path. May only occur between calls to [startPath]/[endPath].
        Effectively issues a [lineTo] to the path's origin that was specified with [startPath].
    **/
    function close() :Void;

    /**
        Adds a line to the specified absolute coordinates ([x],[y]) to the currently defined path.
        May only occur between calls to [startPath]/[endPath].
    **/
    function lineTo( x:Float, y:Float ) :Void;
    
    /**
        Adds a quadratic Bezier curve to the specified absolute coordinates ([x],[y]) 
        to the currently defined path, using ([x1],[y1]) as the curve control point.
        May only occur between calls to [startPath]/[endPath].
    **/
    function quadraticTo( x1:Float, y1:Float, x:Float, y:Float ) :Void;
    
    /**
        Adds a cubic Bezier curve to the specified absolute coordinates ([x],[y]) 
        to the currently defined path, using ([x1],[y1]) and ([x2],[y2]) as curve control points.
        May only occure between calls to [startPath]/[endPath].
    **/
    function cubicTo( x1:Float, y1:Float, x2:Float, y2:Float, x:Float, y:Float ) :Void;
    
    /**
        Draws a rectangle with the current fill and stroke styles within the current
        object. The rectangle's upper left corner will be at ([x],[y]), and it will
        be [w] units wide and [h] units high.
    **/
    function rect( x:Float, y:Float, w:Float, h:Float ) :Void;

    /**
        Draws a circle with the current fill and stroke styles within the current
        object. The circles center will be at ([x],[y]), and it will
        have a radius of [r] units.
    **/
    function circle( x:Float, y:Float, r:Float ) :Void;

    /**
        Draws a string of text at coordinates ([x],[y]) within the current object,
        using the current font style (family, weight, slant and size) and the
        current fill color. You can optionally pass in a <a href="FontStyle.html">FontStyle</a>
        for changing the font color in the middle of the string. The string may contain
        '\n's to span multiple lines.
    **/
    function text( x:Float, y:Float, text:String, format:TextFormat ) :Void;
    
    /**
        Draw the specified [inRegion] of the given <a href="ImageData.html">ImageData</a> 
        object to the given [outRegion]. 
        FIXME: make inRegion/outRegion optional, potentially swap (so that one can leave
        away only inRegion).
    **/
    function image( img:ImageData, inRegion:{ x:Float, y:Float, w:Float, h:Float }, outRegion:{ x:Float, y:Float, w:Float, h:Float } ) :Void;
    
    /**
        Start redefining the contents of the given <a href="NativeContainer.html">NativeContainer</a>.
        Similar to [startObject()], this clears the given container, and must be matched
        by a corresponding [endNative()]. [startNative]/[endNative] allow you to use a
        Xinferno Renderer to fill a runtime-specific graphic object.
        <br/><b>Note:</b> this functionality is experimental, and might well change.
        You should probably stick to using <a href="../ony/Embed.html">xinf.ony.Embed</a>
        to place your xinf content within native structures meanwhile.
    **/
    function startNative( o:NativeContainer ) :Void;
    
    /**
        End the content definition of a native container.
    **/
    function endNative() :Void;

    /**
        Add the given <a href="NativeObject.html">NativeObject</a> to the current object.
        This allows you to embed native content (i.e., arbitrary DisplayObjects in Flash,
        or arbitrary HTML content for JavaScript) within xinferno content.
        <br/><b>Note:</b> this functionality is experimental, and might well change.
        You should probably stick to using <a href="../ony/Native.html">xinf.ony.Native</a>
        to place your native structures within xinf content meanwhile.
    **/
    function native( o:NativeObject ) :Void;
}
