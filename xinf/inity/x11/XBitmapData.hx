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

package xinf.inity.x11;

import xinf.erno.Coord2d;
import xinf.inity.Texture;

class XBitmapData extends xinf.inity.Texture {
    private var fb:Dynamic;
    private var display:Dynamic;
    private var screen:Int;
    public var data:Dynamic;

    public function new( _display:Dynamic, _screen:Int ) {
		super();
		
        display = _display;
        screen = _screen;
		
        // FIXME: find w/h from X.
        data = CPtr.uint_alloc( 320*240 );
		initialize( 320, 240 );
    }

    public function update( x:Int, y:Int, w:Int, h:Int ) {
        // FIXME: update only the updated rect, somehow.
        X.GetImageRGBA( { display:display, screen:screen }, { x:x, y:y }, { x:w, y:h }, { x:320, y:240 }, data );
		setData( data, { x:0, y:0 }, { x:320, y:240 }, RGBA );
    }
}
