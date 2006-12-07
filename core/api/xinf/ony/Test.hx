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

package xinf.ony;

import xinf.event.FrameEvent;
import xinf.erno.Color;

class Test extends Application {
	private static var scanline:Object;
	
	public function new() :Void {
		super();

		scanline = new Rectangle( Color.WHITE );
		scanline.resize( 20, 240 ); 
		scanline.moveTo( 10, 10 );
		
		root.attach( scanline );
		
		runtime.addEventListener( FrameEvent.ENTER_FRAME, frame );
		#if neko
		var i = new Image(xinf.inity.Texture.newByName("/alpha/images/testbild/testbild2320.png"));
		i.moveTo( 10, 10 );
		i.resize( 320, 240 );
		root.attach( i );
		#end
	}
	
	public function frame( e:FrameEvent ) :Void {
		var x = ((Math.sin( (e.frame/25.)*Math.PI )+1)/2)*(root.size.x-scanline.size.x);
		scanline.moveTo( x, scanline.position.y );
		scanline.resize( 20, root.size.y-20 );
	}

	public static function main() :Void {
		new Test().run();
	}
}
