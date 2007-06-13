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
   Lesser General License or the LICENSE file for more details.
*/

package xinf.geom;

typedef TPoint = {
    var x:Float;
    var y:Float;
}

typedef TRectangle = {
    var l:Float;
    var t:Float;
    var r:Float;
    var b:Float;
}

typedef TMatrix = {
    var a:Float;
    var c:Float;
    var tx:Float;
    var b:Float;
    var d:Float;
    var ty:Float;
}
