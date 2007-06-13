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

import js.Dom;

class JSTextFormat extends xinf.erno.TextFormat {
    var measure:js.HtmlDom;

    override public function apply( to:js.HtmlDom ) :Void {
        to.style.fontFamily = if( family =="_sans" ) "Bitstream Vera Sans, Arial, sans-serif" else family;
        to.style.fontStyle = if( italic ) "italic" else "normal";
        to.style.fontWeight = if( bold ) "bold" else "normal";
        to.style.fontSize = size;
    }


    public function new( ?family:String,  ?size:Float, ?bold:Bool, ?italic:Bool ) :Void {
        super( family, size, bold, italic );
        
        measure = js.Lib.document.createElement("div");
        measure.style.position="absolute";
        measure.style.bottom="2000";
        measure.style.background="#fff";
        js.Lib.document.body.appendChild( measure );
    }
    
    
    override public function textSize( text:String ) :{ x:Float, y:Float } {
        assureLoaded();
        apply( measure ); // FIXME: move to load(), for flash also (assigning the format to measure)?
        measure.innerHTML = text.split("\n").join("<br/>");
        return {x:1.*measure.offsetWidth,y:1.*measure.offsetHeight};
    }

    override public function load() :Void {
    }
}
