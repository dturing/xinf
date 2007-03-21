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

import cptr.CPtr;
import opengl.GL;

import xinf.inity.GLPolygon;

class Glyph {
    
    var polygon:GLPolygon;
    var displayList:Int;
        
    public var advance:Float;
    
    
    public function new( p:GLPolygon, adv:Float ) {
        polygon = p;
        advance = adv;
        
//        cache(1.0);
    }
    
    public function cache( pixelSize:Float ) :Void {
        GL.newList( displayList, GL.COMPILE );
        polygon.drawFilled();
        GL.endList();
        
        #if gldebug
            var e:Int = GL.getError();
            if( e > 0 ) {
                throw( "OpenGL Error: "+GLU.errorString(e) );
            }
        #end
    }
    
    public function render( s:Float ) :Float {
        if( displayList==null ) {
            displayList = GL.genLists(1);
            Font.cacheGlyph(this);
        }

        GL.callList(displayList);
// fake hinting        GL.translate( Math.round((advance*s))/s, .0, .0 );
        GL.translate( advance, .0, .0 );
        
        #if gldebug
            var e:Int = GL.getError();
            if( e > 0 ) {
                throw( "OpenGL Error: "+GLU.errorString(e) );
            }
        #end

        return( advance );
    }
}
