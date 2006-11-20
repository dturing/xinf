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

import xinf.erno.ImageData;
import xinf.inity.gdk.Pixbuf;
import xinf.inity.ColorSpace;

/** strictly any neko ImageData is already a texture. This class manages the texture though,
  ImageData only stores some values for direct access by the GLGraphicsContext **/
  
class Texture extends ImageData {
	// texture (id), twidth, theight, width and height are already defined in ImageData.
	
	public function initialize( w:Int, h:Int ) {
		width=w;
		height=h;
		
        twidth = 2; while( twidth<w ) twidth<<=1;
        theight = 2; while( theight<h ) theight<<=1;

		// generate texture id
        var t:Dynamic = CPtr.uint_alloc(1);
        GL.GenTextures(1,t);
        texture = CPtr.uint_get(t,0);

		GL.PushAttrib( GL.ENABLE_BIT );
        GL.Enable( GL.TEXTURE_2D );
		
			GL.BindTexture( GL.TEXTURE_2D, texture ); // unneccessarryy?
			GL.TexParameteri( GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP );
			GL.TexParameteri( GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP );
			GL.TexParameteri( GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.NEAREST );
			GL.TexParameteri( GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.NEAREST );
			GL.CreateTexture( texture, twidth, theight );

		GL.PopAttrib();
	}
	
	public function setData( data:Dynamic, pos:{x:Int,y:Int}, size:{x:Int,y:Int}, ?cspace:ColorSpace ) :Void {
		if( cspace==null ) cspace=BGRA;
	
		GL.PushAttrib( GL.ENABLE_BIT );
        GL.Enable( GL.TEXTURE_2D );
        GL.BindTexture( GL.TEXTURE_2D, texture );
		
        if( data != null ) {
            switch( cspace ) {
                case GRAY:
                    GL.TexSubImage2D_GRAY_BYTE( texture, pos, size, data );
                case RGB:
                    GL.TexSubImage2D_BYTE( texture, { pos:pos, size:size }, GL.RGB, data );
                case BGR:
                    GL.TexSubImage2D_BYTE( texture, { pos:pos, size:size }, GL.BGR, data );
                case RGBA:
                    GL.TexSubImage2D_RGBA_BYTE( texture, pos, size, data );
                case BGRA:
					GL.TexSubImage2D_BGRA_BYTE( texture, pos, size, data );
                default:
                    throw("unknown colorspace "+cspace );
            }
        }
		
		GL.PopAttrib();
		frameAvailable( data );
	}

	/* FIXME: image cache will keep images FOREVER. at least provide a way to flush! */
	public static var cache:Hash<Texture> = new Hash<Texture>();
    public static function newByName( filename:String ) :Texture {
		var r = cache.get(filename);
		if( r==null ) {
			r = newFromPixbuf( Pixbuf.newFromFile(filename) );
			trace("pixbuf: "+r);
			cache.set(filename,r);
		}
		return r;
	}
	
    public static function newFromPixbuf( pixbuf:Pixbuf ) :Texture {
		var r = new Texture();
		
		r.initialize( pixbuf.width, pixbuf.height );
        var cs = pixbuf.colorspace;
        var d = pixbuf.stealPixels();
		
		r.setData( d, {x:0, y:0}, {x:r.width,y:r.height}, cs );
		untyped r._buf = pixbuf;
        return r;
    }


}
