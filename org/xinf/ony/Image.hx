/***********************************************************************

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
   
***********************************************************************/

package org.xinf.ony;

class Image extends Element {

    private var uri:String;

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
