/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.inity;

import xinf.support.Pixbuf;
import cptr.CPtr;
import opengl.GL;
import opengl.GLU;
import xinf.erno.ImageData;
import xinf.event.FrameEvent;
import xinf.event.ImageLoadEvent;
import xinf.inity.ColorSpace;

/** strictly any neko ImageData is already a texture. This class manages the texture though,
  ImageData only stores some values for direct access by the GLGraphicsContext **/
  
class Texture extends ImageData {
    // texture (id), twidth, theight, width and height are already defined in ImageData.
    
	// FIXME: initialize might be called again and again to reinit; take care of memory handling!
	
    public function initialize( w:Int, stride:Int, h:Int, cspace:ColorSpace ) {
        width=w;
        height=h;
        
        twidth = 2; while( twidth<stride ) twidth<<=1;
        theight = 2; while( theight<h ) theight<<=1;

        // generate texture id
        var t:Dynamic = CPtr.uint_alloc(1);
        GL.genTextures(1,t); // FIXME: delete this at some point...
        texture = CPtr.uint_get(t,0);
        var e:Int = GL.getError();
        if( e > 0 ) { throw("could not create texture"); }
        
        /* If this happens, likely the GL context isnt initialized yet. 
            Might be the cause for white rectangles instead of glyphs in text.. */
        if( texture>1000000 ) throw("unlikely texture ID: "+texture ); 
            

        GL.pushAttrib( GL.ENABLE_BIT );
        GL.enable( GL.TEXTURE_2D );
        
        var internalFormat = switch( cspace ) {
				case RGB: GL.RGB;
				case RGBA: GL.RGBA;
				case BGR: GL.RGB;
				case BGRA: GL.RGBA;
				default: GL.RGBA;
			}
        
            GL.bindTexture( GL.TEXTURE_2D, texture ); // unneccessarryy?
            GL.texParameter( GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP );
            GL.texParameter( GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP );
            GL.texParameter( GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.NEAREST );
            GL.texParameter( GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.NEAREST );
            GL.texImage2D( GL.TEXTURE_2D, 0, internalFormat, twidth, theight, 0, GL.RGB, GL.UNSIGNED_BYTE, null );

        GL.popAttrib();
        
        #if gldebug
            var e:Int = GL.getError();
            if( e > 0 ) {
                throw( "OpenGL Error: "+GLU.errorString(e) );
            }
        #end
    }
    
    public function setData( data:Dynamic, pos:{x:Int,y:Int}, size:{x:Int,y:Int}, stride:Int, ?cspace:ColorSpace ) :Void {
        if( cspace==null ) cspace=RGBA;
    
        GL.pushAttrib( GL.ENABLE_BIT );
        GL.enable( GL.TEXTURE_2D );
        GL.bindTexture( GL.TEXTURE_2D, texture );

        if( data != null ) {
            switch( cspace ) {
                case RGB:
                    GL.texSubImageRGB( texture, pos.x, pos.y, size.x, size.y, data );
                case BGR:
                    GL.texSubImageBGR( texture, pos.x, pos.y, size.x, size.y, data );
                case RGBA:
                    GL.texSubImageRGBA( texture, pos.x, pos.y, size.x, size.y, data );
                case BGRA:
                    GL.texSubImageBGRA( texture, pos.x, pos.y, size.x, size.y, data );
                case GRAY:
                    GL.texSubImageGRAY( texture, pos.x, pos.y, size.x, size.y, data );
                default:
                    throw("unknown colorspace "+cspace );
            }
        }
        
        GL.popAttrib();

        #if gldebug
            var e:Int = GL.getError();
            if( e > 0 ) {
                throw( "OpenGL Error trying to set texture #"+texture+": "+GLU.errorString(e) );
            }
        #end
        
        frameAvailable( data );
    }

    /* FIXME: image cache will keep images FOREVER. at least provide a way to flush! */
    public static var cache:Hash<Texture> = new Hash<Texture>();
    
    public static function newByName( url:String ) :Texture {
	    try {
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
                            data = haxe.Http.request(url);
                        default:
                            throw("unhandled protocol for image loading: "+u[0] );
                    }
                }
                if( data == null || data.length==0 ) {
                    throw("Could not load: "+url );
                }
				var p = Pixbuf.newFromCompressedData( neko.Lib.haxeToNeko(data) );
				r = newFromPixbuf( p );
                cache.set(url,r); // FIXME
				
				// trigger LOADED at next frame
				var l:Dynamic;
				l = xinf.erno.Runtime.addEventListener( FrameEvent.ENTER_FRAME, function(e) {
					xinf.erno.Runtime.removeEventListener( FrameEvent.ENTER_FRAME, l );
					r.postEvent( new ImageLoadEvent( ImageLoadEvent.LOADED, r ) );
				});
            }
            return r;
        } catch( e:Dynamic ) {
            throw("Error loading '"+url+": "+e );
        }
    }
    
    public static function newFromPixbuf( pixbuf:Pixbuf ) :Texture {
        var r = new Texture();
        
        var w = pixbuf.getWidth();
        var h = pixbuf.getHeight();
        var cs = if( pixbuf.getHasAlpha()>0 ) RGBA else RGB;
        var stride = pixbuf.getRowstride();
		if( pixbuf.getHasAlpha()>0 ) stride/=4; // FIXME: no korrekt (check with software renderer)
		else stride/=3;
		
        r.initialize( w, stride, h, cs );
        var d = pixbuf.copyPixels(); // FIXME: maybe we dont even need to copy the data, as we set it to texture right away
		r.setData( d, {x:0, y:0}, {x:stride,y:h}, stride, cs );
        return r;
    }

}
