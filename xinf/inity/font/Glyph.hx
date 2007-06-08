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

package xinf.inity.font;

import opengl.GL;

class Glyph {
    public var advance:Float;
    
    public function new( adv:Float ) {
        advance = adv;
    }
    
    public function render( s:Float ) :Float {

        // "implement here"

        GL.translate( advance/s, .0, .0 );
        
        #if gldebug
            var e:Int = GL.getError();
            if( e > 0 ) {
                throw( "OpenGL Error: "+opengl.GLU.errorString(e) );
            }
        #end

        return( advance );
    }
}
