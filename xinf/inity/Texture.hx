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

import xinf.support.Pixbuf;
import cptr.CPtr;
import opengl.GL;
import xinf.erno.ImageData;
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
        GL.genTextures(1,t);
        texture = CPtr.uint_get(t,0);

        GL.pushAttrib( GL.ENABLE_BIT );
        GL.enable( GL.TEXTURE_2D );
        
            GL.bindTexture( GL.TEXTURE_2D, texture ); // unneccessarryy?
            GL.texParameter( GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP );
            GL.texParameter( GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP );
            GL.texParameter( GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.NEAREST );
            GL.texParameter( GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.NEAREST );
            GL.texImage2D( GL.TEXTURE_2D, 0, GL.RGBA, twidth, theight, 0, GL.RGB, GL.UNSIGNED_BYTE, null );

        GL.popAttrib();
    }
    
    public function setData( data:Dynamic, pos:{x:Int,y:Int}, size:{x:Int,y:Int}, ?cspace:ColorSpace ) :Void {
        if( cspace==null ) cspace=BGRA;
    
        GL.pushAttrib( GL.ENABLE_BIT );
        GL.enable( GL.TEXTURE_2D );
        GL.bindTexture( GL.TEXTURE_2D, texture );
        
        if( data != null ) {
            switch( cspace ) {
                case RGB:
                    GL.texSubImageRGB( texture, pos.x, pos.y, size.x, size.y, data );
                case RGBA:
                    GL.texSubImageRGBA( texture, pos.x, pos.y, size.x, size.y, data );
                default:
                    throw("unknown colorspace "+cspace );
            }
        }
        
        GL.popAttrib();
        frameAvailable( data );
    }

    /* FIXME: image cache will keep images FOREVER. at least provide a way to flush! */
    public static var cache:Hash<Texture> = new Hash<Texture>();
    
    public static function newByName( url:String ) :Texture {
        var r = cache.get(url);
        if( r==null ) {
            var data:String;
            var u = url.split("://");
            if( u.length == 1 ) {
                // local file
                data = neko.io.File.getContent( url );
            } else {
                switch( u[0] ) {
                    case "file":
                        data = neko.io.File.getContent( u[1] );
                    case "resource":
                        data = Std.resource(u[1]);
                    case "http":
                        var req = new xinf.inity.http.HttpRequest();
                        var reply = req.request( new xinf.inity.http.URL( url ) );
                        data = reply.data;
                    default:
                        throw("unhandled protocol for image loading: "+u[0] );
                }
            }
            if( data == null || data.length==0 ) {
                throw("could not load: "+url );
            }
            r = newFromPixbuf( Pixbuf.newFromCompressedData(data) );
            cache.set(url,r);
        }
        return r;
    }
    
    public static function newFromPixbuf( pixbuf:Pixbuf ) :Texture {
        var r = new Texture();
        
        r.initialize( pixbuf.getWidth(), pixbuf.getHeight() );
        var cs = if( pixbuf.getHasAlpha()>0 ) RGBA else RGB;
        var d = pixbuf.copyPixels(); // FIXME: maybe we dont even need to copy the data, as we set it to texture right away
        r.setData( d, {x:0, y:0}, {x:r.width,y:r.height}, cs );
        return r;
    }

}
