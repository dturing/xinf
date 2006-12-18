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

package xinf.inity;

enum ColorSpace {
    RGB;
    RGBA;
    BGR;
    BGRA;
    GRAY;
    Other(depth:Int,channels:Int);
}

class ColorSpaceTools {
    
    public static function defaultBytesPerRow( cs:ColorSpace, width:Int ) :Int {
        return
            switch( cs ) {
                case RGB:
                    width*3;
                case RGBA:
                    width*4;
                case BGR:
                    width*3;
                case BGRA:
                    width*4;
                case GRAY:
                    width;
                case Other(d,c):
                    return (d*Math.ceil(c/8)*width);
            }
    }
    
}