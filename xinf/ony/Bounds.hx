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

import xinf.event.Event;
import xinf.event.SimpleEventDispatcher;

/**
    Bounds describes the bounding rectangle of a xinfony Element.
    It derives from EventDispatcher, and will post POSITION_CHANGED and SIZE_CHANGED events.
**/
class Bounds extends SimpleEventDispatcher {
    /**
        Horizontal part of the top-left corner of the bounds. Read-only.
        Can be set using setPosition().
    **/
    public var x(default,null):Float;

    /**
        Vertical part of the top-left corner of the bounds. Read-only.
        Can be set using setPosition().
    **/
    public var y(default,null):Float;
    
    /**
        Width of the bounds rectangle. Read-only.
        Can be set using setSize().
    **/
    public var width(default,null):Float;

    /**
        Height of the bounds rectangle. Read-only.
        Can be set using setSize().
    **/
    public var height(default,null):Float;

    /**
        Constructor. Initializes to (0,0)-(0,0).
    **/
    public function new() {
        super();
        x = y = width = height = .0;
    }

    /**
        Set the position of the bounds rectangle. Will emit
        a POSITION_CHANGED Event.
    **/
    public function setPosition( _x:Float, _y:Float ) :Void {
		if( x!=_x || y!=_y ) { // FIXME premature optimization?
			x = _x;
			y = _y;
			postEvent( new GeometryEvent( GeometryEvent.POSITION_CHANGED, this, x, y ) );
		}
    }

    /**
        Set the size of the bounds rectangle. Will emit
        a SIZE_CHANGED Event.
    **/
    public function setSize( _width:Float, _height:Float ) :Void {
		if( width != _width || height != _height ) { // FIXME premature optimization?
			width = _width;
			height = _height;
			postEvent( new GeometryEvent( GeometryEvent.SIZE_CHANGED, this, width, height ) );
		}
    }
    
    public function toString() : String {
        return("("+x+","+y+"-"+width+"x"+height+")");
    }
}
