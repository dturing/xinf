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

import xinf.ony.Object;
import xinf.ony.Container;
import xinf.ul.layout.Layout;
import xinf.event.GeometryEvent;

class Component extends xinf.style.StyleClassElement {
    var __parentSizeListener:Dynamic;
    var relayoutNeeded:Bool;
/*
    public function getPreferredSize() :{x:Float,y:Float} {
        return( size );
    }
    public function getMinimumSize() :{x:Float,y:Float} {
        return( {x:0,y:0} );
    }
    public function getMaximumSize() :{x:Float,y:Float} {
        return( {x:Math.POSITIVE_INFINITY,y:Math.POSITIVE_INFINITY} );
    }
*/    
    public var layout:Layout;
    public function new() {
        super();
        relayoutNeeded = true;
    }
    
    public function add( c:Component ) :Void {
        super.attach(c);
        var l = c.addEventListener( GeometryEvent.SIZE_CHANGED, onChildResize );
        c.__parentSizeListener = l;
    }
    public function remove( c:Component ) :Void {
        c.removeEventListener( GeometryEvent.SIZE_CHANGED, c.__parentSizeListener );
        super.detach(c);
    }
    
    public function getComponent( index:Int ) :Object {
        return children[index];
    }
    public function getComponents() :Iterator<Object> {
        return children.iterator();
    }
    
    function postResizeEvent() :Void {
        relayoutNeeded = true;
        postEvent( new GeometryEvent( GeometryEvent.SIZE_CHANGED, size.x, size.y ) );
    }
    function onChildResize( e:GeometryEvent ) :Void {
        var oldSize = size;
        if( layout!=null && relayoutNeeded ) {
        trace("relayout "+this );
            layout.layoutContainer( this );
            relayoutNeeded=false;
        }
        if( size != oldSize ) {
            postResizeEvent();
        }
    }
}
