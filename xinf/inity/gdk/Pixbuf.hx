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

package xinf.inity.gdk;

import xinf.inity.ColorSpace;

class Pixbuf {
    
    private var pixbuf:Dynamic;
    
    public var width(get_width,null):Int;
    public var height(get_height,null):Int;
    public var colorspace(get_colorspace,null):ColorSpace;
    
    private function get_width():Int {
        return GdkPixbuf.gdk_pixbuf_get_width(pixbuf);
    }
    
    private function get_height():Int {
        return GdkPixbuf.gdk_pixbuf_get_height(pixbuf);
    }
    
    private function get_colorspace():ColorSpace {
        return if( GdkPixbuf.gdk_pixbuf_get_has_alpha(pixbuf) ) RGBA else RGB;
    }
    
    public function new() :Void {
    }
    
    public function stealPixels():Dynamic {
        // shoud assure it doesnt get deleted FIXME
        return GdkPixbuf.gdk_pixbuf_get_pixels_cptr( pixbuf );
    }
    
    public function uncompress( data:String ) :Void {
        var pixbufLoader = GdkPixbuf.gdk_pixbuf_loader_new();
        var err = GdkPixbuf.gdk_pixbuf_create_error();
        try {
            GdkPixbuf.gdk_pixbuf_loader_write( pixbufLoader, untyped data.__s, data.length, err );
            GdkPixbuf.gdk_pixbuf_loader_close( pixbufLoader, err );
        } catch( e:Dynamic ) {
            trace("pixbufLoader: exception "+e+", err "+GdkPixbuf.gdk_pixbuf_get_error( err ) );
        }
        pixbuf = GdkPixbuf.gdk_pixbuf_loader_get_pixbuf( pixbufLoader ); 
        var msg = GdkPixbuf.gdk_pixbuf_get_error(err);
        if( msg ) throw(msg);
    }
    
    public function compressToFile( filename:String, type:String ) :Void {
        var err = GdkPixbuf.gdk_pixbuf_create_error();
        
        GdkPixbuf.gdk_pixbuf_save_simple( pixbuf, untyped filename.__s, untyped type.__s, err );
        
        var msg = GdkPixbuf.gdk_pixbuf_get_error(err);
        if( msg!=null ) throw(msg);
    }
    
    
    public static function newFromData( data:Dynamic, width:Int, height:Int, alpha:Bool ) :Pixbuf {
        var p = new Pixbuf();
        untyped this._data = data;
        p.pixbuf = GdkPixbuf.gdk_pixbuf_new_from_rgba( data, width, height, alpha );
        return p;
    }
    
    public static function newFromFile( filename:String ) :Pixbuf {
        var p = new Pixbuf();
        p.uncompress( neko.io.File.getContent( filename ) );
        return p;
    }

    public static function __init__() :Void {
        GdkPixbuf.g_type_init();
    }
    
}
