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

enum ColorSpace {
    RGB;
    RGBA;
}

class BitmapData {
    private var _d:Dynamic;
    public var width(default,null):Int;
    public var height(default,null):Int;

    private var texture:Int;
    private var twidth:Int;
    private var theight:Int;
    private var cspace:ColorSpace;

    public function new( data:Dynamic, w:Int, h:Int, cs:ColorSpace ) {
        _d = data;
        width = w;
        height = h;
        cspace = cs;
        
        trace("new BitmapData "+w+"/"+h );
        createTexture();
    }

    public function createTexture() {
        twidth = 2; while( twidth<width ) twidth<<=1;
        theight = 2; while( theight<height ) theight<<=1;

        var t:Dynamic = CPtr.uint_alloc(1);
        GL.GenTextures(1,t);
        texture = CPtr.uint_get(t,0);

        GL.Enable( GL.TEXTURE_2D );
        GL.BindTexture( GL.TEXTURE_2D, texture );
	    
        GL.TexParameteri( GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.LINEAR );
	    GL.TexParameteri( GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.LINEAR );
        
        GL.CreateTexture( texture, twidth, theight );

        if( _d != null ) {
            switch( cspace ) {
                case RGB:
                    GL.TexSubImage2D_RGB_BYTE( texture, new Point(0,0), new Point(width,height), _d );
                case RGBA:
                    GL.TexSubImage2D_RGBA_BYTE( texture, new Point(0,0), new Point(width,height), _d );
                default:
                    throw("unknown colorspace");
            }
        } else {
            throw("data is null");
        }

 //       GL.BindTexture( GL.TEXTURE_2D, 0 );
        GL.Disable( GL.TEXTURE_2D );
    }
    
    public function render( w:Float, h:Float, rx:Float, ry:Float, rw:Float, rh:Float ) {
//        trace("BitmapData:render "+texture+" - "+w+","+h+" // "+rx+","+ry+" "+rw+","+rh );
        var tx1:Float = (rx/twidth)*w;
        var ty1:Float = (ry/theight)*h;
        var tx2:Float = ( (rw+rx) / twidth ) * w * (width/w);
        var ty2:Float = ( (rh+ry) / theight ) * h * (height/h);

        GL.Enable( GL.TEXTURE_2D );
        GL.BindTexture( GL.TEXTURE_2D, texture );

        GL.Begin( GL.QUADS );
            GL.TexCoord2f( tx1, ty1 );
            GL.Vertex2f  (   0,   0 ); 
            GL.TexCoord2f( tx2, ty1 );
            GL.Vertex2f  (   w,   0 ); 
            GL.TexCoord2f( tx2, ty2 );
            GL.Vertex2f  (   w,   h ); 
            GL.TexCoord2f( tx1, ty2 );
            GL.Vertex2f  (   0,   h ); 
        GL.End();

  //      GL.BindTexture( GL.TEXTURE_2D, 0 );
        GL.Disable( GL.TEXTURE_2D );

    }

    public static function newFromFile( filename:String ) :BitmapData {
    
        var err = GdkPixbuf.gdk_pixbuf_create_error();
        var pixbuf = GdkPixbuf.gdk_pixbuf_new_from_file( untyped filename.__s,err);
        
        var msg = GdkPixbuf.gdk_pixbuf_get_error(err);
        if( msg ) throw(msg);
        
        var w = GdkPixbuf.gdk_pixbuf_get_width( pixbuf );
        var h = GdkPixbuf.gdk_pixbuf_get_height( pixbuf );
        var f = if( GdkPixbuf.gdk_pixbuf_get_has_alpha(pixbuf) ) RGBA else RGB;
        var d = GdkPixbuf.gdk_pixbuf_get_pixels_uint( pixbuf );
        
        trace("Loading "+filename+": "+w+"x"+h+" - a?"+GdkPixbuf.gdk_pixbuf_get_has_alpha(pixbuf) );
        
        // FIXME: we steal pixel data, but the pixbuf structure should be unref'd.
        return( new BitmapData( d, w, h, f ) );
    }
    
    public static function __init__() :Void {
        GdkPixbuf.g_type_init();
    }
}