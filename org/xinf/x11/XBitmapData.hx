package org.xinf.x11;

import org.xinf.geom.Point;
import org.xinf.inity.BitmapData;

class XBitmapData extends org.xinf.inity.BitmapData {
    private var fb:Dynamic;
    private var display:Dynamic;
    private var screen:Int;

    public function new( _display:Dynamic, _screen:Int ) {
        display = _display;
        screen = _screen;
        // FIXME: find w/h from X.
        super( null, 320, 240, RGBA  );
    }

    public function update( x:Int, y:Int, w:Int, h:Int ) {
        GL.Enable( GL.TEXTURE_2D );
        GL.BindTexture( GL.TEXTURE_2D, texture );
        
        var data = X.GetImageRGBA( display, new Point(x,y), new Point(w,h), 0xff, screen );
        if( !CPtr.isValid(data) ) throw("XGetImage failed");
        GL.TexSubImage2D_RGBA_BYTE( texture, new Point(x,y), new Point(w,h), data );
        CPtr.uint_free( data );
        
        GL.Disable( GL.TEXTURE_2D );
    }
}
