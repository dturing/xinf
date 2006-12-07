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

import xinf.event.FrameEvent;
import xinf.event.GeometryEvent;
import xinf.erno.Color;
import xinf.ony.Application;
import xinf.ony.Rectangle;

class App extends Application {
	private static var scanline:Rectangle;
	
	public function new() :Void {
		super();

		scanline = new Rectangle( Color.WHITE );
		root.attach( scanline );
		
		trace("Hello, World!");
		
		runtime.addEventListener( FrameEvent.ENTER_FRAME, onEnterFrame );
		runtime.addEventListener( GeometryEvent.STAGE_SCALED, onStageScaled );
	}
	
	public function onEnterFrame( e:FrameEvent ) :Void {
		var y = (e.frame*2) % root.size.y;
		scanline.moveTo( 0, y );
		
		trace("y: "+y+", root: "+root.size );
		scanline.moveTo( 10, y );
		scanline.resize( 100, 100 );
	}

	public function onStageScaled( e:GeometryEvent ) :Void {
		scanline.resize( e.x, 5 );
	}

	public static function main() :Void {
		new App().run();
	}
}
