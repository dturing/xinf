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

class TextureGlyph extends Glyph {

    var texture:Int;
    var w:Float;
    var h:Float;
    var x1:Float;
    var y1:Float;
    var x2:Float;
    var y2:Float;
    
    public function new( character:Int, font:Font, size:Int, hint:Bool ) {
        super(10);
        try {
        var b = font.renderGlyph( character, size<<6, hint );
        setBitmap( b, Math.round(size) );
        } catch(e:Dynamic) {
            trace(e);
        }
    }
    
    public function setBitmap( b:{ width:Int, height:Int, bitmap:Dynamic,x:Int,y:Int,advance:Float }, fontHeight:Int ) {
        advance = Math.round( b.advance/(1<<6) );
        var twidth = 2; while( twidth<b.width+2 ) twidth<<=1;
        var theight = 2; while( theight<b.height+2 ) theight<<=1;

        w = b.width/(twidth);
        h = b.height/(theight);
  
        var by = Math.ceil(b.y/(1<<6))/fontHeight;
        y1=-by;
        y2=y1+(b.height/fontHeight);

        var bx = Math.floor(b.x/(1<<6))/fontHeight;
        x1=bx;
        x2=x1+(b.width/fontHeight);

        var t:Dynamic = CPtr.uint_alloc(1);
        GL.genTextures(1,t);
        texture = CPtr.uint_get(t,0);

        GL.pushAttrib( GL.ENABLE_BIT );
        GL.enable( GL.TEXTURE_2D );
        
            GL.bindTexture( GL.TEXTURE_2D, texture ); // unneccessarryy?
            GL.texParameter( GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP );
            GL.texParameter( GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP );
            GL.texParameter( GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.NEAREST );
            GL.texParameter( GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.NEAREST );
            GL.texImage2D( GL.TEXTURE_2D, 0, GL.ALPHA, twidth, theight, 0, GL.ALPHA, GL.UNSIGNED_BYTE, null );
            GL.texSubImageFT( texture, 0, 0, b.width, b.height, b.bitmap );

        GL.popAttrib();

        #if gldebug
            var e:Int = GL.getError();
            if( e > 0 ) {
                throw( "OpenGL Error: "+opengl.GLU.errorString(e) );
            }
        #end
    }
    
    override public function render( s:Float ) :Float {
        if( texture!=null ) {
            GL.pushAttrib( GL.ENABLE_BIT );
                GL.enable( GL.TEXTURE_2D );
                GL.bindTexture( GL.TEXTURE_2D, texture );

                GL.begin( GL.QUADS );
                    GL.texCoord2( 0, 0 );
                    GL.vertex2  ( x1, y1 ); 
                    GL.texCoord2( w, 0 );
                    GL.vertex2  ( x2, y1 );
                    GL.texCoord2( w, h );
                    GL.vertex2  ( x2, y2 ); 
                    GL.texCoord2( 0, h );
                    GL.vertex2  ( x1, y2 ); 
                GL.end();
                
            GL.popAttrib();
        } else {
            trace("Trying to render TextureGlyph, but no bitmap set.");
        }
        return super.render(s);
    }
}
