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

/*
enum Transform {
    Identity;
    Translate(x:Float,y:Float,?z:Float);
    Scale(x:Float,y:Float,?z:Float);
    Rotate(angle:Float,x:Float,y:Float,?z:Float);
    Concatenate( a:Transform, ?b:Transform, ?c:Transform, ?d:Transform );
}
*/

typedef Coordinates = { x:Float, y:Float, ?z:Float };

class Transform {
    public function getTranslation() {
        return { x:.0, y:.0 };
    }
    public function getScale() {
        return { x:.0, y:.0 };
    }
    public function getMatrix2d() {
        return [ .0, .0, .0, .0, .0, .0 ];
    }

    public function setTranslation( x:Float, y:Float, ?z:Float ) {
    }
    public function setScale( x:Float, y:Float, ?z:Float ) {
    }
    public function setMatrix2d( m:Array<Float> ) {
    }
}

class Translation {
    var x:Float, y:Float;
    public function getTranslation() {
        return { x:.0, y:.0 };
    }
    public function setTranslation( x:Float, y:Float, ?z:Float ) {
    }
    public function setMatrix2d( m:Array<Float> ) {
        
    }
}
