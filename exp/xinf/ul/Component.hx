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

class Component extends Container<Object> {
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
    
    public function add( c:Component ) :Void {
        super.attach(c);
    }
    public function remove( c:Component ) :Void {
        super.detach(c);
    }
    
    public function getComponent( index:Int ) :Object {
        return children[index];
    }
    public function getComponents() :Iterator<Object> {
        return children.iterator();
    }
    
    override public function resize( x:Float, y:Float ) :Void {
        if( x!=size.x || y!=size.y ) {
            super.resize(x,y);
            trace(""+this+"::Resized");
//            postEvent( new GeometryEvent( GeometryEvent.SIZE_CHANGED, x, y ) );
        }
//        if( layout!=null ) layout.layoutContainer( this );
    }
}
