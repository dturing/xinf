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

package xinf.ul;

import xinf.erno.Renderer;

class ComponentContainer<Child:xinf.ony.Object> extends Pane {
    
    public var children(default,null):Array<Child>;    

    public function new() :Void {
        super();
        children = new Array<Child>();
    }
    
    public function attach( child:Child ) :Void {
        children.push( child );
        child.parent = cast(this);
        scheduleRedraw();
    }

    public function detach( child:Child ) :Void {
        children.remove( child );
        child.parent = null;
        scheduleRedraw();
    }

    override public function draw( g:Renderer ) :Void {
        g.startObject( _id );
            drawContents(g);
            
            // draw children
            for( child in children ) {
                g.showObject( child._id );
            }
            
        g.endObject();
        reTransform(g);
    }
}
