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

package xinf.x11;

import xinf.geom.Point;
import xinf.inity.BitmapData;

class XBitmapData extends xinf.inity.BitmapData {
    private var fb:Dynamic;
    private var display:Dynamic;
    private var screen:Int;
    public var data:Dynamic;

    public function new( _display:Dynamic, _screen:Int ) {
        display = _display;
        screen = _screen;
        // FIXME: find w/h from X.
        data = CPtr.uint_alloc( 320*240 );
        super( data, 320, 240, RGBA  );
    }

    public function update( x:Int, y:Int, w:Int, h:Int ) {
        GL.Enable( GL.TEXTURE_2D );
        GL.BindTexture( GL.TEXTURE_2D, texture );
  
        X.GetImageRGBA( { display:display, screen:screen }, new Point(x,y), new Point(w,h), new Point(320,240), data );
        
        // FIXME: update only the updated rect, somehow.
        GL.TexSubImage2D_RGBA_BYTE( texture, new Point(0,0), new Point(320,240), data );
        
        GL.Disable( GL.TEXTURE_2D );
    }
}
