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

class GstTexture extends Texture {
	private var sink:Dynamic;
	public function new( _sink:Dynamic ) {
		sink = _sink;
		super( 	sink.get("width"),
				sink.get("height"),
				sink.get("texture_width"),
				sink.get("texture_height"),
				sink.get("texture") );
	}

    override public function render( w:Float, h:Float, rx:Float, ry:Float, rw:Float, rh:Float ) {
		sink.produce_texture();
		super.render( w,h,rx,ry,rw,rh );
	}
}
