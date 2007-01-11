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

package xinf.ony;

import xinf.erno.Renderer;
import xinf.erno.Runtime;
import xinf.geom.Matrix;
import xinf.event.Event;
import xinf.event.SimpleEventDispatcher;

/**
    A Container is an Object that can contain other objects.
    You can constrain the type of children it accepts to any subclass of Object.
    <p>
        You can add and remove children with [attach()] and [detach()]
    </p>
**/

class Container<Child:Object> extends Object {
    
    public var children(default,null):Array<Child>;    

    /** Container constructor<br/>
        A simple Container will not display anything by itself,
        but can be used as a container object to group other Objects.
    **/
    public function new() :Void {
        super();
        children = new Array<Child>();
    }
    
    /** attach (add) a child Object<br/>
        Add 'child' to this object's list of children, inserts
        the child into the display hierarchy, similar to addChild in Flash 
        or appendChild in JavaScript/DOM.
        The new child will be added at the end of the list, so it will appear
        in front of all current children.
    **/
    public function attach( child:Child ) :Void {
        children.push( child );
        child.parent = this;
    // TODO: see Pane::resize    
        child.resize( child.size.x, child.size.y );
        scheduleRedraw();
    }

    /** detach (remove) a child Object<br/>
        Removes 'child' from this object's list of children. **/
    public function detach( child:Child ) :Void {
        children.remove( child );
        child.parent = null;
        scheduleRedraw();
    }

    
    /** draw the Object to the given [Renderer]<br/>
        You should usually neither call nor override this function,
        instead, schedule a redraw with [scheduleRedraw()] and 
        override [drawContents()] to draw stuff.
        **/
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
