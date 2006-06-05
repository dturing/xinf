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

import org.xinf.event.Event;
import org.xinf.event.EventDispatcher;

class Bounds extends EventDispatcher {
    public var x:Float;
    public var y:Float;
    public var width:Float;
    public var height:Float;

    public function new() {
        super();
        x = y = width = height = .0;
    }

    public function setPosition( _x:Float, _y:Float ) :Void {
        x = _x;
        y = _y;
        postEvent( "positionChanged", { x:x, y:y } );
    }
    public function setSize( _width:Float, _height:Float ) :Void {
        width = _width;
        height = _height;
        postEvent( "sizeChanged", { width:width, height:height } );
    }
    
    public function toString() : String {
        return("("+x+","+y+"-"+width+"x"+height+")");
    }
}
