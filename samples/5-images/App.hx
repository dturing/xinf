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
import xinf.erno.Renderer;
import xinf.erno.ImageData;
import xinf.ony.Application;
import xinf.ony.Object;
import xinf.ony.Image;

class App extends Application {
	private static var block:Object;

	public function new() :Void {
		super();

		try {
			var i:ImageData = ImageData.load("http://xinf.org/img/xinf.gif");
			
			block = new Image(i);
			block.moveTo( 100, 100 );
			root.attach( block );
		} catch(e:Dynamic) {
			trace("Exception: "+e );
		}
	}

	public static function main() :Void {
		try {
			new App().run();
		} catch(e:Dynamic) {
			trace("Exception: "+e+": "+haxe.Stack.toString(haxe.Stack.exceptionStack()) );
		}
	}
}
