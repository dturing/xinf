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

package xinf.svg;

import xinf.geom.Matrix;

class Transform {
    static var DEG_TO_RAD = ((2.*Math.PI)/360.);

    /* TODO: 
        rotate(angle,cx,cy)
        scale(sx [sy [cx [cy]]])
        fix translate( cx [cy] )
        inherit
        fit( l t r b [ preserve-aspect-ratio [left|center|right][top|middle|bottom]] )
    */
    static var translate = ~/translate\(([0-9\.\-]+),([0-9\.\-]+)\)/;
    static var rotate = ~/rotate\(([0-9\.\-]+)\)/; 
    static var matrix = ~/matrix\(([0-9e\.\-]+),([0-9e\.\-]+),([0-9e\.\-]+),([0-9e\.\-]+),([0-9e\.\-]+),([0-9e\.\-]+)\)/;
    static var scale = ~/scale\(([0-9\.\-]+),([0-9\.\-]+)\)/; 
    
    public static function parse( text:String ) :Matrix {
        var m = new Matrix().setIdentity();
        if( translate.match(text) ) {
            m.setTranslation( 
                Std.parseFloat(translate.matched(1)),
                Std.parseFloat(translate.matched(2))
                );
        } else if( matrix.match(text) ) {
            m.a = Std.parseFloat(matrix.matched(1));
            m.c = Std.parseFloat(matrix.matched(3));
            m.tx = Std.parseFloat(matrix.matched(5));
            m.b = Std.parseFloat(matrix.matched(2));
            m.d = Std.parseFloat(matrix.matched(4));
            m.ty = Std.parseFloat(matrix.matched(6));
        } else if( rotate.match(text) ) {
            m.setRotation( 
                Std.parseFloat(rotate.matched(1)) * DEG_TO_RAD
                );
        } else if( scale.match(text) ) {
            m.setScale(
                Std.parseFloat(scale.matched(1)),
                Std.parseFloat(scale.matched(2)) );
        } else {
            throw("invalid SVG transform '"+text+"'" );
        }
        return m;
    }
}