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

package xinf.ony.erno;

import xinf.erno.Renderer;

/**
    A Root-like Object, embeds a Xinfony display hierarchy
    into a Runtime-native Object.
**/
class Embed extends Group {
    
    private var root:NativeContainer;
    
    /**
        Constructor. Pass in a NativeContainer (a DisplayObjectContainer
        for Flash, a HtmlDom for JS, or a GLObject for Xinfinity); this Object
        will aquire it and use it as the root for this display hierarchy.
    **/
    public function new( o:NativeContainer ) :Void {
        super();
        root = o;
    }

    /**
        redraws the Object. This redefines the contents of the NativeContainer
        you passed to the constructor.
    **/
    override public function draw( g:Renderer ) :Void {
        g.startNative( root );
        for( child in children() ) {
            g.showObject( child.xid );
        }
        g.endNative();
    }
}
