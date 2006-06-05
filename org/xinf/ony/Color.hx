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

signature IColor {
    var r:Float;
    var g:Float;
    var b:Float;
    var a:Float;

    function toRGBInt() : Int;
}

class Color {
    public var r:Float;
    public var g:Float;
    public var b:Float;
    public var a:Float;

    public function new() {
        r = g = b = a = .0;
    }
    
    public function fromRGBInt( c:Int ) {
        r = ((c&0xff0000)>>16)/0xff;
        g = ((c&0xff00)>>8)/0xff;
        b =  (c&0xff)/0xff;
        a = 1.;
    }

    public function toRGBInt() : Int {
        return ( Math.round(r*0xff) << 16 ) | ( Math.round(g*0xff) << 8 ) | Math.round(b*0xff);
    }

    public function toRGBString() : String {
        return("rgb("+Math.round(r*0xff)+","+Math.round(g*0xff)+","+Math.round(b*0xff)+")");
    }
    
    public function toString() : String {
        return("("+r+","+g+","+b+","+a+")");
    }
}
