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

package org.xinf.geom;

class Rectangle {
    public var x:Float;
    public var y:Float;
    public var w:Float;
    public var h:Float;
    
    public function new( _x:Float, _y:Float, _w:Float, _h:Float ) {
        x = _x;
        y = _y;
        w = _w;
        h = _h;
    }
    
    public function clone() : Rectangle {
        return new Rectangle( x, y, w, h );
    }
    
    public function offset( dx:Float, dy:Float ) : Void {
        x+=dx;
        y+=dy;
    }
    
    public function toString() : String {
        return("("+x+","+y+"-"+w+"x"+h+")");
    }
}
