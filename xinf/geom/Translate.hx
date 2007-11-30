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

package xinf.geom;

import xinf.geom.Types;

class Translate implements Transform {
    var x:Float;
    var y:Float;
    
    public function new( x:Float, y:Float ) {
        this.x = x;
        this.y = y;
    }
    
    public function getTranslation() {
        return { x:x, y:y };
    }
    public function getScale() {
        return { x:.0, y:.0 };
    }
    public function getMatrix() {
        return { a:1., b:0., c:0., d:1., tx:x, ty:y };
    }
    
    public function apply( p:TPoint ) :TPoint {
        return { x:p.x+x, y:p.y+y };
    }
    public function applyInverse( p:TPoint ) :TPoint {
        return { x:p.x-x, y:p.y-y };
    }
    
    public function toString() {
        return("translate("+x+","+y+")");
    }
}
