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
import xinf.geom.Point;

import xinf.inity.Texture;

class BitmapData extends Texture {
    private var _d:Dynamic;
 
	public function new( data:Dynamic, w:Int, h:Int, cspace:ColorSpace ) {
		_d = data;
        var tw = 2; while( tw<w ) tw<<=1;
        var th = 2; while( th<w ) th<<=1;

        var t:Dynamic = CPtr.uint_alloc(1);
        GL.GenTextures(1,t);
        var texture:Int = CPtr.uint_get(t,0);

		GL.PushAttrib( GL.ENABLE_BIT );
		
        GL.Enable( GL.TEXTURE_2D );
        GL.BindTexture( GL.TEXTURE_2D, texture );
	    
        GL.TexParameteri( GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP );
        GL.TexParameteri( GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP );
        GL.TexParameteri( GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.NEAREST );
	    GL.TexParameteri( GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.NEAREST );
        
        GL.CreateTexture( texture, tw, th );

        if( _d != null ) {
            switch( cspace ) {
                case RGB:
                    GL.TexSubImage2D_RGB_BYTE( texture, new Point(0,0), new Point(w,h), _d );
                case RGBA:
                    GL.TexSubImage2D_RGBA_BYTE( texture, new Point(0,0), new Point(w,h), _d );
                default:
                    throw("unknown colorspace");
            }
        } else {
            throw("data is null");
        }

		GL.PopAttrib();

		super(w,h,tw,th,texture);
	}
	

	/* FIXME: image cache will keep images FOREVER. at least provide a way to flush! */
	public static var cache:Hash<BitmapData> = new Hash<BitmapData>();
    public static function newByName( filename:String ) :BitmapData {
		var r:BitmapData;
		r = cache.get(filename);
		if( r==null ) {
			r = newFromFile( filename );
			cache.set(filename,r);
		}
		return r;
	}
	
    public static function newFromFile( filename:String ) :BitmapData {
        var err = GdkPixbuf.gdk_pixbuf_create_error();
		try {
			var data = neko.File.getContent( filename );
			return newFromStringData( data );
		} catch( e:Dynamic ) {
			trace("Couldn't read: "+e );
			return null;
		}
	}
	
    public static function newFromStringData( data:String ) :BitmapData {
		var pixbufLoader = GdkPixbuf.gdk_pixbuf_loader_new();
        
        var err = GdkPixbuf.gdk_pixbuf_create_error();
        try {
            GdkPixbuf.gdk_pixbuf_loader_write( pixbufLoader, untyped data.__s, data.length, err );
            GdkPixbuf.gdk_pixbuf_loader_close( pixbufLoader, err );
        } catch( e:Dynamic ) {
            trace("pixbufLoader: exc "+e+", err "+GdkPixbuf.gdk_pixbuf_get_error( err ) );
        }
        
        var pixbuf = GdkPixbuf.gdk_pixbuf_loader_get_pixbuf( pixbufLoader );        
       
        var msg = GdkPixbuf.gdk_pixbuf_get_error(err);
        if( msg ) throw(msg);
        
        var w = GdkPixbuf.gdk_pixbuf_get_width( pixbuf );
        var h = GdkPixbuf.gdk_pixbuf_get_height( pixbuf );
        var f = if( GdkPixbuf.gdk_pixbuf_get_has_alpha(pixbuf) ) RGBA else RGB;
        var d = GdkPixbuf.gdk_pixbuf_get_pixels_cptr( pixbuf );
        
        // FIXME: we steal pixel data, but the pixbuf structure should be unref'd.
        return( new BitmapData( d, w, h, f ) );
    }
    
    public static function __init__() :Void {
        GdkPixbuf.g_type_init();
    }
}
