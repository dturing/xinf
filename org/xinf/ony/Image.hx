/* 
   xinf is not flash.
   Copyright (c) 2006, Daniel Fischer.
 
   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.
																			
   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; withot even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU		
   Lesser General Public License or the LICENSE file for more details.
*/

package org.xinf.ony;

#if js
import js.Dom;
#end

/**
    Image is the xinfony Element that will display an (surprise!) Image.
    It's bounds rectangle, if not changed by your application's code, will be
    set to the image's native size (FIXME: is this already so for flash/js?).
    If you change the bounds, the image will be scaled.
**/
class Image extends Element {

    private var uri:String;

    /**
        Constructor. The 'src' parameter is the key here: for xinfinity 
        and JavaScript, it is a (relative) URL path to the image file. 
        For Flash, it is the "linkage ID" of the image. Note that linkage
        IDs can contain slashes ('/'), so if you embed images properly 
        for flash, you can use the same src parameter for any runtime here.
    **/
    public function new( name:String, parent:Element, src:String ) :Void {
        uri = src;
        super( name, parent );
    }
    
    private function createPrimitive() :Dynamic {
        #if neko
            return new org.xinf.inity.Image( uri );
        #else js
            var i:js.HtmlDom = js.Lib.document.createElement("img");
            untyped i.src = uri;
            return i;
        #else flash
            if( parent == null ) throw( "Flash runtime needs a parent on creation" );
            return parent._p.attachMovie(uri,name,parent._p.getNextHighestDepth());
        #end
    }

    #if flash
        private function redraw() :Void {
            _p._width = bounds.width;
            _p._height = bounds.height;
        }
    #end
}
