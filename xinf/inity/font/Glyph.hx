/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
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
